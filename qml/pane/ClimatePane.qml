import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2
import '../components'

Item {
    id: climateItem
    width: parent.width * 2/3  // Takes up 2/3 of the parent width
    height: parent.height
    anchors.right: parent.right

    Text {
        anchors.centerIn: parent
        text: "Welcome to Klimaat"
        color: "white"
    }
}
