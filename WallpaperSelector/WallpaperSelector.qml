import Quickshell
import Quickshell.Io
import QtQuick
import QtQuick.Controls
import Quickshell.Wayland
PanelWindow {
    implicitWidth: 1600
    implicitHeight: 1000
    color: "transparent"
    WlrLayershell.keyboardFocus: WlrKeyboardFocus.Exclusive
    ListModel { id: wallpaperModel }
    ListModel { id: filteredModel }

    Timer {
        id: closeTimer
        interval: 500
        onTriggered: Qt.quit()
    }

    Process {
        id: setter
        onExited: running = false
    }

    Process {
        id: finder
        command: ["find", "/home/powpow/Pictures/wallpapers/brut", "-maxdepth", "1", "-type", "f"]
        running: true
        stdout: SplitParser {
            onRead: data => {
                var p = data.trim()
                if (p !== "") {
                    wallpaperModel.append({ path: p })
                    filteredModel.append({ path: p })
                }
            }
        }
    }

    function applyFilter(query) {
        filteredModel.clear()
        for (var i = 0; i < wallpaperModel.count; i++) {
            var p = wallpaperModel.get(i).path
            if (p.toLowerCase().includes(query.toLowerCase()))
                filteredModel.append({ path: p })
        }
    }

    function applyWallpaper(path) {
        setter.command = ["bash", "-c",
            "awww img '" + path + "' --transition-step 50 --transition-fps 60 --transition-type grow"
        ]
        setter.running = false
        setter.running = true
        closeTimer.start()
    }

    Column {
        anchors.fill: parent

        // Barre de recherche
        Rectangle {
            width: 1600
            height: 50
            color: "#222222"

     TextField {
    id: searchBox
    anchors.fill: parent
    anchors.margins: 10
    color: "white"
    font.pixelSize: 20
    focus: true
    placeholderText: "Rechercher..."
    background: Item {}

    onTextChanged: applyFilter(text)

    Keys.onEscapePressed: Qt.quit()
    Keys.onReturnPressed: {
        if (filteredModel.count > 0)
            applyWallpaper(filteredModel.get(grid.currentIndex).path)
    }
    Keys.onPressed: event => {
        if (event.key === Qt.Key_Down) { grid.forceActiveFocus(); event.accepted = true }
    }
}
        }

        // Grille
        ScrollView {
            width: 1600
            height: 1200
            ScrollBar.vertical.policy: ScrollBar.AlwaysOn

            GridView {
              id: grid
 MouseArea {
        anchors.fill: parent
        propagateComposedEvents: true
        onWheel: wheel => {
            grid.contentY -= wheel.angleDelta.y * 3
            wheel.accepted = true
        }
        onClicked: mouse => mouse.accepted = false
    }
                width: 1300
  height: 1230
                cellWidth: 400
                cellHeight: 350
                model: filteredModel
                cacheBuffer: 700
                keyNavigationEnabled: true
                focus: true

                Keys.onEscapePressed: Qt.quit()
                Keys.onReturnPressed: {
                    if (currentIndex >= 0)
                        applyWallpaper(filteredModel.get(currentIndex).path)
                }
                Keys.onPressed: event => {
                    if (event.key === Qt.Key_Up && currentIndex < 3)
                        searchBox.forceActiveFocus()
                }

                delegate: Item {
                    width: 450
                    height: 350

                    Image {
                        anchors.fill: parent
                        anchors.margins: 4
                        source: "file://" + model.path
                        fillMode: Image.PreserveAspectCrop
                        asynchronous: true
                        sourceSize.width: 450
                        sourceSize.height: 350
                    }

                    Rectangle {
                        anchors.fill: parent
                        anchors.margins: 4
                        color: "transparent"
                        border.color: grid.currentIndex === index ? "white" : "transparent"
                        border.width: 3
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: applyWallpaper(model.path)
                    }
                }
            }
        }
    }
}
