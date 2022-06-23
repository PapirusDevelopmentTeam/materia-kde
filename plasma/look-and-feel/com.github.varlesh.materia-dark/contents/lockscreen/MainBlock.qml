// Modified by Alexey Varfolomeev 2021 <varlesh@gmail.com>

/*
 *   Copyright 2016 David Edmundson <davidedmundson@kde.org>
 *
 *   This program is free software; you can redistribute it and/or modify
 *   it under the terms of the GNU Library General Public License as
 *   published by the Free Software Foundation; either version 2 or
 *   (at your option) any later version.
 *
 *   This program is distributed in the hope that it will be useful,
 *   but WITHOUT ANY WARRANTY; without even the implied warranty of
 *   MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *   GNU General Public License for more details
 *
 *   You should have received a copy of the GNU Library General Public
 *   License along with this program; if not, write to the
 *   Free Software Foundation, Inc.,
 *   51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.
 */
import QtQuick 2.2

import QtQuick.Layouts 1.1
import QtQuick.Controls 1.1

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents

import "../components"

SessionManagementScreen {

    property Item mainPasswordBox: passwordBox
    property bool lockScreenUiVisible: false
    property alias echoMode: passwordBox.echoMode

    //the y position that should be ensured visible when the on screen keyboard is visible
    property int visibleBoundary: mapFromItem(loginButton, 0, 0).y
    onHeightChanged: visibleBoundary = mapFromItem(loginButton, 0, 0).y + loginButton.height + units.smallSpacing

    /*
     * Login has been requested with the following username and password
     * If username field is visible, it will be taken from that, otherwise from the "name" property of the currentIndex
     */
    signal passwordResult(string password)

    function startLogin() {
        var password = passwordBox.text

        //this is partly because it looks nicer
        //but more importantly it works round a Qt bug that can trigger if the app is closed with a TextField focused
        //See https://bugreports.qt.io/browse/QTBUG-55460
        loginButton.forceActiveFocus();
        passwordResult(password);
    }

    RowLayout {
        Layout.fillWidth: true

        PlasmaComponents.TextField {
            id: passwordBox
            font.pointSize: theme.defaultFont.pointSize + 1
            Layout.fillWidth: true

            placeholderText: i18nd("plasma_lookandfeel_org.kde.lookandfeel",
                                   "Password")
            focus: true
            echoMode: TextInput.Password
            inputMethodHints: Qt.ImhHiddenText | Qt.ImhSensitiveData
                              | Qt.ImhNoAutoUppercase | Qt.ImhNoPredictiveText
            enabled: !authenticator.graceLocked
            revealPasswordButtonShown: true

            onAccepted: {
                if (lockScreenUiVisible) {
                    startLogin();
                }
            }

            //if empty and left or right is pressed change selection in user switch
            //this cannot be in keys.onLeftPressed as then it doesn't reach the password box
            Keys.onPressed: {
                if (event.key === Qt.Key_Left && !text) {
                    userList.decrementCurrentIndex();
                    event.accepted = true
                }
                if (event.key === Qt.Key_Right && !text) {
                    userList.incrementCurrentIndex();
                    event.accepted = true
                }
            }

            Connections {
                target: root
                function onClearPassword() {
                    passwordBox.forceActiveFocus()
                    passwordBox.text = "";
                }
            }
        }

        PlasmaComponents.Button {
            id: loginButton
            Accessible.name: i18nd("plasma_lookandfeel_org.kde.lookandfeel", "Unlock")
            implicitHeight: passwordBox.height
            implicitWidth: loginButton.implicitHeight
            iconSource: "go-next"
      
            onClicked: startLogin()
            Keys.onEnterPressed: clicked()
            Keys.onReturnPressed: clicked()
        }

        PlasmaComponents.Button {
            id: switchButton
            Accessible.name: i18nd("plasma_lookandfeel_org.kde.lookandfeel", "Switch User")
            implicitHeight: passwordBox.height
            implicitWidth: switchButton.implicitHeight
            iconSource: "system-switch-user"
            
            onClicked: {
                // If there are no existing sessions to switch to, create a new one instead
                if (((sessionsModel.showNewSessionEntry
                      && sessionsModel.count === 1)
                     || (!sessionsModel.showNewSessionEntry
                         && sessionsModel.count === 0))
                        && sessionsModel.canSwitchUser) {
                    mainStack.pop({
                                      "immediate": true
                                  })
                    sessionsModel.startNewSession(true /* lock the screen too */
                                                  )
                    lockScreenRoot.state = ''
                } else {
                    mainStack.push(switchSessionPage)
                }
            }
        }
    }
}
