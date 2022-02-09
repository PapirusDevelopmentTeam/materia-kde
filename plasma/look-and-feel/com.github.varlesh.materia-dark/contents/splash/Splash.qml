import QtQuick 2.5
import QtGraphicalEffects 1.0

Rectangle {
    id: root
    color: "#1e1e1e"

     property int stage
     
     property real size: units.gridUnit * 20

    onStageChanged: {
        if (stage == 1) {
            introAnimation.running = true
        }
    }

    Item {
        id: content
        anchors.fill: parent
        opacity: 0
        TextMetrics {
            id: units
            text: "M"
            property int gridUnit: boundingRect.height
            property int largeSpacing: units.gridUnit
            property int smallSpacing: Math.max(2, gridUnit/4)
        }

        Image {
            id: animation
            anchors.centerIn: parent
            source: "images/start-here-kde-animation.svg"
            sourceSize.height: size
            sourceSize.width: size
            RotationAnimator on rotation {
                id: rotationAnimator
                from: 0
                to: 360
                duration: 2000
                loops: Animation.Infinite
        }
    }
}

    OpacityAnimator {
        id: introAnimation
        running: false
        target: content
        from: 0
        to: 1
        duration: 1000
        easing.type: Easing.InOutQuad
    }
    Image {
            id: logo
            anchors.centerIn: parent
            source: "images/start-here-kde-logo.svg"
            sourceSize.height: size
            sourceSize.width: size
    }
}
