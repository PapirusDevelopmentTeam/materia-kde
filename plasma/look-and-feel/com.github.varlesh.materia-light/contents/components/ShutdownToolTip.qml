import QtQuick 2.8
import QtGraphicalEffects 1.0

Rectangle {
    color: "transparent"
    width: 130
    height: 32
    border.width: 0

    Text {
        id: text
        color: "#ffffff"
        font.pixelSize: 14
        text: "Shutdown"
        anchors.fill: parent
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
    }
    DropShadow {
        anchors.fill: parent
        horizontalOffset: 1
        verticalOffset: 1
        radius: 2.0
        samples: 4
        color: "#60000000"
        source: text
    }
}
