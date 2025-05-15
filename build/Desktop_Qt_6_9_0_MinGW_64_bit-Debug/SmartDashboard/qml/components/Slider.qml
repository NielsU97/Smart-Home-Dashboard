import QtQuick
import QtQuick.Controls

Slider {
    id: control
    from: 0
    to: 100
    height: 16

    handle: null

    background: Rectangle {
        implicitWidth: 200
        implicitHeight: 6
        color: "#494F56"
        radius: height / 2
    }

    contentItem: Item {
        anchors.fill: parent

        Rectangle {
            width: control.visualPosition * parent.width
            height: parent.height
            radius: height / 2
            color: "#6CE5E8"
            anchors.verticalCenter: parent.verticalCenter
        }
    }
}
