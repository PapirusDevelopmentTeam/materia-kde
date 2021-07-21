// Modified by Alexey Varfolomeev 2021 <varlesh@gmail.com>


/********************************************************************
 This file is part of the KDE project.

Copyright (C) 2016 Kai Uwe Broulik <kde@privat.broulik.de>

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
import QtQuick 2.5
import QtQuick.Layouts 1.1
import QtGraphicalEffects 1.0

import org.kde.plasma.core 2.0 as PlasmaCore
import org.kde.plasma.components 2.0 as PlasmaComponents
import org.kde.plasma.extras 2.0 as PlasmaExtras

Item {
    visible: mpris2Source.hasPlayer
    implicitHeight: controlsRow.height + controlsRow.y

        Rectangle {
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.topMargin: 60
        anchors.rightMargin: 20
        id: widget
        color: "#121212"
        radius: 6
        height: 80
        width: 300
    }

    DropShadow {
        anchors.fill: widget
        horizontalOffset: 0
        verticalOffset: 3
        radius: 8.0
        samples: 17
        color: "#70000000"
        source: widget
    }

    RowLayout {
        id: controlsRow
        anchors.right: parent.right
        anchors.top: parent.top
        anchors.topMargin: 80
        anchors.rightMargin: 30
        spacing: 0

        enabled: mpris2Source.canControl

        PlasmaCore.DataSource {
            id: mpris2Source

            readonly property string source: "@multiplex"
            readonly property var playerData: data[source]

            readonly property bool hasPlayer: sources.length > 1 && !!playerData
            readonly property string identity: hasPlayer ? playerData.Identity : ""
            readonly property bool playing: hasPlayer && playerData.PlaybackStatus === "Playing"
            readonly property bool canControl: hasPlayer && playerData.CanControl
            readonly property bool canGoBack: hasPlayer && playerData.CanGoPrevious
            readonly property bool canGoNext: hasPlayer && playerData.CanGoNext

            readonly property var currentMetadata: hasPlayer ? playerData.Metadata : ({})

            readonly property string track: {
                var xesamTitle = currentMetadata["xesam:title"]
                if (xesamTitle) {
                    return xesamTitle
                }
                // if no track title is given, print out the file name
                var xesamUrl = currentMetadata["xesam:url"] ? currentMetadata["xesam:url"].toString(
                                                                  ) : ""
                if (!xesamUrl) {
                    return ""
                }
                var lastSlashPos = xesamUrl.lastIndexOf('/')
                if (lastSlashPos < 0) {
                    return ""
                }
                var lastUrlPart = xesamUrl.substring(lastSlashPos + 1)
                return decodeURIComponent(lastUrlPart)
            }
            readonly property string artist: currentMetadata["xesam:artist"]
                                             || ""
            readonly property string albumArt: currentMetadata["mpris:artUrl"]
                                               || ""

            engine: "mpris2"
            connectedSources: [source]

            function startOperation(op) {
                var service = serviceForSource(source)
                var operation = service.operationDescription(op)
                return service.startOperationCall(operation)
            }

            function goPrevious() {
                startOperation("Previous")
            }
            function goNext() {
                startOperation("Next")
            }
            function playPause(source) {
                startOperation("PlayPause")
            }
        }
        
        Image {
            id: albumArt
            Layout.preferredWidth: height
            Layout.fillHeight: true
            asynchronous: true
            fillMode: Image.PreserveAspectFit
            source: mpris2Source.albumArt
            sourceSize.height: 40
            visible: status === Image.Loading || status === Image.Ready
        }

        Item {
            // spacer
            width: units.smallSpacing
            height: 1
        }

        ColumnLayout {
            Layout.maximumWidth: 150
            Layout.minimumWidth: 150
            spacing: 0

            PlasmaComponents.Label {
                id: trackinfo
                Layout.fillWidth: true
                wrapMode: Text.NoWrap
                elide: Text.ElideRight
                text: mpris2Source.track || i18nd("plasma_lookandfeel_org.kde.lookandfeel", "No media playing")
                textFormat: Text.PlainText
                font.pointSize: theme.defaultFont.pointSize + 1
                maximumLineCount: 1
                color: "#dfdfdf"
            }

            PlasmaExtras.DescriptiveLabel {
                Layout.fillWidth: true
                wrapMode: Text.NoWrap
                elide: Text.ElideRight
                // if no artist is given, show player name instead
                text: mpris2Source.artist || mpris2Source.identity || ""
                textFormat: Text.PlainText
                font.pointSize: theme.smallestFont.pointSize + 1
                maximumLineCount: 1
                color: "#dfdfdf"
            }
        }

        PlasmaComponents.Button {
            enabled: mpris2Source.canGoBack
            iconName: "media-skip-backward"
            onClicked: mpris2Source.goPrevious()
            visible: mpris2Source.canGoBack
            Accessible.name: i18nd("plasma_lookandfeel_org.kde.lookandfeel", "Previous track")
        }

        PlasmaComponents.Button {
            iconName: mpris2Source.playing ? "media-playback-pause" : "media-playback-start"
            onClicked: mpris2Source.playPause()
            Accessible.name: i18nd("plasma_lookandfeel_org.kde.lookandfeel", "Play or Pause media")
        }

        PlasmaComponents.Button {
            enabled: mpris2Source.canGoNext
            iconName: "media-skip-forward"
            onClicked: mpris2Source.goNext()
            visible: mpris2Source.canGoNext
            Accessible.name: i18nd("plasma_lookandfeel_org.kde.lookandfeel", "Next track")
        }
    }
}
