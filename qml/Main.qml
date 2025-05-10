import QtQuick 2.15
import QtQuick.Controls 2.15
import 'pane'
import 'components'

Window {
    width: 800
    height: 480
    visible: true
    title: qsTr("Smart Home Dashboard")

    property string bgGradientStart: '#0d8bfd'
    property string bgGradientStop: '#866aaf'
    property string textColor: '#d9d9d9'
    property color glassyBgColor: hex_to_RGBA('#1e1f2a', 0.8)
    property alias fontawesomefontloader: fontawesomefontloader

    property string activeRoomLabel: 'Huis'

    property real powerConsumed: 7354
    property real temperature: 26
    property real humidity: 47
    property real heating: 35
    property real water: 231
    property real lightIntensity: 45

    property var currentTime: new Date()

    property string weatherCondition: "-"
    property string weatherIcon: "-"
    property string ambientTemperature: "-"
    property string ambientHumidity: "-"

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


    function hex_to_RGB(hex) {
        hex = hex.toString();
        var m = hex.match(/^#?([\da-f]{2})([\da-f]{2})([\da-f]{2})$/i);
        return Qt.rgba(parseInt(m[1], 16)/255.0, parseInt(m[2], 16)/255.1, parseInt(m[3], 16)/255.0, 1);
    }

    function hex_to_RGBA(hex, opacity=1) {
        hex = hex.toString();
        opacity = opacity > 1 ? 1 : opacity // Opacity should be 0 - 1
        var m = hex.match(/^#?([\da-f]{2})([\da-f]{2})([\da-f]{2})$/i);
        return Qt.rgba(parseInt(m[1], 16)/255.0, parseInt(m[2], 16)/255.1, parseInt(m[3], 16)/255.0, opacity);
    }

    Timer {
        interval: 1000
        repeat: true
        running: true
        triggeredOnStart: true
        onTriggered: {
            currentTime = new Date()
        }
    }

    // Main background
    Rectangle {
        id: bg
        anchors.fill: parent
        gradient: Gradient {
            orientation: Gradient.Horizontal
            GradientStop { position: 0.0; color: bgGradientStart }
            GradientStop { position: 1.0; color: bgGradientStop }
        }

        // Layout for Left and Right panes
        Item {
            anchors.fill: parent
            anchors.margins: 24

            LeftPane { id: leftItem }

            // Right pane dynamically loaded based on activeRoomLabel
            Loader {
                id: rightPaneLoader
                anchors.top: parent.top
                anchors.bottom: parent.bottom
                anchors.left: leftItem.right
                anchors.right: parent.right
                anchors.leftMargin: 12

                sourceComponent: {
                    switch (activeRoomLabel) {
                    case "Huis": return homePaneComponent
                    case "Muziek": return musicPaneComponent
                    case "Klimaat": return climatePaneComponent
                    case "Energie": return energyPaneComponent
                    default: return null
                    }
                }
            }
        }
    }

    FontLoader {
        id: fontawesomefontloader
        source: "qrc:/SmartDashboard/assets/fonts/fontawesome.otf"
    }

    function commafy(value) {
        return value.toLocaleString()
    }

    Component.onCompleted: {
        backend.getWeather()
    }

    Connections {
        target: backend
        onWeatherUpdated: (temperature, condition, humidity, icon) => {
            ambientTemperature = temperature
            weatherCondition = condition
            weatherIcon = icon
            ambientHumidity = humidity
        }
    }

    // Define components for different room views
    Component { id: homePaneComponent; HomePane { } }
    Component { id: musicPaneComponent; MusicPane { } }
    Component { id: climatePaneComponent; ClimatePane { } }
    Component { id: energyPaneComponent; EnergyPane { } }
}

