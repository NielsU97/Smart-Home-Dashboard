import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2

Item {
    id: rightItem
    height: parent.height
    anchors.left: middleItem.right
    anchors.right: parent.right
    anchors.leftMargin: 35

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
