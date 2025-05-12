import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

Rectangle {
    id: lightCard
    width: 180
    height: 100
    radius: 16
    color: "#2D68F0" // Blue background, adjust to match your theme

    property alias label: lightLabel.text
    property alias checked: lightSwitch.checked
    signal toggled(bool checked)

    RowLayout {
        width: parent.width
        height: 20

        Text {
            text: qsTr('Woonkamer licht')
            font.pixelSize: 14
            color: textColor
            Layout.fillWidth: true
            Layout.alignment: Qt.AlignVCenter
        }

        Switch {
            id: lightSwitch
            checked: false
            onCheckedChanged: lightCard.toggled(checked)
        }
    }

    Progressbar {
        id: pb
        width: parent.width
        value: lightIntensity/100
    }

    RowLayout {
        anchors.fill: parent
        anchors.margins: 16
        spacing: 12

        ColumnLayout {
            spacing: 6
            Layout.fillWidth: true

            Label {
                id: lightLabel
                text: "Light"
                font.pixelSize: 16
                color: "white"
            }

            Label {
                text: checked ? "On" : "Off"
                font.pixelSize: 12
                color: "white"
            }
        }

        Switch {
            id: lightSwitch
            checked: false
            onCheckedChanged: lightCard.toggled(checked)
        }
    }
}
