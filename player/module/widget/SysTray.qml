import Quickshell
import Quickshell.Widgets
import Quickshell.Services.SystemTray
import QtQuick
import QtQuick.Layouts
import QtQuick.Effects

RowLayout {
    id: sysTrayRow
    spacing: 12
    height: 30

    Repeater {
        model: SystemTray.items

        MouseArea {
            id: trayItem

            property SystemTrayItem item: modelData

            implicitWidth: 20
            implicitHeight: 20

            // Menu anchor (IMPORTANT: window correcte)
            QsMenuAnchor {
                id: menu

                menu: trayItem.item.menu

                // IMPORTANT FIX: utiliser une vraie window Quickshell
                anchor.window: sysTrayRow.Window.window

                anchor.rect.x: trayItem.x
                anchor.rect.y: 30
                anchor.rect.height: trayItem.height

                anchor.edges: Edges.Bottom
            }

            onClicked: event => {
                console.log("clicked tray:", item.id, "hasMenu:", item.hasMenu)

                if (item.hasMenu && menu.menu) {
                    menu.open()
                } else {
                    item.activate()
                }

                event.accepted = true
            }

            IconImage {
                anchors.centerIn: parent
                width: parent.width
                height: parent.height
                source: trayItem.item.icon
            }

            HoverHandler {
                cursorShape: Qt.PointingHandCursor
            }
        }
    }
}
