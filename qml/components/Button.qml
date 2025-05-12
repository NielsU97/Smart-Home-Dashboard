import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts

Rectangle {
    id: root

    // Common properties
    property string icon: ""
    property string buttonText: ""
    property color bgColor: "#2C3E50"       // Default background
    property color activeColor: "#34495E"   // Hover/active color
    property color textColor: "#A0A0A0"
    property bool iconOnly: true

    // Signal for click event
    signal clicked()

    // Dimensions
    width: 80
    height: 40

    // Styling
    color: bgColor
    radius: 8

    // Dynamic content based on iconOnly
    Loader {
        anchors.fill: parent
        sourceComponent: root.iconOnly ? iconOnlyContent : iconWithTextContent
    }

    // Icon-only centered layout
    Component {
        id: iconOnlyContent

        Item {
            anchors.fill: parent

            Text {
                anchors.centerIn: parent
                text: root.icon
                font.family: "Arial"
                font.pointSize: 14
                color: root.textColor
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
        }
    }

    // Icon + text layout
    Component {
        id: iconWithTextContent

        RowLayout {
            anchors.centerIn: parent
            spacing: 6
            width: parent.width - 12

            Text {
                text: root.icon
                font.family: "Arial"
                font.pointSize: 12
                color: root.textColor
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                visible: text !== ""
                Layout.alignment: Qt.AlignVCenter
            }

            Text {
                text: root.buttonText
                color: root.textColor
                font.pointSize: 10
                horizontalAlignment: Text.AlignHCenter
                visible: text !== ""
                Layout.alignment: Qt.AlignVCenter
                Layout.fillWidth: true
            }
        }
    }

    // Mouse interaction
    MouseArea {
        anchors.fill: parent
        onClicked: root.clicked()

        hoverEnabled: true
        onEntered: root.color = activeColor
        onExited: root.color = bgColor
    }
}
