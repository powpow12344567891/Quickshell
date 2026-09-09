import QtQuick
import QtQuick.Layouts
import Quickshell
import Quickshell.Io

Item {
    id: root
    implicitHeight: 60
    implicitWidth: bars.count * (barWidth + barSpacing)
      
    property int barCount: 20
    property real barWidth: 8
    property real barSpacing: 4
    property color barColor: "#5588ff"
    property var levels: Array(barCount).fill(0)

    Process {
        id: cavaProcess
        command: ["cava"]
        running: true
        stdout: SplitParser {
            onRead: line => {
                const parts = line.trim().split(";").filter(s => s !== "")
                if (parts.length > 0) {
                    root.levels = parts.map(v => Math.min(parseInt(v) / 50, 1))
                }
            }
        }
    }

    Row {
        id: bars
        anchors {
            left: parent.left
            right: parent.right
            bottom: parent.bottom
            bottomMargin: 4
            
        }
        spacing: root.barSpacing

        Repeater {
            model: root.barCount
            delegate: Rectangle {
                required property int index
                width: root.barWidth
                height: root.implicitHeight
                color: "transparent"

                Rectangle {
                    anchors.bottom: parent.bottom
                    width: parent.width
                    height: (root.levels[index] ?? 0) * root.implicitHeight
                    radius: 0
                    color: root.barColor

                    Behavior on height {
                        NumberAnimation { duration: 50 }
                    }
                }
            }
        }
    }
}

