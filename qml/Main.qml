import QtQuick
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

    property string ambientTemperature: "-"
    property string weatherCondition: "-"
    property string weatherIcon: "-"
    property string minTemp: "-"
    property string maxTemp: "-"

    QtObject {
        id: internal

        property real temperature: 26
        property real humidity: 47
        property real heating: 35
        property real water: 231
        property real lightIntensity: 45
        property real powerConsumed: 7354
        property real ambientTemperature: 22
    }

    property ListModel roomsModel: ListModel {
        ListElement {
            label: 'Huis'
            icon: '\uf015'
            size: 28
            temperature: 26
            humidity: 47
            heating: 35
            water: 231
            lightIntensity: 45
        }

        ListElement {
            label: 'Muziek'
            icon: '\uf001'
            size: 22
            temperature: 32
            humidity: 67
            heating: 22
            water: 344
            lightIntensity: 78
        }

        ListElement {
            label: 'Klimaat'
            icon: '\uf2c9'
            size: 28
            temperature: 24
            humidity: 40
            heating: 40
            water: 304
            lightIntensity: 25
        }

        ListElement {
            label: 'Energie'
            icon: '\uf0e7'
            size: 22
            temperature: 28
            humidity: 77
            heating: 56
            water: 430
            lightIntensity: 85
        }
    }

    onActiveRoomLabelChanged: {
        for(var i=0; i<roomsModel.count; i++) {
            var obji = roomsModel.get(i)

            if(obji['label'] === activeRoomLabel) {
                internal.temperature = obji['temperature']
                internal.humidity = obji['humidity']
                internal.heating = obji['heating']
                internal.water = obji['water']
                internal.lightIntensity = obji['lightIntensity']

                break;
            }
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

    function getRandOffset(value, range=4) {
        return Math.round(value + range/2 - (Math.random(1) * range))
    }

    Timer {
        interval: 1000
        repeat: true
        running: true
        triggeredOnStart: true
        onTriggered: {
            currentTime = new Date()
            powerConsumed = getRandOffset(internal.powerConsumed, 2)
            temperature = getRandOffset(internal.temperature)
            humidity = getRandOffset(internal.humidity)
            heating = getRandOffset(internal.heating)
            water = getRandOffset(internal.water)
            lightIntensity = getRandOffset(internal.lightIntensity)
        }
    }

    Rectangle {
        id: bg
        anchors.fill: parent
        gradient: Gradient {
            orientation: Gradient.Horizontal
            GradientStop { position: 0.0; color: bgGradientStart }
            GradientStop { position: 1.0; color: bgGradientStop }
        }

        Item {
            anchors.fill: parent
            anchors.margins: 24

            LeftPane { id: leftItem }

            MiddlePane { id: middleItem }

            RightPane { id: rightItem }
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
        onWeatherUpdated: (temperature, condition, min, max) => {
            ambientTemperature = temperature
            weatherCondition = condition
            weatherIcon = backend.getWeatherIcon(condition)
            minTemp = min
            maxTemp = max
        }
    }
}
