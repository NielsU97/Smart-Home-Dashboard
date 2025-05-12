import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2
import "../components"

Item {
    id: energyItem
    anchors.fill: parent

    ColumnLayout {
        anchors.fill: parent
        spacing: 16

        // Title Panel
        Rectangle {
            color: glassyBgColor
            radius: 16
            Layout.fillWidth: true
            Layout.preferredHeight: 80

            QQC2.Label {
                anchors.centerIn: parent
                text: "12 mei 2025 Kalender"
                font.pixelSize: 18
                font.bold: true
                color: "white"
            }
        }

        // Metrics Panel
        Rectangle {
            color: glassyBgColor
            radius: 16
            Layout.fillWidth: true
            Layout.fillHeight: true

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 20
                spacing: 24

                QQC2.Label {
                    text: "Energie distibutie"
                    font.pixelSize: 16
                    color: "lightgray"
                    Layout.alignment: Qt.AlignHCenter
                }

                GridLayout {
                    columns: 2
                    rowSpacing: 16
                    columnSpacing: 40
                    Layout.fillWidth: true

                    EnergyMetric { icon: "☀"; label: "Zon"; value: "0.7 kWh"; color: "#ffeb3b" }
                    EnergyMetric { icon: "⚡"; label: "Net"; value: "0.3 kWh + 1.0 kWh"; color: "#03a9f4" }
                    EnergyMetric { icon: "💧"; label: "Water"; value: "132 L"; color: "#00bcd4" }
                    EnergyMetric { icon: "🌫️"; label: "Koolstofarm"; value: "0.6 kWh"; color: "#8bc34a" }
                    EnergyMetric { icon: "🏠"; label: "Thuis"; value: "1.4 kWh"; color: "#ffffff" }
                }
            }
        }
    }
}
