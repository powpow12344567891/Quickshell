// ClockWidget.qml
import QtQuick
import "."

  
Text {
 id: clock
anchors.verticalCenter: parent.verticalCenter
		property var date: new Date()
    font.pointSize: 12
 font.family:"Departure Mono" 
    color :  "#efd9ce"

		Timer {
			running: true
			repeat: true
			interval: 1000

			onTriggered: clock.date = new Date();
		}

		text: {
			const hours = this.date.getHours().toString().padStart(2, '0');
			const minutes = this.date.getMinutes().toString().padStart(2, '0');
			return `${hours}:${minutes}`;
		}
	}

