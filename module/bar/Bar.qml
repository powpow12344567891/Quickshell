// Bar.qml
import Quickshell
import QtQuick       
import Quickshell.Services.SystemTray
import "../widget"
import "../../"

Scope {
  signal togglePanel() 
    signal toggleNotifPanel()  
    Variants {
        model: Quickshell.screens

        PanelWindow {
            required property var modelData
            screen: modelData
            anchors {
                top: true
                left: true
                right: true
              }
           
            implicitHeight: 35
           color: "#11120f"
            Item {

        anchors.fill: parent
        Rectangle {
     
            id : centerBar
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            height: parent.height - 8
            anchors.centerIn: parent

  width: 200
  color: "transparent"

   
               Workspace {     anchors.centerIn: parent}
          }

          Rectangle{
             id : leftBar
             anchors {
                        left: parent.left
                        verticalCenter: parent.verticalCenter
                        leftMargin: 4
                      }
     height: parent.height - 8
                    width: 400
                    radius: 10
      

  color: "transparent"
 Row {
   anchors.centerIn: parent

            spacing: 10
        Menu {      onMenuClicked: togglePanel()   }
  
 GestionMusic {}
  Cava {
    width: 90
    height: 30
    barCount: 12
    barWidth: 5
    barSpacing: 3
    barColor: "#efd9ce"

  }


        }
      }
   
Rectangle{
          id: rightBar
   anchors {
                        right: parent.right
                        verticalCenter: parent.verticalCenter
                        rightMargin: 4
                    }
    width: 200
          color: "transparent"

    Row {
        anchors.centerIn: parent
             spacing: 15
               Battery{}
             ClockWidget { }
 

NotificationButton {   onMenuClicked: toggleNotifPanel()}}

}
  
  
    }
  }
}
      
      
        }
    

