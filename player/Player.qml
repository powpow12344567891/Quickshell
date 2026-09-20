// module/widget/Music.qml
import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Layouts
import Qt5Compat.GraphicalEffects
import "./module/widget"

    PanelWindow {
   property bool panelVisible: false
    visible: panelVisible
    color: "transparent"
    implicitWidth: 500
    implicitHeight: 200
   exclusionMode: ExclusionMode.Ignore
      anchors {
        right: true
        
      }
    margins { right: 5 }
           Timer {
        id: closeTimer
        interval: 5000
        running: true
        repeat: false
    onTriggered: root.panelVisible = false   // au lieu de Qt.quit()
      }       

    Rectangle {

        id: musicRoot  
        color: "transparent"
        implicitWidth: 500
        implicitHeight: 200
  
        property string trackTitle: "Rien en cours"
        property string trackArtist: ""
        property string artUrl: ""
        property string position: "0:00"
        property string length: "0:00"
        property string playbackStatus: "Stopped"
 MouseArea {
            anchors.fill: parent
            hoverEnabled: true
            propagateComposedEvents: true 
            onEntered: closeTimer.restart()
            onExited: closeTimer.restart()
        }
Text {
    anchors.top: parent.top
    anchors.right: parent.right
    anchors.margins: 8
    text: "✕"
    color: closeMouse.containsMouse ? "#efd9ce" : "#666666"
    font.pixelSize: 14
    z: 10
    Behavior on color { ColorAnimation { duration: 150 } }
    MouseArea {
        id: closeMouse
        anchors.fill: parent
        
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
           onClicked: root.panelVisible = false
    }
}
        Process {
            id: artProc
            command: ["playerctl", "metadata", "--format", "{{mpris:artUrl}}", "-F"]
            running: true
            stdout: SplitParser {
                onRead: data => { musicRoot.artUrl = data.trim() }  // <-- use musicRoot.
            }
        }

        Process {
            id: posProc
            command: ["playerctl", "metadata", "--format", "{{duration(position)}}||{{duration(mpris:length)}}", "-F"]
            running: true
            stdout: SplitParser {
                onRead: data => {
                    var parts = data.split("||")
                    musicRoot.position = parts[0] || "0:00"  // <-- use musicRoot.
                    musicRoot.length = parts[1] || "0:00"
                }
            }
        }

        Process {
            id: metadataProc
            command: ["playerctl", "metadata", "--format", "{{artist}}||{{title}}", "-F"]
            running: true
            stdout: SplitParser {
                onRead: data => {
                    var parts = data.split("||")
                    musicRoot.trackArtist = parts[0] || ""  // <-- use musicRoot.
                    musicRoot.trackTitle = parts[1] || "Rien en cours"
                }
            }
        }

        Process {
            id: statusProc
            command: ["playerctl", "status", "-F"]
            running: true
            stdout: SplitParser {
                onRead: data => { musicRoot.playbackStatus = data.trim() } 
            }
        }

        RowLayout {
            anchors.fill: parent
            spacing: 10

          
            Rectangle {
                id: rotatingBox
                Layout.alignment: Qt.AlignHCenter
                width: 180
                height: 180
                color: "#1a1b2e"
                radius: 250
      
                border.color: "#00CC12"
                      border.width: 2
                RotationAnimator {
                    target: rotatingBox
                    from: 0
                    to: 360
                    duration: 20000
                    running: true
                    loops: Animation.Infinite
                }

                Image {
                    anchors.fill: parent
                    anchors.margins: 6
                    fillMode: Image.PreserveAspectCrop
                    source: musicRoot.artUrl
                    visible: musicRoot.artUrl !== ""
                    layer.enabled: true
                    layer.effect: OpacityMask {
                        maskSource: mask
                    }
                }

                Rectangle {
                    id: mask
                    width: 500
                    height: 500
                    radius: 250
                    visible: false
                }

                Text {
                    anchors.centerIn: parent
                    text: "♪"
                    font.pixelSize: 36
                    color: "#efd9ce"
                    visible: musicRoot.artUrl === ""
                }
              }
              Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: "#11120f"
                radius: 2
 border.color: "#00CC12"
                      border.width: 1
                ColumnLayout {
                    anchors.centerIn: parent
                    width: parent.width - 20
                    spacing: 3

                    Text {
                        Layout.alignment: Qt.AlignHCenter
                        text: musicRoot.trackTitle
                        color: "#efd9ce"
                        font.pixelSize: 20
                        font.family : "Departure Mono"
                        font.bold: true
                        elide: Text.ElideRight
                        Layout.maximumWidth: parent.width
                    }

                    Text {
                        Layout.alignment: Qt.AlignHCenter
                        text: musicRoot.trackArtist
                        color: "#aaaaaa"
                        font.pixelSize: 11
                        font.family : "Departure Mono"
                        elide: Text.ElideRight
                        Layout.maximumWidth: parent.width
                        visible: text !== ""
                    }

                    Text {
                        Layout.alignment: Qt.AlignHCenter
                        text: musicRoot.position + " / " + musicRoot.length
                        color: "#aaaaaa"
                        font.family : "Departure Mono"
                        font.pixelSize: 11
                    }

                    RowLayout {
                        Layout.alignment: Qt.AlignHCenter
                        spacing: 24

                        Text {
                            text: "󰼨"
                            font.pixelSize: 36
                            color: prevMouse.containsMouse ? "#00CC12" : "#888888"
                            Behavior on color { ColorAnimation { duration: 150 } }
                            MouseArea {
                                id: prevMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: prevProc.running = true
                            }
                            Process { id: prevProc; command: ["playerctl", "previous"] }
                        }

                        Text {
                            text: musicRoot.playbackStatus === "Playing" ? "󰏤" : "󰐊"
                            font.pixelSize: 36
                            color: playMouse.containsMouse ? "#00CC12" : "#888888"
                            Behavior on color { ColorAnimation { duration: 150 } }
                            MouseArea {
                                id: playMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: playProc.running = true
                            }
                            Process { id: playProc; command: ["playerctl", "play-pause"] }
                        }

                        Text {
                            text: "󰼧"
                            font.pixelSize: 36
                            color: nextMouse.containsMouse ?  "#00CC12" : "#888888"
                            Behavior on color { ColorAnimation { duration: 150 } }
                            MouseArea {
                                id: nextMouse
                                anchors.fill: parent
                                hoverEnabled: true
                                cursorShape: Qt.PointingHandCursor
                                onClicked: nextProc.running = true
                            }
                            Process { id: nextProc; command: ["playerctl", "next"] }
                          }


                        }
      ProgressionMusic {
          Layout.alignment: Qt.AlignHCenter

    Layout.maximumWidth: parent.width - 40 
        }
  Cava {
            Layout.fillWidth: true
            Layout.maximumHeight: 60  
 
            barCount: 20
            barWidth: 15
            barSpacing: 2
            barColor:"#efd9ce"
            implicitHeight: 60



        }
                }            }
        }
    }
  }

