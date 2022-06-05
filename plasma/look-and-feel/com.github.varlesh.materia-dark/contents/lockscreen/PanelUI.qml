
// Copyright Alexey Varfolomeev 2021 <varlesh@gmail.com>
import QtQuick 2.8
import QtQuick.Controls 1.1
import QtGraphicalEffects 1.0
import org.kde.plasma.workspace.components 2.0 as PW

import "../components"

Item {

    Rectangle {
        anchors.right: parent.right
        anchors.left: parent.left
        anchors.top: parent.top
        id: panel
        color: "#121212"
        height: 32
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
            color: "#dfdfdf"
            font.pointSize: 11
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
            color: "#dfdfdf"
            text: keyboardLayoutSwitcher.layoutNames.shortName
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
}
