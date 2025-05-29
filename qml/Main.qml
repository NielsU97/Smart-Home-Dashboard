import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import 'pane'
import 'components'

Window {
    id: root
    // ---- Window Properties ----
    width: 800
    height: 480
    visible: true
    title: qsTr("Smart Home Dashboard")

    // ---- Theme Properties ----
    property string bgGradientStart: '#0d8bfd'
    property string bgGradientStop: '#866aaf'
    property string textColor: '#d9d9d9'
    property color glassyBgColor: utils.hex_to_RGBA('#1e1f2a', 0.8)
    property alias fontawesomefontloader: fontawesomefontloader

    // ---- State Properties ----
    property string activeRoomLabel: 'Huis'

    // ---- Room Navigation Model ----
    property ListModel roomsModel: ListModel {
        ListElement {
            label: 'Huis'
            icon: '\uf015'
        }
        ListElement {
            label: 'Muziek'
            icon: '\uf001'
        }
        ListElement {
            label: 'Klimaat'
            icon: '\uf2c9'
        }
        ListElement {
            label: 'Energie'
            icon: '\uf0e7'
        }
    }

    // ---- Utility Functions ----
    QtObject {
        id: utils
        function hex_to_RGB(hex) {
            hex = hex.toString();
            var m = hex.match(/^#?([\da-f]{2})([\da-f]{2})([\da-f]{2})$/i);
            return Qt.rgba(
                parseInt(m[1], 16) / 255.0,
                parseInt(m[2], 16) / 255.0,
                parseInt(m[3], 16) / 255.0,
                1
            );
        }
        function hex_to_RGBA(hex, opacity=1) {
            hex = hex.toString();
            opacity = opacity > 1 ? 1 : opacity // Opacity should be 0 - 1
            var m = hex.match(/^#?([\da-f]{2})([\da-f]{2})([\da-f]{2})$/i);
            return Qt.rgba(
                parseInt(m[1], 16) / 255.0,
                parseInt(m[2], 16) / 255.0,
                parseInt(m[3], 16) / 255.0,
                opacity
            );
        }
        function commafy(value) {
            return value.toLocaleString()
        }
    }

    // ---- Main Background ----
    Rectangle {
        id: background
        anchors.fill: parent
        gradient: Gradient {
            orientation: Gradient.Horizontal
            GradientStop { position: 0.0; color: bgGradientStart }
            GradientStop { position: 1.0; color: bgGradientStop }
        }
    }

    // ---- Main Layout ----
    Item {
        id: mainLayout
        anchors.fill: parent
        anchors.margins: 24

        // Left panel for navigation
        LeftPane {
            id: leftItem
        }

        // Right content area with StackLayout for state persistence
        StackLayout {
            id: rightPaneStack
            anchors {
                top: parent.top
                bottom: parent.bottom
                left: leftItem.right
                right: parent.right
                leftMargin: 12
            }

            // Set the current index based on activeRoomLabel
            currentIndex: {
                switch (activeRoomLabel) {
                case "Huis": return 0
                case "Muziek": return 1
                case "Klimaat": return 2
                case "Energie": return 3
                default: return 0
                }
            }

            // All panes are created once and kept in memory
            HomePane {
                id: homePane
            }

            MusicPane {
                id: musicPane
            }

            ClimatePane {
                id: climatePane
            }

            EnergyPane {
                id: energyPane
            }
        }
    }

    // ---- Resources ----
    FontLoader {
        id: fontawesomefontloader
        source: "qrc:/SmartDashboard/assets/fonts/fontawesome.otf"
    }
}
