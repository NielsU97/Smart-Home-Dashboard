import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2
import "../components"

Item {
    id: homeItem
    anchors.fill: parent

    // Main layout container
    ColumnLayout {
        anchors.fill: parent
        spacing: 16

        // First row with two light controls
        GridLayout {
            columns: 2
            columnSpacing: 16
            rowSpacing: 16
            Layout.fillWidth: true

            // --- Living Room Light ---
            Rectangle {
                id: livinglight
                color: glassyBgColor
                radius: 16
                height: 120
                Layout.fillWidth: true

                Column {
                    anchors.fill: parent
                    anchors.margins: 12
                    spacing: 8

                    RowLayout {
                        width: parent.width
                        height: 20

                        Text {
                            text: qsTr("Woonkamer")
                            font.pixelSize: 14
                            color: textColor
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignVCenter
                        }

                        Switch {
                            id: switchLiving
                            checked: false
                            Layout.alignment: Qt.AlignVCenter

                            onCheckedChanged: {
                                backend.toggleLight("light.woonkamer", checked)
                            }
                        }
                    }

                    Text {
                        text: sliderLiving.value.toFixed(0) + "%"
                        font.pixelSize: 12
                        color: textColor
                    }

                    Slider {
                        id: sliderLiving
                        from: 0
                        to: 100
                        value: 0
                        width: parent.width

                        onPressedChanged: {
                            if (!pressed) {
                                backend.setLightBrightness("light.woonkamer", value)
                            }
                        }
                    }
                }
            }

            // --- Sleeping Room Light ---
            Rectangle {
                id: sleepingroomlight
                color: glassyBgColor
                radius: 16
                height: 120
                Layout.fillWidth: true

                Column {
                    anchors.fill: parent
                    anchors.margins: 12
                    spacing: 8

                    RowLayout {
                        width: parent.width
                        height: 20

                        Text {
                            text: qsTr("Slaapkamer")
                            font.pixelSize: 14
                            color: textColor
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignVCenter
                        }

                        Switch {
                            id: switchSleep
                            checked: false
                            Layout.alignment: Qt.AlignVCenter

                            onCheckedChanged: {
                                backend.toggleLight("light.slaapkamer", checked)
                            }
                        }
                    }

                    Text {
                        text: sliderSleep.value.toFixed(0) + "%"
                        font.pixelSize: 12
                        color: textColor
                    }

                    Slider {
                        id: sliderSleep
                        from: 0
                        to: 100
                        value: 0
                        width: parent.width

                        onPressedChanged: {
                            if (!pressed) {
                                backend.setLightBrightness("light.slaapkamer", value)
                            }
                        }
                    }
                }
            }

            // --- Hallway Light ---
            Rectangle {
                id: hallwaylight
                color: glassyBgColor
                radius: 16
                height: 120
                Layout.fillWidth: true

                Column {
                    anchors.fill: parent
                    anchors.margins: 12
                    spacing: 8

                    RowLayout {
                        width: parent.width
                        height: 20

                        Text {
                            text: qsTr("Gang")
                            font.pixelSize: 14
                            color: textColor
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignVCenter
                        }

                        Switch {
                            id: switchHallway
                            checked: false
                            Layout.alignment: Qt.AlignVCenter

                            onCheckedChanged: {
                                backend.toggleLight("light.ganglamp_licht", checked)
                            }
                        }
                    }

                    Text {
                        text: sliderHallway.value.toFixed(0) + "%"
                        font.pixelSize: 12
                        color: textColor
                    }

                    Slider {
                        id: sliderHallway
                        from: 0
                        to: 100
                        value: 0
                        width: parent.width

                        onPressedChanged: {
                            if (!pressed) {
                                backend.setLightBrightness("light.ganglamp_licht", value)
                            }
                        }
                    }
                }
            }

            // --- Storage Light ---
            Rectangle {
                id: storageLight
                color: glassyBgColor
                radius: 16
                height: 120
                Layout.fillWidth: true
                //Layout.columnSpan: 2  // Make it span both columns

                Column {
                    anchors.fill: parent
                    anchors.margins: 12
                    spacing: 8

                    RowLayout {
                        width: parent.width
                        height: 20

                        Text {
                            text: qsTr("Techniekhok")
                            font.pixelSize: 14
                            color: textColor
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignVCenter
                        }

                        Switch {
                            id: switchStorage
                            checked: false
                            Layout.alignment: Qt.AlignVCenter

                            onCheckedChanged: {
                                backend.toggleLight("light.berginglamp_licht", checked)
                            }
                        }
                    }
                }
            }
        }

        // Add some spacing at the bottom
        Item {
            Layout.fillHeight: true
        }
    }

    Connections {
        target: backend
        function onLightStateUpdated(entityId, isOn, brightness) {
            if (entityId === "light.woonkamer") {
                switchLiving.checked = isOn;
                sliderLiving.value = brightness;
            } else if (entityId === "light.slaapkamer") {
                switchSleep.checked = isOn;
                sliderSleep.value = brightness;
            } else if (entityId === "light.ganglamp_licht") {
                switchHallway.checked = isOn;
                sliderHallway.value = brightness;
            } else if (entityId === "light.berginglamp_licht") {
                switchStorage.checked = isOn;
            }
        }
    }
}
