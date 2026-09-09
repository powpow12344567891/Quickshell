import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell
import Quickshell.Wayland
import Quickshell.Services.Notifications
import "../../"
import "../widget/"

PanelWindow {
    id: mainPanel
    property bool isOpen: false
    property var notification_objects: []
    visible: isOpen
    exclusionMode: ExclusionMode.Ignore
    anchors {
        top: true
        right: true
    }
    margins { top: 32 }
    implicitWidth: 400
    implicitHeight: 600
    color: "transparent"

    Rectangle {
        anchors.fill: parent
             color: "#11120f"
        border.color: "#00CC12"
            border.width: 0.2           
        ColumnLayout {
            anchors {
                fill: parent
                margins: 10
            }
            spacing: 8

            // Barre d'outils
            Rectangle {
                Layout.fillWidth: true
                implicitHeight: toolRow.implicitHeight + 10
               color: "transparent"
    // border.color: "#00CC12"
      //      border.width: 1
              
                Row {
                    id: toolRow
                    spacing: 5
                    HyprPicker {}
                    Wallpaper {}
         SysTray{}

           Hyprshot {}
                }
            }

        

      
            RowLayout {
                Layout.fillWidth: true
                spacing: 8
                Text {
                    Layout.fillWidth: true
                    text: "Notifications"
                    color: "#efd9ce"   
                    font.pixelSize: 13
                }
                Text {
                    text: "Tout effacer"
                    color:  "#efd9ce"           
 font.family:"Departure Mono" 
                    font.pixelSize: 13
                    TapHandler {
                        gesturePolicy: TapHandler.ReleaseWithinBounds
                        onTapped: {
                            server.trackedNotifications.values.forEach((n) => {
                                n.tracked = false
                            })
                            notification_objects.forEach((obj) => {
                                obj.destroy()
                            })
                            notification_objects = []
                        }
                    }
                    HoverHandler {
                        acceptedDevices: PointerDevice.Mouse | PointerDevice.TouchPad
                        cursorShape: Qt.PointingHandCursor
                    }
                }
            }

     
            ScrollView {
                Layout.fillWidth: true
                Layout.fillHeight: true
                clip: true
                ColumnLayout {
                    id: content
                    width: parent.width
                    spacing: 6
                }
              }
              CalendarWidget{}
        }

        NotificationServer {
            id: server
            onNotification: (notification) => {
                notification.tracked = true
                var component = Qt.createComponent("../widget/Notification.qml")
              var obj = component.createObject(content, {
    notifId: notification.id,
    body: notification.body,
    summary: notification.summary,
})
                if (obj === null) {
                    console.log("Erreur création notification")
                } else {
                    notification_objects.push(obj)
                  }

                }

              }

        }
    


}
