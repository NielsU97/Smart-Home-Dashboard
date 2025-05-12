import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2
import "../components"

Item {
    id: homeItem
    anchors.fill: parent

    ColumnLayout {
        anchors.fill: parent

        // First row
        RowLayout {
            anchors.fill: parent
            spacing: 16

            // --- Living Room Light ---
            Rectangle {
                id: livinglight
                color: glassyBgColor
                radius: 16
                width: parent.width / 2
                height: 120
                Layout.preferredWidth: parent.width / 2

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

                        onValueChanged: {
                            backend.setLightBrightness("light.woonkamer", value)
                        }
                    }
                }
            }

            // --- Sleeping Room Light ---
            Rectangle {
                id: sleepingroomlight
                color: glassyBgColor
                radius: 16
                width: parent.width / 2
                height: 120
                Layout.preferredWidth: parent.width / 2

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

                        onValueChanged: {
                            backend.setLightBrightness("light.slaapkamer", value)
                        }
                    }
                }
            }
        }

        // Second row
        Rectangle {
            id: hallwaylight
            color: glassyBgColor
            radius: 16
            width: parent.width / 2
            height: 120
            Layout.preferredWidth: parent.width / 2

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

                    onValueChanged: {
                        backend.setLightBrightness("light.ganglamp_licht", value)
                    }
                }
            }
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
            }
        }
    }
}
