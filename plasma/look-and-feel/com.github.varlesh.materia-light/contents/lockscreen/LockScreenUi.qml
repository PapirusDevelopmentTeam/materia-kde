// Modified by Alexey Varfolomeev 2021 <varlesh@gmail.com>

/********************************************************************
 This file is part of the KDE project.

Copyright (C) 2014 Aleix Pol Gonzalez <aleixpol@blue-systems.com>

This program is free software; you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation; either version 2 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
*********************************************************************/
import QtQuick 2.8
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1
import QtGraphicalEffects 1.0

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 3.0 as PlasmaComponents3
import org.kde.plasma.workspace.components 2.0 as PW

import org.kde.plasma.private.sessions 2.0
import "../components"

PlasmaCore.ColorScope {

    id: lockScreenUi
    // If we're using software rendering, draw outlines instead of shadows
    // See https://bugs.kde.org/show_bug.cgi?id=398317
    readonly property bool softwareRendering: GraphicsInfo.api === GraphicsInfo.Software
    readonly property bool lightBackground: Math.max(
                                                PlasmaCore.ColorScope.backgroundColor.r,
                                                PlasmaCore.ColorScope.backgroundColor.g,
                                                PlasmaCore.ColorScope.backgroundColor.b) > 0.5

    colorGroup: PlasmaCore.Theme.ComplementaryColorGroup

    Connections {
        target: authenticator
        function onFailed() {
            root.notification = i18nd("plasma_lookandfeel_org.kde.lookandfeel",
                                      "Unlocking failed")
        }
        function onGraceLockedChanged() {
            if (!authenticator.graceLocked) {
                root.notification = ""
                root.clearPassword()
            }
        }
        function onMessage(msg) {
            root.notification = msg
        }
        function onError(err) {
            root.notification = err
        }
    }

    SessionManagement {
        id: sessionManagement
    }

    Connections {
        target: sessionManagement
        function onAboutToSuspend() {
            root.clearPassword()
        }
    }

    SessionsModel {
        id: sessionsModel
        showNewSessionEntry: false
    }

    PlasmaCore.DataSource {
        id: keystateSource
        engine: "keystate"
        connectedSources: "Caps Lock"
    }

    PlasmaCore.DataSource {
        id: executable
        engine: "executable"
        connectedSources: []
        onNewData: disconnectSource(sourceName)

        function exec(cmd) {
            executable.connectSource(cmd)
        }
    }

    function action_reBoot() {
        executable.exec('qdbus org.kde.ksmserver /KSMServer logout 0 1 2')
    }

    function action_shutDown() {
        executable.exec('qdbus org.kde.ksmserver /KSMServer logout 0 2 2')
    }

    Loader {
        id: changeSessionComponent
        active: false
        source: "ChangeSession.qml"
        visible: false
    }

    MouseArea {
        id: lockScreenRoot

        property bool uiVisible: false
        property bool blockUI: mainStack.depth > 1
                               || mainBlock.mainPasswordBox.text.length > 0
                               || inputPanel.keyboardActive

        x: parent.x
        y: parent.y
        width: parent.width
        height: parent.height
        hoverEnabled: true
        drag.filterChildren: true
        onPressed: uiVisible = true
        onPositionChanged: uiVisible = true
        onUiVisibleChanged: {
            if (blockUI) {
                fadeoutTimer.running = false
            } else if (uiVisible) {
                fadeoutTimer.restart()
            }
        }
        onBlockUIChanged: {
            if (blockUI) {
                fadeoutTimer.running = false
                uiVisible = true
            } else {
                fadeoutTimer.restart()
            }
        }
        Keys.onEscapePressed: {
            uiVisible = !uiVisible
            if (inputPanel.keyboardActive) {
                inputPanel.showHide()
            }
            if (!uiVisible) {
                root.clearPassword()
            }
        }
        Keys.onPressed: {
            uiVisible = true
            event.accepted = false
        }
        Timer {
            id: fadeoutTimer
            interval: 10000
            onTriggered: {
                if (!lockScreenRoot.blockUI) {
                    lockScreenRoot.uiVisible = false
                }
            }
        }

        Component.onCompleted: PropertyAnimation {
            id: launchAnimation
            target: lockScreenRoot
            property: "opacity"
            from: 0
            to: 1
            duration: PlasmaCore.Units.veryLongDuration * 2
        }

        states: [
            State {
                name: "onOtherSession"
                // for slide out animation
                PropertyChanges {
                    target: lockScreenRoot
                    y: lockScreenRoot.height
                }
                // we also change the opacity just to be sure it's not visible even on unexpected screen dimension changes with possible race conditions
                PropertyChanges {
                    target: lockScreenRoot
                    opacity: 0
                }
            }
        ]

        transitions: Transition {
            // we only animate switchting to another session, because kscreenlocker doesn't get notified when
            // coming from another session back and so we wouldn't know when to trigger the animation exactly
            from: ""
            to: "onOtherSession"

            PropertyAnimation {
                id: stateChangeAnimation
                properties: "y"
                duration: PlasmaCore.Units.longDuration
                easing.type: Easing.InQuad
            }
            PropertyAnimation {
                properties: "opacity"
                duration: PlasmaCore.Units.longDuration
            }

            onRunningChanged: {
                // after the animation has finished switch session: since we only animate the transition TO state "onOtherSession"
                // and not the other way around, we don't have to check the state we transitioned into
                if (/* lockScreenRoot.state == "onOtherSession" && */ !running) {
                    mainStack.currentItem.switchSession()
                }
            }
        }

        ListModel {
            id: users

            Component.onCompleted: {
                users.append({
                                 "name": kscreenlocker_userName,
                                 "realName": kscreenlocker_userName,
                                 "icon": kscreenlocker_userImage
                             })
            }
        }

        Rectangle {
            id: dialog
            color: "#f0f0f0"
            radius: 6
            anchors.centerIn: parent
            anchors.verticalCenterOffset: -20
            height: 300
            width: 400
        }
        DropShadow {
            anchors.fill: dialog
            horizontalOffset: 0
            verticalOffset: 3
            radius: 8.0
            samples: 17
            color: "#70000000"
            source: dialog
        }

        StackView {

            id: mainStack
            anchors {
                left: parent.left
                right: parent.right
            }
            height: lockScreenRoot.height + PlasmaCore.Units.gridUnit * 3
            focus: true //StackView is an implicit focus scope, so we need to give this focus so the item inside will have it

            // this isn't implicit, otherwise items still get processed for the scenegraph
            visible: opacity > 0

            initialItem: MainBlock {
                id: mainBlock
                lockScreenUiVisible: lockScreenRoot.uiVisible

                showUserList: userList.y + mainStack.y > 0

                Stack.onStatusChanged: {
                    // prepare for presenting again to the user
                    if (Stack.status == Stack.Activating) {
                        mainPasswordBox.remove(0, mainPasswordBox.length)
                        mainPasswordBox.focus = true
                    }
                }
                userListModel: users
                notificationMessage: {
                    var text = ""
                    if (keystateSource.data["Caps Lock"]["Locked"]) {
                        text += i18nd("plasma_lookandfeel_org.kde.lookandfeel",
                                      "Caps Lock is on")
                        if (root.notification) {
                            text += " • "
                        }
                    }
                    text += root.notification
                    return text
                }

                onLoginRequest: {
                    root.notification = ""
                    authenticator.tryUnlock(password)
                }
            }

            Loader {

                anchors.right: parent.right
                anchors.top: parent.top
                active: config.showMediaControls
                source: "MediaControls.qml"
            }

            Component.onCompleted: {
                if (defaultToSwitchUser) {
                    //context property
                    // If we are in the only session, then going to the session switcher is
                    // a pointless extra step; instead create a new session immediately
                    if (((sessionsModel.showNewSessionEntry
                          && sessionsModel.count === 1)
                         || (!sessionsModel.showNewSessionEntry
                             && sessionsModel.count === 0))
                            && sessionsModel.canStartNewSession) {
                        sessionsModel.startNewSession(
                                    true /* lock the screen too */
                                    )
                    } else {
                        mainStack.push({
                                           "item": switchSessionPage,
                                           "immediate": true
                                       })
                    }
                }
            }
        }

        Component {
            id: switchSessionPage
            SessionManagementScreen {
                property var switchSession: finalSwitchSession

                Stack.onStatusChanged: {
                    if (Stack.status == Stack.Activating) {
                        focus = true
                    }
                }

                userListModel: sessionsModel

                // initiating animation of lockscreen for session switch
                function initSwitchSession() {
                    lockScreenRoot.state = 'onOtherSession'
                }

                // initiating session switch and preparing lockscreen for possible return of user
                function finalSwitchSession() {
                    mainStack.pop({
                                      "immediate": true
                                  })
                    sessionsModel.switchUser(userListCurrentModelData.vtNumber)
                    lockScreenRoot.state = ''
                }

                Keys.onLeftPressed: userList.decrementCurrentIndex()
                Keys.onRightPressed: userList.incrementCurrentIndex()
                Keys.onEnterPressed: initSwitchSession()
                Keys.onReturnPressed: initSwitchSession()
                Keys.onEscapePressed: mainStack.pop()

                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: PlasmaCore.Units.largeSpacing

                    PlasmaComponents3.Button {
                        Layout.fillWidth: true
                        font.pointSize: PlasmaCore.Theme.defaultFont.pointSize + 1
                        text: i18nd("plasma_lookandfeel_org.kde.lookandfeel",
                                    "Switch to This Session")
                        onClicked: initSwitchSession()
                        visible: sessionsModel.count > 0
                    }

                    PlasmaComponents3.Button {
                        Layout.fillWidth: true
                        font.pointSize: PlasmaCore.Theme.defaultFont.pointSize + 1
                        text: i18nd("plasma_lookandfeel_org.kde.lookandfeel",
                                    "Start New Session")
                        onClicked: {
                            mainStack.pop({
                                              "immediate": true
                                          })
                            sessionsModel.startNewSession(
                                        true /* lock the screen too */
                                        )
                            lockScreenRoot.state = ''
                        }
                    }
                }

                actionItems: [
                    ActionButton {
                        iconSource: "go-previous"
                        text: i18nd("plasma_lookandfeel_org.kde.lookandfeel",
                                    "Back")
                        onClicked: mainStack.pop()
                        //Button gets cut off on smaller displays without this.
                        anchors {
                            verticalCenter: parent.top
                        }
                    }
                ]
            }
        }

        Rectangle {
            id: panel
            color: "#f9f9f9"
            height: 32
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.top: parent.top
        }

        DropShadow {
            anchors.fill: panel
            horizontalOffset: 0
            verticalOffset: 3
            radius: 8.0
            samples: 17
            color: "#70000000"
            source: panel
        }

        Row {
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.rightMargin: 30
            anchors.topMargin: 5

            Item {

                Image {
                    id: shutdown
                    height: 22
                    width: 22
                    source: "images/system-shutdown.svg"
                    fillMode: Image.PreserveAspectFit

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: {
                            shutdown.source = "images/system-shutdown-hover.svg"
                            var component = Qt.createComponent(
                                        "../components/ShutdownToolTip.qml")
                            if (component.status === Component.Ready) {
                                var tooltip = component.createObject(shutdown)
                                tooltip.x = -90
                                tooltip.y = 25
                                tooltip.destroy(600)
                            }
                        }
                        onExited: {
                            shutdown.source = "images/system-shutdown.svg"
                        }
                        onClicked: {
                            shutdown.source = "images/system-shutdown-pressed.svg"
                            onClicked: action_shutDown()
                        }
                    }
                }
            }
        }

        Row {
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.rightMargin: 60
            anchors.topMargin: 5

            Item {

                Image {
                    id: reboot
                    height: 22
                    width: 22
                    source: "images/system-reboot.svg"
                    fillMode: Image.PreserveAspectFit

                    MouseArea {
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: {
                            reboot.source = "images/system-reboot-hover.svg"
                            var component = Qt.createComponent(
                                        "../components/RebootToolTip.qml")
                            if (component.status === Component.Ready) {
                                var tooltip = component.createObject(reboot)
                                tooltip.x = -80
                                tooltip.y = 25
                                tooltip.destroy(600)
                            }
                        }
                        onExited: {
                            reboot.source = "images/system-reboot.svg"
                        }
                        onClicked: {
                            reboot.source = "images/system-reboot-pressed.svg"
                            onClicked: action_reBoot()
                        }
                    }
                }
            }
        }

        Row {
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.rightMargin: 70
            anchors.topMargin: 5
            Text {
                id: timelb
                text: Qt.formatDateTime(new Date(), "HH:mm")
                color: "#444444"
                font.pointSize: 11
            }
        }

        Timer {
            id: timetr
            interval: 500
            repeat: true
            onTriggered: {
                timelb.text = Qt.formatDateTime(new Date(), "HH:mm")
            }
        }

        PW.KeyboardLayoutSwitcher {
            id: keyboardLayoutSwitcher

            anchors.fill: parent
            acceptedButtons: Qt.NoButton
        }

        Row {
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.rightMargin: 120
            anchors.topMargin: 4
            Text {
                id: kb
                color: "#444444"
                text: keyboardLayoutSwitcher.layoutNames.shortName
                font.pointSize: 11
            }
        }
    }

    Component.onCompleted: {
        // version support checks
        if (root.interfaceVersion < 1) {
            // ksmserver of 5.4, with greeter of 5.5
            root.viewVisible = true
        }
    }
}
