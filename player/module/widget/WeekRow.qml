pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts

Item {
    id: root

    property var locale: Qt.locale()
    property date date: new Date()
    property Component delegate: Text {
        required property var model
        text: model.day
    }
    property real spacing: 2

    implicitHeight: 40
    implicitWidth: rowLayout.implicitWidth

    RowLayout {
        id: rowLayout
        anchors.fill: parent
        spacing: root.spacing

        Repeater {
            model: 7

            delegate: Item {
                required property int index
                Layout.fillWidth: true
                implicitHeight: 40
                implicitWidth: 40

                property var dayModel: {
                    const firstDay = root.locale.firstDayOfWeek
                    const base = new Date(root.date)
                    const dow = base.getDay()
                    const diff = (dow - firstDay + 7) % 7
                    base.setDate(base.getDate() - diff + index)
                    const today = new Date()
                    return {
                        day: base.getDate(),
                        date: new Date(base),
                        month: base.getMonth() + 1,
                        today: base.getDate() === today.getDate()
                            && base.getMonth() === today.getMonth()
                            && base.getFullYear() === today.getFullYear()
                    }
                }

                Text {
                    anchors.centerIn: parent
                    text: parent.dayModel.day
                    color: parent.dayModel.today ? "#5588ff" : "white"
                    font.pixelSize: 13
                }
            }
        }
    }
}
