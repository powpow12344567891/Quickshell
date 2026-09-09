import QtQuick
import Quickshell
import Quickshell.Io

MouseArea {
  id:  hyprpicker
  height: 30  
   width: 32
    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor
    acceptedButtons: Qt.LeftButton | Qt.RightButton

    Process {
        id: rightclickProc
        command: ["hyprpicker", "-a", "-f", "hex"]
      }
  Process {
        id: leftclickProc
        command: ["hyprpicker", "-a", "-f", "rgb"]
    }

    onClicked: (mouse) => {
        if (mouse.button === Qt.LeftButton) {
            rightclickProc.running = true
        }
        else if (mouse.button === Qt.RightButton) {
           leftclickProc.running = true
        }
    }
    Rectangle {

        id: contentRect
        anchors.centerIn: parent
        width: 36
        height: 32
        color: "transparent"

        Text {
            anchors.centerIn: parent
            text: "󰈋"
            font.pixelSize: 16
            color:  "#f0e6ff"     
           font.family:"Departure Mono" }
    }
}
