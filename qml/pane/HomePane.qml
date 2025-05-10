import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2
import '../components'

Item {
    id: homeItem
    width: parent.width * 2/3  // Takes up 2/3 of the parent width
    height: parent.height
    anchors.right: parent.right

    RowLayout {
        anchors.fill: parent
        spacing: 22

        Item {
            id: middleSection
            Layout.preferredWidth: homeItem.width * 0.35  // Adjust as needed
            Layout.fillHeight: true

            ColumnLayout {
                anchors.fill: parent
                spacing: 16

                // Temperature
                Rectangle {
                    color: glassyBgColor
                    radius: 16
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    Item {
                        anchors.fill: parent
                        anchors.margins: 24

                        Text {
                            text: qsTr("Temperature")
                            font.pixelSize: 14
                            color: textColor
                            anchors.top: parent.top
                            anchors.left: parent.left
                        }

                        Text {
                            id: tempValue
                            text: temperature
                            font.pixelSize: 24
                            color: textColor
                            anchors.bottom: parent.bottom
                            anchors.horizontalCenter: parent.horizontalCenter

                            Text {
                                text: qsTr("°C")
                                font.pixelSize: 16
                                color: textColor
                                anchors.top: parent.top
                                anchors.left: parent.right
                                visible: true
                            }
                        }

                        Text {
                            text: qsTr("°C")
                            font.pixelSize: 16
                            color: textColor
                            visible: false
                            anchors.top: tempValue.bottom
                            anchors.right: tempValue.right
                        }
                    }
                }

                // Humidity
                Rectangle {
                    color: glassyBgColor
                    radius: 16
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    Item {
                        anchors.fill: parent
                        anchors.margins: 24

                        Text {
                            text: qsTr("Humidity")
                            font.pixelSize: 14
                            color: textColor
                            anchors.top: parent.top
                            anchors.left: parent.left
                        }

                        Text {
                            id: humidityValue
                            text: humidity
                            font.pixelSize: 24
                            color: textColor
                            anchors.bottom: parent.bottom
                            anchors.horizontalCenter: parent.horizontalCenter

                            Text {
                                text: qsTr("%")
                                font.pixelSize: 16
                                color: textColor
                                anchors.top: parent.top
                                anchors.left: parent.right
                                visible: true
                            }
                        }

                        Text {
                            text: qsTr("%")
                            font.pixelSize: 16
                            color: textColor
                            visible: false
                            anchors.top: humidityValue.bottom
                            anchors.right: humidityValue.right
                        }
                    }
                }

                // Heating
                Rectangle {
                    color: glassyBgColor
                    radius: 16
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    Item {
                        anchors.fill: parent
                        anchors.margins: 24

                        Text {
                            text: qsTr("Heating")
                            font.pixelSize: 14
                            color: textColor
                            anchors.top: parent.top
                            anchors.left: parent.left
                        }

                        Text {
                            id: heatingValue
                            text: heating
                            font.pixelSize: 24
                            color: textColor
                            anchors.bottom: parent.bottom
                            anchors.horizontalCenter: parent.horizontalCenter

                            Text {
                                text: qsTr("°C")
                                font.pixelSize: 16
                                color: textColor
                                anchors.top: parent.top
                                anchors.left: parent.right
                                visible: true
                            }
                        }

                        Text {
                            text: qsTr("°C")
                            font.pixelSize: 16
                            color: textColor
                            visible: false
                            anchors.top: heatingValue.bottom
                            anchors.right: heatingValue.right
                        }
                    }
                }

                // Water (with alignUnitsRight: false)
                Rectangle {
                    color: glassyBgColor
                    radius: 16
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    Item {
                        anchors.fill: parent
                        anchors.margins: 24

                        Text {
                            text: qsTr("Water")
                            font.pixelSize: 14
                            color: textColor
                            anchors.top: parent.top
                            anchors.left: parent.left
                        }

                        Text {
                            id: waterValue
                            text: water
                            font.pixelSize: 24
                            color: textColor
                            anchors.bottom: parent.bottom
                            anchors.horizontalCenter: parent.horizontalCenter

                            Text {
                                text: qsTr("kpa")
                                font.pixelSize: 16
                                color: textColor
                                anchors.top: parent.top
                                anchors.left: parent.right
                                visible: false
                            }
                        }

                        Text {
                            text: qsTr("kpa")
                            font.pixelSize: 16
                            color: textColor
                            visible: true
                            anchors.top: waterValue.bottom
                            anchors.right: waterValue.right
                        }
                    }
                }
            }
        }

        Item {
            id: rightSection
            Layout.fillWidth: true
            Layout.fillHeight: true

            ColumnLayout {
                anchors.fill: parent
                spacing: 16

                Rectangle {
                    color: glassyBgColor
                    radius: 16
                    Layout.fillWidth: true
                    Layout.fillHeight: true

                    Item {
                        anchors.fill: parent
                        anchors.margins: 24

                        property real maxcircularbarwidth: Math.min(width, height) - 24

                        CircularProgressBar {
                            width: parent.maxcircularbarwidth
                            height: parent.maxcircularbarwidth
                            anchors.centerIn: parent
                            knobBackgroundColor: '#48709F'
                            knobColor: '#5CE1E6'
                            from: 0
                            to: 100
                            value: 50
                            lineWidth: 16

                            Item {
                                anchors.fill: parent
                                anchors.margins: 16

                                Text {
                                    text: commafy(powerConsumed)
                                    font.pixelSize: 50
                                    color: textColor
                                    anchors.centerIn: parent

                                    Text {
                                        text: qsTr('Power')
                                        font.pixelSize: 16
                                        color: textColor

                                        anchors.bottom: parent.top
                                        anchors.bottomMargin: 8
                                        anchors.left: parent.left
                                    }

                                    Text {
                                        text: qsTr('kW')
                                        font.pixelSize: 14
                                        color: textColor

                                        anchors.top: parent.bottom
                                        anchors.right: parent.right
                                    }
                                }
                            }
                        }
                    }
                }

                Rectangle {
                    color: glassyBgColor
                    radius: 16
                    Layout.fillWidth: true
                    Layout.preferredHeight: lightswitchescol.height + 48

                    Item {
                        anchors.fill: parent
                        anchors.margins: 24
                        height: lightswitchescol.height

                        Column {
                            id: lightswitchescol
                            width: parent.width
                            spacing: 16

                            LightSwitch {
                                label: qsTr('Windows')
                                checked: true
                            }

                            LightSwitch {
                                label: qsTr('Blinders')
                                checked: true
                            }

                            LightSwitch{
                                label: qsTr('Curtains')
                                checked: false
                            }
                        }
                    }
                }

                Rectangle {
                    color: glassyBgColor
                    radius: 16
                    Layout.fillWidth: true
                    Layout.preferredHeight: lightintensityitemcol.height + 48

                    Item {
                        anchors.fill: parent
                        anchors.margins: 24
                        height: lightintensityitemcol.height

                        Column {
                            id: lightintensityitemcol
                            width: parent.width
                            spacing: 16

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
                                    Layout.alignment: Qt.AlignVCenter

                                    Component.onCompleted: {
                                        backend.startLightPolling("light.woonkamer");
                                    }

                                    onCheckedChanged: {
                                        backend.toggleLight("light.woonkamer", checked);
                                    }

                                    Connections {
                                        target: backend
                                        onLightStateUpdated: lightSwitch.checked = isOn;
                                    }
                                }
                            }

                            Progressbar {
                                id: pb
                                width: parent.width
                                value: lightIntensity/100
                            }

                            Text {
                                text: Math.round(pb.value * 100)
                                font.pixelSize: 14
                                color: textColor
                                width: parent.width
                                horizontalAlignment: Text.AlignRight
                            }
                        }
                    }
                }
            }
        }
    }
}
