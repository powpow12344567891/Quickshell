// module/widget/Brightness.qml
import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls

ColumnLayout {
    id: root
    spacing: 5

    property real brightness: 0.5
    property int currentVal: 0
    property int maxVal: 100

    onBrightnessChanged: brightnessSlider.value = brightness

    Process {
        id: getProc
        command: ["brightnessctl", "get"]
        running: true
        stdout: SplitParser {
            onRead: data => { currentVal = parseInt(data.trim()) }
        }
    }

    Process {
        id: maxProc
        command: ["brightnessctl", "max"]
        running: true
        stdout: SplitParser {
            onRead: data => {
                maxVal = parseInt(data.trim())
                if (maxVal > 0) brightness = currentVal / maxVal
            }
        }
    }

    Process {
        id: setProc
        command: ["brightnessctl", "set", Math.round(root.brightness * root.maxVal) + ""]
    }

    RowLayout {
        Layout.alignment: Qt.AlignHCenter

        ColumnLayout {
            Text {
                Layout.alignment: Qt.AlignHCenter
                text: "󰃞"
                font.pixelSize: 20
                color: "white"
            }
            Slider {
                id: brightnessSlider
                orientation: Qt.Vertical
                from: 0.1
                to: 1.0
                height: 120
                width: 28
                onMoved: {
                    root.brightness = value
                    setProc.running = true
                }
                background: Rectangle {
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
                handle: Item { width: 0; height: 0 }
            }
        }
    }
}
