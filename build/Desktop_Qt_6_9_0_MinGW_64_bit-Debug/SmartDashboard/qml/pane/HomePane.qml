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
                            text: qsTr("Woonkamer licht")
                            font.pixelSize: 14
                            color: textColor
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignVCenter
                        }

                        Switch {
                            id: switchLiving
                            checked: false
                            Layout.alignment: Qt.AlignVCenter

                            Component.onCompleted: {
                                backend.startLightPolling("light.woonkamer")
                            }

                            onCheckedChanged: {
                                backend.toggleLight("light.woonkamer", checked)
                            }

                            Connections {
                                target: backend
                                onLightStateUpdated: switchLiving.checked = isOn
                            }
                        }
                    }

                    Slider {
                        from: 0
                        to: 100
                        value: 50
                        width: parent.width
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
                            text: qsTr("Slaapkamer licht")
                            font.pixelSize: 14
                            color: textColor
                            Layout.fillWidth: true
                            Layout.alignment: Qt.AlignVCenter
                        }

                        Switch {
                            id: switchSleep
                            checked: false
                            Layout.alignment: Qt.AlignVCenter

                            Component.onCompleted: {
                                backend.startLightPolling("light.slaapkamer")
                            }

                            onCheckedChanged: {
                                backend.toggleLight("light.slaapkamer", checked)
                            }

                            Connections {
                                target: backend
                                onLightStateUpdated: switchSleep.checked = isOn
                            }
                        }
                    }

                    Slider {
                        from: 0
                        to: 100
                        value: 50
                        width: parent.width
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
                        text: qsTr("Gang licht")
                        font.pixelSize: 14
                        color: textColor
                        Layout.fillWidth: true
                        Layout.alignment: Qt.AlignVCenter
                    }

                    Switch {
                        id: switchHall
                        checked: false
                        Layout.alignment: Qt.AlignVCenter

                        Component.onCompleted: {
                            backend.startLightPolling("light.ganglamp_licht")
                        }

                        onCheckedChanged: {
                            backend.toggleLight("light.ganglamp_licht", checked)
                        }

                        Connections {
                            target: backend
                            onLightStateUpdated: switchHall.checked = isOn
                        }
                    }
                }

                Slider {
                    from: 0
                    to: 100
                    value: 50
                    width: parent.width
                }
            }
        }
    }
}
