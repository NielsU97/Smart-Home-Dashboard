import QtQuick
import QtQuick.Layouts

Item {
    id: middleItem
    width: 152
    height: parent.height
    anchors.left: leftItem.right
    anchors.leftMargin: 22

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


