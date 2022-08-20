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

import QtQml 2.8
import QtQuick 2.8
import QtQuick.Controls 1.1
import QtQuick.Layouts 1.1
import QtGraphicalEffects 1.0

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents

import org.kde.plasma.private.sessions 2.0
import "../components"

PlasmaCore.ColorScope {

    colorGroup: PlasmaCore.Theme.ComplementaryColorGroup

    Connections {
        target: authenticator
        function onFailed() {
            if (root.notification) {
                root.notification += "\n"
            }
            root.notification += i18nd("plasma_lookandfeel_org.kde.lookandfeel","Unlocking failed");
            graceLockTimer.restart();
            notificationRemoveTimer.restart();
        }
        function onSucceeded() {
            Qt.quit();
        }

        function onInfoMessage(msg) {
            if (root.notification) {
                root.notification += "\n"
            }
            root.notification += msg;
        }

        function onErrorMessage(msg) {
            if (root.notification) {
                root.notification += "\n"
            }
            root.notification += msg;
        }
        function onPrompt(msg) {
            root.notification = msg;
            mainBlock.echoMode = TextInput.Normal
            mainBlock.mainPasswordBox.forceActiveFocus();
        }
        function onPromptForSecret(msg) {
            mainBlock.echoMode = TextInput.Password
            mainBlock.mainPasswordBox.forceActiveFocus();
        }
    }

    SessionManagement {
        id: sessionManagement
    }

    Connections {
        target: sessionManagement
        function onAboutToSuspend() {
            root.clearPassword();
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

    Loader {
        id: changeSessionComponent
        active: false
        source: "ChangeSession.qml"
        visible: false
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

    MouseArea {
        id: lockScreenRoot

        property bool calledUnlock: false
        property bool uiVisible: false
        property bool blockUI: mainStack.depth > 1 || mainBlock.mainPasswordBox.text.length > 0

        x: parent.x
        y: parent.y
        width: parent.width
        height: parent.height
        hoverEnabled: true
        drag.filterChildren: true
        onPressed: uiVisible = true;
        onPositionChanged: uiVisible = true;
        onUiVisibleChanged: {
            if (blockUI) {
                fadeoutTimer.running = false;
            } else if (uiVisible) {
                fadeoutTimer.restart();
            }
            if (!calledUnlock) {
                calledUnlock = true
                authenticator.tryUnlock();
            }
        }
        onBlockUIChanged: {
            if (blockUI) {
                fadeoutTimer.running = false;
                uiVisible = true;
            } else {
                fadeoutTimer.restart();
            }
        }
        Keys.onEscapePressed: {
            uiVisible = !uiVisible;
            if (!uiVisible) {
                root.clearPassword();
            }
        }
        Keys.onPressed: {
            uiVisible = true;
            event.accepted = false;
        }
        Timer {
            id: fadeoutTimer
            interval: 10000
            onTriggered: {
                if (!lockScreenRoot.blockUI) {
                    lockScreenRoot.uiVisible = false;
                }
            }
        }
        
        Timer {
            id: notificationRemoveTimer
            interval: 3000
            onTriggered: root.notification = ""
        }
        Timer {
            id: graceLockTimer
            interval: 3000
            onTriggered: {
                root.clearPassword();
                authenticator.tryUnlock();
            }
        }

        Component.onCompleted: PropertyAnimation { id: launchAnimation; target: lockScreenRoot; property: "opacity"; from: 0; to: 1; duration: 1000 }

        states: [
            State {
                name: "onOtherSession"
                // for slide out animation
                PropertyChanges { target: lockScreenRoot; y: lockScreenRoot.height }
                // we also change the opacity just to be sure it's not visible even on unexpected screen dimension changes with possible race conditions
                PropertyChanges { target: lockScreenRoot; opacity: 0 }
            }
        ]

        transitions:
            Transition {
            // we only animate switchting to another session, because kscreenlocker doesn't get notified when
            // coming from another session back and so we wouldn't know when to trigger the animation exactly
            from: ""
            to: "onOtherSession"

            PropertyAnimation { id: stateChangeAnimation; properties: "y"; duration: 300; easing.type: Easing.InQuad}
            PropertyAnimation { properties: "opacity"; duration: 300}

            onRunningChanged: {
                // after the animation has finished switch session: since we only animate the transition TO state "onOtherSession"
                // and not the other way around, we don't have to check the state we transitioned into
                if (/* lockScreenRoot.state == "onOtherSession" && */ !running) {
                    mainStack.currentItem.switchSession()
                }
            }
        }

        WallpaperFader {
            anchors.fill: parent
            state: lockScreenRoot.uiVisible ? "on" : "off"
            source: wallpaper
            mainStack: mainStack
            clock: clock
        }

        DropShadow {
            id: clockShadow
            anchors.fill: clock
            source: clock
            horizontalOffset: 1
            verticalOffset: 1
            radius: 6
            samples: 14
            spread: 0.1
            // Soften the color a bit so it doesn't look so stark against light backgrounds
            color: "#000000"
            Behavior on opacity {
                OpacityAnimator {
                    duration: units.veryLongDuration * 2
                    easing.type: Easing.InOutQuad
                }
            }
        }

        Clock {
            id: clock
            property Item shadow: clockShadow
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.verticalCenter: parent.verticalCenter
            anchors.verticalCenterOffset: -50
            y: (mainBlock.userList.y + mainStack.y) / 2 - height / 2
            visible: y > 0
            Layout.alignment: Qt.AlignBaseline
        }

        ListModel {
            id: users

            Component.onCompleted: {
                users.append({name: kscreenlocker_userName,
                                realName: kscreenlocker_userName,
                                icon: kscreenlocker_userImage,

                })
            }
        }

        StackView {
            id: mainStack
            anchors {
                left: parent.left
                right: parent.right
            }
            height: lockScreenRoot.height
            focus: true //StackView is an implicit focus scope, so we need to give this focus so the item inside will have it
            
            Rectangle {
            id: dialog
            color: "#272727"
            radius: 6
            anchors.centerIn: parent
            anchors.verticalCenterOffset: -50
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

            initialItem: MainBlock {
                id: mainBlock
                lockScreenUiVisible: lockScreenRoot.uiVisible

                showUserList: userList.y + mainStack.y > 0
                
                enabled: !graceLockTimer.running

                Stack.onStatusChanged: {
                    // prepare for presenting again to the user
                    if (Stack.status == Stack.Activating) {
                        mainPasswordBox.remove(0, mainPasswordBox.length)
                        mainPasswordBox.focus = true
                        root.notification = ""
                    }
                }
                userListModel: users
                notificationMessage: {
                    var text = ""
                    if (keystateSource.data["Caps Lock"]["Locked"]) {
                        text += i18nd("plasma_lookandfeel_org.kde.lookandfeel","Caps Lock is on")
                        if (root.notification) {
                            text += " • "
                        }
                    }
                    text += root.notification
                    return text
                }

                 onPasswordResult: {
                    authenticator.respond(password)
                }
            }
            
            Loader {
        id: inputPanel
        property bool keyboardActive: false
        source: "../components/VirtualKeyboard.qml"
    }

                Loader {
            id: mediaControlsComponent
            anchors.right: parent.right
            anchors.left: parent.left
            anchors.top: parent.top
            active: config.showMediaControls
            source: "MediaControls.qml"
        }

        Loader {
            anchors.top: parent.top
            anchors.right: parent.right
            anchors.left: parent.left
            id: panelUIComponent
            active: true
            source: "PanelUI.qml"
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
                    mainStack.pop({immediate:true})
                    sessionsModel.switchUser(userListCurrentModelData.vtNumber)
                    lockScreenRoot.state = ''
                }

                Keys.onLeftPressed: userList.decrementCurrentIndex()
                Keys.onRightPressed: userList.incrementCurrentIndex()
                Keys.onEnterPressed: initSwitchSession()
                Keys.onReturnPressed: initSwitchSession()
                Keys.onEscapePressed: mainStack.pop()

                
                PlasmaComponents.Button {
                    id: switchButton
                    implicitHeight: 36
                    // the magic "-1" vtNumber indicates the "New Session" entry
                    text: userListCurrentModelData.vtNumber === -1 ? i18nd("plasma_lookandfeel_org.kde.lookandfeel", "Start New Session") : i18nd("plasma_lookandfeel_org.kde.lookandfeel", "Switch Session")
                    onClicked: initSwitchSession()
                
                PlasmaComponents.Button {
                    id: backButton
                    implicitHeight: 36
                    anchors.left: switchButton.right
                    iconSource: "go-previous"
                    Accessible.name: i18nd("plasma_lookandfeel_org.kde.lookandfeel","Back")
                    onClicked: mainStack.pop()
                }
                }

            }
        }

    }

    Component.onCompleted: {
        // version support checks
        if (root.interfaceVersion < 1) {
            // ksmserver of 5.4, with greeter of 5.5
            root.viewVisible = true;
        }
    }
}
