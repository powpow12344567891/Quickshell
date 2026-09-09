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
    onClicked: toggleNotifPanel()
    Rectangle {
        id: contentRect
        anchors.centerIn: parent
        width: 36
        height: 32
        color: "transparent"

             Image {
 anchors.centerIn: parent
   width: 530; height: 30
  
    fillMode: Image.PreserveAspectFit
    source: menu.containsMouse ?"../../img/MorbLogo.webp" :  "../../img/MorbLogo2.webp" 
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
