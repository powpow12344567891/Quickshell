import QtQuick
import QtQuick.Controls
import Quickshell
import Quickshell.Io

Item {
    implicitWidth: 200
    implicitHeight: 20

    property string position: "0:00"
    property string length: "0:00"
    property bool seeking: false

    function timeToSec(t) {
        var p = t.split(":")
        return parseInt(p[0]) * 60 + parseInt(p[1])
    }

    Process {
        id: posProc
        command: ["playerctl", "metadata", "--format", "{{duration(position)}}||{{duration(mpris:length)}}", "-F"]
        running: true
        stdout: SplitParser {
            onRead: data => {
                var parts = data.split("||")
                position = parts[0] || "0:00"
                length = parts[1] || "0:00"
                if (!seeking) {
                    progressSlider.value = timeToSec(position) / timeToSec(length)
                }
            }
        }
    }

    Process {
        id: seekProc
        running: false
    }

    Slider {
        id: progressSlider
        anchors.fill: parent
        from: 0
        to: 1
        value: 0

        onPressedChanged: {
            seeking = pressed
        }

        onMoved: {
            var sec = value * timeToSec(length)
            seekProc.command = ["playerctl", "position", Math.round(sec).toString()]
            seekProc.running = true
        }

        background: Rectangle {
            x: parent.leftPadding
            y: parent.topPadding + parent.availableHeight / 2 - height / 2
            width: parent.availableWidth
            height: 4
            radius: 2
            color: "black"

            Rectangle {
                width: parent.parent.visualPosition * parent.width
                height: parent.height
                radius: 2
                color: "#95dae6"
            }
        }

        handle: Rectangle {
            x: parent.leftPadding + parent.visualPosition * parent.availableWidth - width / 2
            y: parent.topPadding + parent.availableHeight / 2 - height / 2
            width: 12
            height: 12
            radius: 6
            color: "transparent"
          
        }
    }
}
