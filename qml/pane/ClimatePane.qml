import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2
import '../components'

Item {
    id: climateItem

    // Properties for sensor data
    property var temperatureData: ({
        "sensor.klimaatsensor_1_temperature": { name: "Woonkamer", value: "20.5", color: "#ff8c00" },
        "sensor.klimaatsensor_2_temperature": { name: "Badkamer", value: "22.1", color: "#4169e1" },
        "sensor.klimaatsensor_3_temperature": { name: "Slaapkamer", value: "19.8", color: "#32cd32" }
    })

    property var humidityData: ({
        "sensor.klimaatsensor_1_humidity": { name: "Woonkamer", value: "45", color: "#ff8c00" },
        "sensor.klimaatsensor_2_humidity": { name: "Badkamer", value: "65", color: "#4169e1" },
        "sensor.klimaatsensor_3_humidity": { name: "Slaapkamer", value: "42", color: "#32cd32" }
    })

    property string fanPresetMode: "Auto"
    property bool fanState: true

    // WebSocket connections for real-time updates
    Connections {
        target: backend
        function onTemperatureUpdated(entityId, temp) {
            if (temperatureData[entityId]) {
                var newData = temperatureData
                newData[entityId].value = temp
                temperatureData = newData
            }
        }

        function onHumidityUpdated(entityId, hum) {
            if (humidityData[entityId]) {
                var newData = humidityData
                newData[entityId].value = hum
                humidityData = newData
            }
        }

        function onFanStateUpdated(entityId, state, presetMode) {
            if (entityId === "fan.ecofan") {
                fanState = state
                fanPresetMode = presetMode || "Auto"
            }
        }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 16

        // Temperature and Humidity sections
        RowLayout {
            Layout.fillWidth: true
            Layout.fillHeight: true
            spacing: 16

            // Temperature Section
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: glassyBgColor
                radius: 16

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 20
                    spacing: 12

                    Text {
                        text: "Temperatuur"
                        font.pixelSize: 16
                        font.bold: true
                        color: textColor
                        Layout.fillWidth: true
                    }

                    Repeater {
                        model: Object.keys(climateItem.temperatureData)

                        Rectangle {
                            Layout.fillWidth: true
                            height: 45
                            color: Qt.rgba(1, 1, 1, 0.05)
                            radius: 8

                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: 12
                                spacing: 10

                                Rectangle {
                                    width: 4
                                    height: 25
                                    color: climateItem.temperatureData[modelData].color
                                    radius: 2
                                }

                                Text {
                                    text: climateItem.temperatureData[modelData].name
                                    color: textColor
                                    font.pixelSize: 14
                                    Layout.fillWidth: true
                                }

                                Text {
                                    text: climateItem.temperatureData[modelData].value + " °C"
                                    color: textColor
                                    font.pixelSize: 16
                                    font.bold: true
                                }
                            }
                        }
                    }
                }
            }

            // Humidity Section
            Rectangle {
                Layout.fillWidth: true
                Layout.fillHeight: true
                color: glassyBgColor
                radius: 16

                ColumnLayout {
                    anchors.fill: parent
                    anchors.margins: 20
                    spacing: 12

                    Text {
                        text: "Luchtvochtigheid"
                        font.pixelSize: 16
                        font.bold: true
                        color: textColor
                        Layout.fillWidth: true
                    }

                    Repeater {
                        model: Object.keys(climateItem.humidityData)

                        Rectangle {
                            Layout.fillWidth: true
                            height: 45
                            color: Qt.rgba(1, 1, 1, 0.05)
                            radius: 8

                            RowLayout {
                                anchors.fill: parent
                                anchors.margins: 12
                                spacing: 10

                                Rectangle {
                                    width: 4
                                    height: 25
                                    color: climateItem.humidityData[modelData].color
                                    radius: 2
                                }

                                Text {
                                    text: climateItem.humidityData[modelData].name
                                    color: textColor
                                    font.pixelSize: 14
                                    Layout.fillWidth: true
                                }

                                Text {
                                    text: climateItem.humidityData[modelData].value + "%"
                                    color: textColor
                                    font.pixelSize: 16
                                    font.bold: true
                                }
                            }
                        }
                    }
                }
            }
        }

        // Ventilation Control Section
        Rectangle {
            Layout.fillWidth: true
            Layout.preferredHeight: 120
            color: glassyBgColor
            radius: 16

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 20
                spacing: 12

                RowLayout {
                    Layout.fillWidth: true
                    Text {
                        font.family: "Font Awesome 6 Free"
                        font.pixelSize: 18
                        color: "#00d4aa"
                    }
                    Text {
                        text: "Ventilatie"
                        font.pixelSize: 16
                        font.bold: true
                        color: textColor
                        Layout.fillWidth: true
                    }
                    Text {
                        text: fanPresetMode
                        font.pixelSize: 14
                        color: "#00d4aa"
                        font.bold: true
                    }
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 10

                    // Auto Mode Button
                    Rectangle {
                        Layout.fillWidth: true
                        height: 50
                        color: fanPresetMode === "Auto" ? "#00d4aa" : Qt.rgba(1, 1, 1, 0.05)
                        radius: 8

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                fanPresetMode = "Auto"
                                // Send command via WebSocket or appropriate method
                                if (typeof backend !== 'undefined') {
                                    backend.setFanPresetMode("fan.ecofan", "Auto")
                                }
                            }
                        }

                        ColumnLayout {
                            anchors.centerIn: parent
                            spacing: 2
                            Text {
                                text: "A"
                                font.pixelSize: 16
                                font.bold: true
                                color: fanPresetMode === "Auto" ? "black" : textColor
                                Layout.alignment: Qt.AlignHCenter
                            }
                            Text {
                                text: "Auto"
                                font.pixelSize: 10
                                color: fanPresetMode === "Auto" ? "black" : textColor
                                opacity: fanPresetMode === "Auto" ? 1.0 : 0.7
                                Layout.alignment: Qt.AlignHCenter
                            }
                        }
                    }

                    // Low Mode Button
                    Rectangle {
                        Layout.fillWidth: true
                        height: 50
                        color: fanPresetMode === "Laag" ? "#00d4aa" : Qt.rgba(1, 1, 1, 0.05)
                        radius: 8

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                fanPresetMode = "Laag"
                                // Send command via WebSocket or appropriate method
                                if (typeof backend !== 'undefined') {
                                    backend.setFanPresetMode("fan.ecofan", "Laag")
                                }
                            }
                        }

                        ColumnLayout {
                            anchors.centerIn: parent
                            spacing: 2
                            Text {
                                text: "1"
                                font.pixelSize: 16
                                font.bold: true
                                color: fanPresetMode === "Laag" ? "black" : textColor
                                Layout.alignment: Qt.AlignHCenter
                            }
                            Text {
                                text: "Laag"
                                font.pixelSize: 10
                                color: fanPresetMode === "Laag" ? "black" : textColor
                                opacity: fanPresetMode === "Laag" ? 1.0 : 0.7
                                Layout.alignment: Qt.AlignHCenter
                            }
                        }
                    }

                    // High Mode Button
                    Rectangle {
                        Layout.fillWidth: true
                        height: 50
                        color: fanPresetMode === "Hoog" ? "#00d4aa" : Qt.rgba(1, 1, 1, 0.05)
                        radius: 8

                        MouseArea {
                            anchors.fill: parent
                            onClicked: {
                                fanPresetMode = "Hoog"
                                // Send command via WebSocket or appropriate method
                                if (typeof backend !== 'undefined') {
                                    backend.setFanPresetMode("fan.ecofan", "Hoog")
                                }
                            }
                        }

                        ColumnLayout {
                            anchors.centerIn: parent
                            spacing: 2
                            Text {
                                text: "2"
                                font.pixelSize: 16
                                font.bold: true
                                color: fanPresetMode === "Hoog" ? "black" : textColor
                                Layout.alignment: Qt.AlignHCenter
                            }
                            Text {
                                text: "Hoog"
                                font.pixelSize: 10
                                color: fanPresetMode === "Hoog" ? "black" : textColor
                                opacity: fanPresetMode === "Hoog" ? 1.0 : 0.7
                                Layout.alignment: Qt.AlignHCenter
                            }
                        }
                    }
                }
            }
        }
    }
}
