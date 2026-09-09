import QtQuick
import Quickshell
import Quickshell.Io

MouseArea {
  id:  wallpaper
  height: 30
 width: 25
    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor
    acceptedButtons: Qt.LeftButton | Qt.RightButton

    Process {
        id: rightclickProc
        command: ["bash","/home/powpow/scripts/wall.sh"]
      }
  Process {
        id: leftclickProc
        command: [  "quickshell", "-c","/home/powpow/.config/quickshell/WallpaperSelector"]
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
            text: "󰏘"
            font.pixelSize: 16
            color: "#f0e6ff"               }
    }
}
