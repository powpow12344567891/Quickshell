pragma ComponentBehavior: Bound
import QtQml
import QtQuick
import QtQuick.Controls
import QtQuick.Layouts
import Quickshell

Item {
    id: root

    property Component delegate: Text {
        required property var model
        text: model.day
    }
    property int paddingWeeks: 2
    property var locale: Qt.locale()

    function scrollMonthsAndSnap(x) {
        const focusedDate = root.focusedDate;
        const focusedMonth = focusedDate.getMonth();
        const focusedYear = focusedDate.getFullYear();
        const targetMonth = focusedMonth + x;
        const targetDate = new Date(focusedYear, targetMonth, 1);
        const currentFirstShownDate = new Date(root.dateInFirstWeek.getTime() + (root.paddingWeeks * root.millisPerWeek));
        const diffMillis = targetDate.getTime() - currentFirstShownDate.getTime();
        const diffWeeks = Math.round(diffMillis / root.millisPerWeek);
        root.targetWeekDiff += diffWeeks;
    }

    property int weeksPerScroll: 1
    property real targetWeekDiff: 0
    property real weekDiff: targetWeekDiff
    property int contentWeekDiff: weekDiff
    property bool scrolling: false

    Behavior on weekDiff {
        NumberAnimation { duration: 250; easing.type: Easing.OutCubic }
    }

    Timer {
        id: scrollAnimationCheckTimer
        interval: 30
        onTriggered: root.scrolling = false
    }
    onWeekDiffChanged: {
        scrolling = true;
        scrollAnimationCheckTimer.restart();
    }

    MouseArea {
        anchors.fill: parent
        onWheel: wheel => {
            root.targetWeekDiff += wheel.angleDelta.y / 120 * -root.weeksPerScroll;
        }
    }

    readonly property int millisPerWeek: 7 * 24 * 60 * 60 * 1000
    readonly property int totalWeeks: 6 + (paddingWeeks * 2)
    readonly property int focusedWeekIndex: 2
    readonly property int focusDayOfWeekIndex: 6

    property date dateInFirstWeek: {
        const currentDate = new Date();
        const firstDayThisMonth = new Date(currentDate.getFullYear(), currentDate.getMonth(), 1);
        return new Date(firstDayThisMonth.getTime() - (paddingWeeks * millisPerWeek) + contentWeekDiff * millisPerWeek);
    }

    property date focusedDate: {
        const addedTime = (root.paddingWeeks + root.focusedWeekIndex) * root.millisPerWeek;
        const d = new Date(root.dateInFirstWeek.getTime() + addedTime);
        // Aller au dernier jour de la semaine
        const firstDay = root.locale.firstDayOfWeek;
        const currentDay = d.getDay();
        const offset = (root.focusDayOfWeekIndex - ((currentDay - firstDay + 7) % 7) + 7) % 7;
        return new Date(d.getTime() + offset * 24 * 60 * 60 * 1000);
    }

    property int focusedMonth: focusedDate.getMonth() + 1

    property real verticalPadding: 0
    property real buttonSize: 40
    property real buttonSpacing: 2
    property real buttonVerticalSpacing: buttonSpacing

    implicitHeight: (6 * buttonSize) + (5 * buttonVerticalSpacing) + (2 * verticalPadding)
    implicitWidth: weeksColumn.implicitWidth
    clip: true

    ColumnLayout {
        id: weeksColumn
        anchors {
            left: parent.left
            right: parent.right
        }
        y: {
            const spacePerExtraRow = root.buttonSize + root.buttonVerticalSpacing;
            const origin = -(spacePerExtraRow * root.paddingWeeks);
            const diff = root.weekDiff * spacePerExtraRow;
            return origin + (-diff % spacePerExtraRow) + root.verticalPadding;
        }
        spacing: root.buttonVerticalSpacing

        Repeater {
            model: root.totalWeeks

            WeekRow {
                required property int index
                locale: root.locale
                date: new Date(root.dateInFirstWeek.getTime() + (index * root.millisPerWeek))
                Layout.fillWidth: true
                spacing: root.buttonSpacing
                delegate: root.delegate
            }
        }
    }
}
