import QtQuick
import QtQuick.Controls

Label {
    property real size: 28
    property string icon

    text: icon
    color: textColor
    font.pixelSize: size
    font.family: fontawesomefontloader.name
}
