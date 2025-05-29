import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2
import "../components"

Item {
    id: homeItem
    anchors.fill: parent

    // Keep track of user-initiated changes to avoid feedback loops
    property bool userSwitchingLiving: false
    property bool userSwitchingSleep: false
    property bool userSwitchingHallway: false
    property bool userSwitchingStorage: false
    property bool userSlidingLiving: false
    property bool userSlidingSleep: false
    property bool userSlidingHallway: false

    Connections {
        target: backend
        function onLightStateUpdated(entityId, isOn, brightness) {
            if (entityId === "light.woonkamer") {
                // Only update switch if change wasn't initiated by user switch
                if (!userSwitchingLiving) {
                    switchLiving.checked = isOn;
                }
                // Always update brightness slider unless user is currently sliding
                if (!userSlidingLiving) {
                    sliderLiving.value = brightness;
                }
                userSwitchingLiving = false;
            } else if (entityId === "light.slaapkamer") {
                if (!userSwitchingSleep) {
                    switchSleep.checked = isOn;
                }
                if (!userSlidingSleep) {
                    sliderSleep.value = brightness;
                }
                userSwitchingSleep = false;
            } else if (entityId === "light.ganglamp_licht") {
                if (!userSwitchingHallway) {
                    switchHallway.checked = isOn;
                }
                if (!userSlidingHallway) {
                    sliderHallway.value = brightness;
                }
                userSwitchingHallway = false;
            } else if (entityId === "light.berginglamp_licht") {
                if (!userSwitchingStorage) {
                    switchStorage.checked = isOn;
                }
                userSwitchingStorage = false;
            }
        }
    }

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

                            onToggled: {
                                userSwitchingLiving = true;
                                backend.toggleLight("light.woonkamer", checked);
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
                            if (pressed) {
                                userSlidingLiving = true;
                            } else {
                                userSlidingLiving = false;
                                backend.setLightBrightness("light.woonkamer", value);
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

                            onToggled: {
                                userSwitchingSleep = true;
                                backend.toggleLight("light.slaapkamer", checked);
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
                            if (pressed) {
                                userSlidingSleep = true;
                            } else {
                                userSlidingSleep = false;
                                backend.setLightBrightness("light.slaapkamer", value);
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

                            onToggled: {
                                userSwitchingHallway = true;
                                backend.toggleLight("light.ganglamp_licht", checked);
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
                            if (pressed) {
                                userSlidingHallway = true;
                            } else {
                                userSlidingHallway = false;
                                backend.setLightBrightness("light.ganglamp_licht", value);
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

                            onToggled: {
                                userSwitchingStorage = true;
                                backend.toggleLight("light.berginglamp_licht", checked);
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
}
