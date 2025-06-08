import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts

Rectangle {
    id: root

    // Common properties
    property string icon: ""
    property string buttonText: ""
    property bool iconOnly: true
    property bool isActive: false  // For toggle states like active buttons

    // Signal for click event
    signal clicked()

    // Dimensions
    width: 80
    height: 40

    // Styling - matches climate pane ventilation buttons
    color: Qt.rgba(1, 1, 1, 0.05)
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
                color: textColor
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
                color: textColor
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                visible: text !== ""
                Layout.alignment: Qt.AlignVCenter
            }

            Text {
                text: root.buttonText
                color: textColor
                font.pointSize: 10
                horizontalAlignment: Text.AlignHCenter
                visible: text !== ""
                Layout.alignment: Qt.AlignVCenter
                Layout.fillWidth: true
            }
        }
    }

    // Mouse interaction with hover effect
    MouseArea {
        anchors.fill: parent
        onClicked: root.clicked()
        hoverEnabled: true

        onEntered: {
            root.color = Qt.rgba(1, 1, 1, 0.1)  // Slightly brighter on hover
        }

        onExited: {
            root.color = Qt.rgba(1, 1, 1, 0.05)  // Back to default
        }
    }
}
