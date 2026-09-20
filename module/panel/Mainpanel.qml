import Quickshell
import QtQuick
import Quickshell.Io
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell.Services.Pipewire
import "../widget"

PanelWindow {
  id: mainPanel
   property bool panelVisible: false
    visible: panelVisible
    property int currentTab: 0
    exclusionMode: ExclusionMode.Ignore
    anchors { top: true }
    margins { top: 80 }
    implicitWidth: 550
    implicitHeight: 450
    color: "transparent"

    Rectangle {
        anchors.fill: parent
        color: "#11120f"
        radius: 2
      border.color: "#00CC12"
            border.width: 1
        ColumnLayout {
            anchors {
                fill: parent
                margins: 10
            }
            spacing: 8

   

            // Onglet 0 : Main
            RowLayout {
   anchors.centerIn: parent
                Layout.fillWidth: true
                Layout.fillHeight: true
            
                spacing: 8

                PwNodeLinkTracker {
                    id: linkTracker
                    node: Pipewire.defaultAudioSink
                  }
                Volume {
                node: Pipewire.defaultAudioSink
                    Layout.fillWidth: true
                }
                Luminosite {
                    Layout.fillWidth: true
                }
              
              ColumnLayout{  
              Rectangle {
                width: animation.width; 
                height: animation.height;
               AnimatedImage { 
    id: animation 
    source: Quickshell.configDir + "/img/ely.gif"
    playing: true
    width: 200      
    height: 200

  }      

    }
}     }


 // Onglet 2

        }
    }
}
