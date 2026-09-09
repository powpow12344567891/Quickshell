// module/panel/PanelState.qml
import Quickshell

Singleton {
    id: panelState
    property bool open: false

    function toggle() {
        panelState.open = !panelState.open
    }
}
