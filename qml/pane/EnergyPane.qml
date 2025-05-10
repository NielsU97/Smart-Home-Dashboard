import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2
import '../components'

Item {
    id: energyItem
    anchors.fill: parent

    Rectangle {
        anchors.fill: parent
        color: glassyBgColor
        radius: 16
        border.color: "#444"
        border.width: 1

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 16

            QQC2.Label {
                text: "Energiedistributie"
                font.pixelSize: 24
                color: "white"
            }

            QQC2.Label {
                id: todayUsage
                text: "Totaal verbruikt: 5.4 kWh"
                color: "white"
                font.pixelSize: 18
            }

            // Solar
            ColumnLayout {
                spacing: 4
                QQC2.Label {
                    text: "Zon: 2.1 kWh"
                    color: "#ffeb3b"
                }
                QQC2.ProgressBar {
                    value: 0.39  // 2.1 / 5.4
                    from: 0
                    to: 1
                }
            }

            // Grid
            ColumnLayout {
                spacing: 4
                QQC2.Label {
                    text: "Net: 2.5 kWh"
                    color: "#03a9f4"
                }
                QQC2.ProgressBar {
                    value: 0.46
                    from: 0
                    to: 1
                }
            }

            // Battery
            ColumnLayout {
                spacing: 4
                QQC2.Label {
                    text: "Batterij: 0.8 kWh"
                    color: "#8bc34a"
                }
                QQC2.ProgressBar {
                    value: 0.15
                    from: 0
                    to: 1
                }
            }
        }
    }
}

