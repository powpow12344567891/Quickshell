import QtQuick
import Quickshell
import Quickshell.Io

MouseArea {
    id: batteryArea

    property int batteryLevel: 0
    property bool charging: false

    width: contentRect.width + 20
    height: parent.height
    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor

    // Lecture du niveau de batterie
    Process {
        id: batteryProc
        command: ["bash", "-c", "cat /sys/class/power_supply/BAT0/capacity"]
        running: true
        stdout: SplitParser {
            onRead: data => {
                let val = parseInt(data.trim())
                if (!isNaN(val)) batteryArea.batteryLevel = val
            }
        }
    }

    // Lecture de l'état charge/décharge
    Process {
        id: statusProc
        command: ["bash", "-c", "cat /sys/class/power_supply/BAT0/status"]
        running: true
        stdout: SplitParser {
            onRead: data => {
                batteryArea.charging = data.trim() === "Charging"
            }
        }
    }

    // Rafraîchissement toutes les 30 secondes
    Timer {
        interval: 10000
        repeat: true
        running: true
        onTriggered: {
            batteryProc.running = true
            statusProc.running = true
        }
    }

    Rectangle {
        id: contentRect
        anchors.centerIn: parent
        width: 60
        height: 30
        color: "transparent"

        Row {
            id: batteryRow
            anchors.centerIn: parent
            spacing: 6

            Text {
                text: {
                    if (batteryArea.charging) return "󰂄"
                    let level = batteryArea.batteryLevel
                    if (level >= 95) return "󰁹"
                    else if (level >= 90) return "󰂂"
                    else if (level >= 80) return "󰂁"
                    else if (level >= 70) return "󰂀"
                    else if (level >= 60) return "󰁿"
                    else if (level >= 50) return "󰁾"
                    else if (level >= 40) return "󰁽"
                    else if (level >= 30) return "󰁼"
                    else if (level >= 20) return "󰁻"
                    else if (level >= 10) return "󰁺"
                    else return "󰂃"

                }
                font.pixelSize: 15
             
 font.family:"Departure Mono" 
                anchors.verticalCenter: parent.verticalCenter
                color: batteryArea.charging ?  "#efd9ce"
:
                       batteryArea.batteryLevel > 50 ? "#efd9ce"
 :
                       batteryArea.batteryLevel > 20 ? "yellow" : "red"
            }

            Text {
                text: batteryArea.batteryLevel + "%"
                font.pixelSize: 15
 font.family:"Departure Mono" 
                anchors.verticalCenter: parent.verticalCenter
                color: batteryArea.charging ?   "#efd9ce"
:
                       batteryArea.batteryLevel > 50 ?  "#efd9ce"
 :
                       batteryArea.batteryLevel > 20 ? "yellow" : "red"

            }
        }
    }
}
