import QtQuick
import Quickshell
import Quickshell.Io
import "../panel"
import "../../"

MouseArea {
    signal menuClicked() 
    id: menu
    height: 30  
   width: 40
    hoverEnabled: true
    cursorShape: Qt.PointingHandCursor
    //onClicked: togglePanel()

    acceptedButtons: Qt.LeftButton | Qt.RightButton



  Process {
        id: leftclickProc
        command: ["wlogout"]
    }

    onClicked: (mouse) => {
        if (mouse.button === Qt.LeftButton) {
          togglePanel()
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
        Image {
 anchors.centerIn: parent
 width: 36; height: 30

    fillMode: Image.PreserveAspectFit
    source: menu.containsMouse ?"../../img/elyLogo.svg" :  "../../img/elyLogo2.png" 
    smooth: true
    antialiasing: true
    mipmap: true
   onStatusChanged: {
        if (status === Image.Error)
            console.log("Erreur chargement image:", source)
    }
}
       
    }
}
