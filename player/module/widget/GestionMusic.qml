import Quickshell
import Quickshell.Io
import QtQuick

Rectangle {
    color: "transparent"
    implicitWidth: row.implicitWidth + 16
    implicitHeight: 32

    property string trackTitle: "Pas de musique"
    property string trackArtist: ""
    property string playbackStatus: "Stopped"
    property string position: "0:00"
    property string length: "0:00"

    Process {
        id: posProc
        command: ["playerctl", "metadata", "--format", "{{duration(position)}}||{{duration(mpris:length)}}", "-F"]
        running: true
        stdout: SplitParser {
            onRead: data => {
                var parts = data.split("||")
                position = parts[0] || "0:00"
                length = parts[1] || "0:00"
            }
        }
    }

    Process {
        id: metadataProc
        command: ["playerctl", "metadata", "--format", "{{artist}}||{{title}}", "-F"]
        running: true
        stdout: SplitParser {
            onRead: data => {
                var parts = data.split("||")
                trackArtist = parts[0] || ""
                trackTitle = parts[1] || "..."
            }
        }
    }

    Process {
        id: statusProc
        command: ["playerctl", "status", "-F"]
        running: true
        stdout: SplitParser {
            onRead: data => { playbackStatus = data.trim() }
        }
    }

    Row {
        id: row
        anchors.centerIn: parent
        spacing: 8

        Text {
            text: trackTitle
         
            font.pixelSize: 12
            width: 90
            elide: Text.ElideRight
            anchors.verticalCenter: parent.verticalCenter
            font.family:"Departure Mono" 
            color : "#efd9ce"
         }

        Text {
            text: position + " / " + length
            color: "#aaaaaa"
            font.pixelSize: 11
 font.family:"Departure Mono" 
            anchors.verticalCenter: parent.verticalCenter
        }

        Text {
            text: "󰼨"
            font.pixelSize: 16
 font.family:"Departure Mono" 
            color: prevMouse.containsMouse ?  "#efd9ce": "#efd9ce"
            anchors.verticalCenter: parent.verticalCenter
            Behavior on color { ColorAnimation { duration: 150 } }
            MouseArea {
                id: prevMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: prevProc.running = true
            }
            Process { id: prevProc; command: ["playerctl", "previous"] }
        }

        Text {
            text: playbackStatus === "Playing" ? "󰏤" : "󰐊"
            font.pixelSize: 16
 font.family:"Departure Mono" 
            color: playMouse.containsMouse ? "#efd9ce": "#efd9ce"
            anchors.verticalCenter: parent.verticalCenter
            Behavior on color { ColorAnimation { duration: 150 } }
            MouseArea {
                id: playMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: playProc.running = true
            }
            Process { id: playProc; command: ["playerctl", "play-pause"] }
        }

        Text {
            text: "󰼧"
            font.pixelSize: 16
 font.family:"Departure Mono" 
 color: nextMouse.containsMouse ?  "#efd9ce":  "#efd9ce"
 anchors.verticalCenter: parent.verticalCenter
            Behavior on color { ColorAnimation { duration: 150 } }
            MouseArea {
                id: nextMouse
                anchors.fill: parent
                hoverEnabled: true
                cursorShape: Qt.PointingHandCursor
                onClicked: nextProc.running = true
            }
            Process { id: nextProc; command: ["playerctl", "next"] }
        }
    }
}
