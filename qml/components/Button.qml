import QtQuick
import QtQuick.Controls as QQC2
import QtQuick.Layouts

Rectangle {
    id: root
    // Common properties
    property string icon: ""           // For Unicode/text icons
    property url iconSource: ""        // For SVG/image icons
    property string buttonText: ""
    property bool iconOnly: true
    property bool isActive: false
    property color iconColor: "white"  // Color for text icons

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

            // SVG/Image icon - displayed as-is
            Image {
                id: svgIcon
                anchors.centerIn: parent
                source: root.iconSource
                width: Math.min(parent.width * 0.6, 24)
                height: Math.min(parent.height * 0.6, 24)
                fillMode: Image.PreserveAspectFit
                visible: root.iconSource.toString() !== ""
            }

            // Fallback to text icon
            Text {
                anchors.centerIn: parent
                text: root.icon
                font.family: "Arial"
                font.pointSize: 14
                color: root.iconColor
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                visible: root.iconSource.toString() === "" && text !== ""
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

            // SVG/Image icon - displayed as-is
            Image {
                id: svgIconWithText
                source: root.iconSource
                Layout.preferredWidth: 16
                Layout.preferredHeight: 16
                fillMode: Image.PreserveAspectFit
                visible: root.iconSource.toString() !== ""
                Layout.alignment: Qt.AlignVCenter
            }

            // Fallback text icon
            Text {
                text: root.icon
                font.family: "Arial"
                font.pointSize: 12
                color: root.iconColor
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                visible: root.iconSource.toString() === "" && text !== ""
                Layout.alignment: Qt.AlignVCenter
            }

            Text {
                text: root.buttonText
                color: root.iconColor
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
            root.color = Qt.rgba(1, 1, 1, 0.1)
        }
        onExited: {
            root.color = Qt.rgba(1, 1, 1, 0.05)
        }
    }
}
