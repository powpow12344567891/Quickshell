import QtQuick
import QtQuick.Layouts
import QtQuick.Controls
import Quickshell.Services.Pipewire

ColumnLayout {
	required property PwNode node;
	PwObjectTracker { objects: [ node ] }


  Button {
 Layout.alignment: Qt.AlignHCenter

 text: node.audio.muted ?   "" : ""
      palette.buttonText: "white"
            font.pixelSize: 20
      onClicked: node.audio.muted = !node.audio.muted
      background: Rectangle {
            color: "transparent"
        }

		}

    Slider {
  Layout.alignment: Qt.AlignHCenter

	   orientation: Qt.Vertical
  
    value: node.audio.volume
    onValueChanged: node.audio.volume = value
    height: 120
    width: 28

    background: 
  
    Rectangle {
        x: parent.leftPadding + parent.availableWidth / 2 - width / 2
        y: parent.topPadding
        width: 20
        height: parent.availableHeight
      
        color: "#1a1a2e"

        Rectangle {
            width: parent.width
            y: parent.height - height
            height: (1.0 - parent.parent.visualPosition) * parent.height
          
            color: "#00CC12"

          }
        }
      


    handle: Item { width: 0; height: 0 }		}

}
