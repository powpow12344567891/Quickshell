// shell.qml
import QtQuick
import Quickshell
import Quickshell.Hyprland
import Quickshell.Io

ShellRoot {
    id: root
    property bool panelVisible: false

    IpcHandler {
        target: "player"
        function toggle(): void { root.panelVisible = !root.panelVisible }
        function show(): void { root.panelVisible = true }
        function hide(): void { root.panelVisible = false }
    }

    Player {
        panelVisible: root.panelVisible
    }
}
