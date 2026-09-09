import QtQuick

Text {
    required property int notifId
    required property string body
    required property string summary
    property int margin
    text: `- ${summary}: ${body}`
    color: "#f0e6ff"
    font.pixelSize: 13
    wrapMode: Text.WordWrap
}
