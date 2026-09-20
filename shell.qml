//@ pragma UseQApplication
import Quickshell
import Quickshell.Io
import QtQuick
import "./module/bar" as Taskbar
import "./module/panel" as Panel
import "."

Scope {
  property bool panelOpen: false
  property bool notifOpen: false

  IpcHandler {
      target: "panel"
      function toggle(): void { panelOpen = !panelOpen }
      function show(): void { panelOpen = true }
      function hide(): void { panelOpen = false }
  }

  Taskbar.Bar {

     onTogglePanel: panelOpen = !panelOpen
     onToggleNotifPanel: notifOpen = !notifOpen
  }

  Panel.Mainpanel {
    panelVisible: panelOpen
  }

  Panel.NotificationPanel {
    isOpen: notifOpen
  }

  NotificationsPopup {}

  Variants {
      model: Quickshell.screens
      PanelWindow {
          required property var modelData; screen: modelData
          anchors.bottom: true; anchors.right: true; margins.right: Settings.companionsMarginRight
          exclusionMode: ExclusionMode.Ignore; color: "transparent"
          implicitWidth: compItem.implicitWidth
          implicitHeight: compItem.implicitHeight
      }
  }
}
