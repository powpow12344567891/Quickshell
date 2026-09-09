 //@ pragma UseQApplication
import Quickshell // for PanelWindow
import QtQuick // for Text
import "./module/bar" as Taskbar
import "./module/panel" as Panel
import "." 
Scope {
  property bool panelOpen: false
  property bool notifOpen: false 

   Taskbar.Bar { 
     onTogglePanel: panelOpen = !panelOpen 
        onToggleNotifPanel: notifOpen = !notifOpen       
   }
   Panel.Mainpanel {
  isOpen: panelOpen
}
Panel.NotificationPanel{
    isOpen: notifOpen
  }
NotificationsPopup {}
    Variants {
        model:Quickshell.screens
        PanelWindow {
            required property var modelData;screen:modelData
            anchors.bottom:true;anchors.right:true;margins.right:Settings.companionsMarginRight
            exclusionMode:ExclusionMode.Ignore;color:"transparent"
                       implicitWidth:  compItem.implicitWidth
    implicitHeight: compItem.implicitHeight

    
      //      Companions{id:compItem;anchors.fill:parent}
        }
    }
 }
