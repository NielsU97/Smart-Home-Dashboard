// EnergyMetric.qml
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2

ColumnLayout {
    property string icon: ""
    property string label: ""
    property string value: ""
    property color color: "white"

    spacing: 4

    QQC2.Label {
        text: icon + " " + label
        color: parent.color
        font.pixelSize: 14
        font.bold: true
    }

    QQC2.Label {
        text: value
        color: "white"
        font.pixelSize: 12
    }
}
