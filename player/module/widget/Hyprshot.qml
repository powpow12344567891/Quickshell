import QtQuick
import Quickshell
import Quickshell.Io

MouseArea {
    id: hyprshot
    height: 30  
   width: 32
    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor

    Process {
        id: screenshotProc
        command: ["hyprshot", "-m", "region", "--clipboard-only"]
    }

    onClicked: screenshotProc.running = true

    Rectangle {
        id: contentRect
        anchors.centerIn: parent
        width: 30
        height: 32
        color: "transparent"

        Text {
            anchors.centerIn: parent
            text: "󰄀"
            font.pixelSize: 16
            color :   "#f0e6ff"   
 font.family:"Departure Mono" 
        }
    }
}
