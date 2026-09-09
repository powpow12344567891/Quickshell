pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell

Rectangle {
    id: root
    property bool collapsed: false
    property var locale: Qt.locale()
    implicitHeight: collapsed ? 0 : contentColumn.implicitHeight
    implicitWidth: contentColumn.implicitWidth
    color: "transparent"
    clip: true

    Behavior on implicitHeight {
        NumberAnimation { duration: 200; easing.type: Easing.OutCubic }
    }

    ColumnLayout {
        id: contentColumn
        spacing: 12

        RowLayout {
            Layout.topMargin: 10
            Layout.leftMargin: 8
            Layout.rightMargin: 8
            spacing: 8

            Text {
                Layout.fillWidth: true
                text: Qt.locale().toString(calendarView.focusedDate, "MMMM yyyy")
                font.pixelSize: 16
                font.bold: true
                color: "#efd9ce"            }
            Button {
                text: "▲"
                implicitWidth: 32; implicitHeight: 34
                onClicked: calendarView.scrollMonthsAndSnap(-1)
            }
            Button {
                text: "▼"
                implicitWidth: 32; implicitHeight: 34
                onClicked: calendarView.scrollMonthsAndSnap(1)
            }
        }

        ColumnLayout {
            Layout.fillWidth: true
            Layout.leftMargin: 5
            Layout.rightMargin: 5
            spacing: 1

            // Remplacement de DayOfWeekRow
            RowLayout {
                Layout.fillWidth: true
                spacing: calendarView.buttonSpacing

                Repeater {
                    model: {
                        const first = root.locale.firstDayOfWeek
                        const names = []
                        for (let i = 0; i < 7; i++) {
                            const d = new Date(2024, 0, 7 + ((first + i) % 7))
                            names.push(root.locale.dayName(d.getDay(), Locale.ShortFormat).substring(0, 2))
                        }
                        return names
                    }
                    delegate: Item {
                        required property string modelData
                        Layout.fillWidth: true
                        implicitHeight: calendarView.buttonSize
                        Text {
                            anchors.centerIn: parent
                            text: modelData
                            color: "#aaaaaa"
                            font.pixelSize: 13
                        }
                    }
                }
            }

            CalendarView {
                id: calendarView
                locale: root.locale
                verticalPadding: 2
                buttonSize: 41
                buttonSpacing: 6
                buttonVerticalSpacing: 1
                Layout.fillWidth: true

                delegate: Item {
                    id: dayButton
                    required property var model
                    required property int index
                    implicitWidth: calendarView.buttonSize
                    implicitHeight: calendarView.buttonSize

                    Rectangle {
                        anchors.centerIn: parent
                        width: parent.width - 4
                        height: parent.height - 4
                        radius: height / 2
                        color: dayButton.model.today ?"#efd9ce": "transparent"
                    }
                    Text {
                        anchors.centerIn: parent
                        text: dayButton.model.day
                        font.pixelSize: 14
                        color: {
                            if (dayButton.model.today) return "white"
                            if (dayButton.model.month !== calendarView.focusedMonth) return "#555"
                            return "#ddd"
                        }
                    }
                }
            }
        }
    }
}
