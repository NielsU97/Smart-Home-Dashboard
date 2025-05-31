import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2
import '../components'

Item {
    id: climateItem

    Rectangle {
        anchors.fill: parent
        color: glassyBgColor
        radius: 16

        Text {
            anchors.centerIn: parent
            text: "Klimaat"
            color: "white"
        }
    }
}

