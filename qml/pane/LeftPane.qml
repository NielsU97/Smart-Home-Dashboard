import QtQuick
import '../components'

Item {
    id: leftItem
    width: 240
    height: parent.height
    anchors.left: parent.left

    Item {
        id: dateitem
        height: 150
        width: parent.width
        anchors.top: parent.top

        Column {
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right
            anchors.margins: 24
            spacing: 8

            Row {
                spacing: 12

                Text {
                    text: Qt.formatDate(currentTime, 'dd-MM-yyyy')
                    font.pixelSize: 16
                    color: textColor
                }

                Text {
                    text: new Date().toLocaleDateString(Qt.locale("nl_NL"), "dddd")
                    font.pixelSize: 16
                    color: textColor
                }
            }
        }

        Text {
            id: timetxt
            text: Qt.formatTime(currentTime, 'hh:mm')
            font.pixelSize: 48
            color: textColor
            anchors.left: parent.left
            anchors.leftMargin: 24
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 24
        }

        Text {
            id: sectxt
            width: 50
            text: ':' + Qt.formatTime(currentTime, 'ss')
            font.pixelSize: 18
            color: textColor
            anchors.baseline: timetxt.baseline
            anchors.left: timetxt.right
        }

        Text {
            id: alarmicon
            font.pixelSize: 12
            text: "\uf1f6"  // \uf1f6 and \uf0f3
            color: textColor
            anchors.baseline: timetxt.baseline
            anchors.left: sectxt.right
            anchors.leftMargin: 8
        }
    }

    Rectangle {
        id: todaysweatheritem
        radius: 16
        width: parent.width
        color: glassyBgColor
        anchors.top: dateitem.bottom
        anchors.bottom: locationitem.top
        anchors.topMargin: 17
        anchors.bottomMargin: 17

        Column {
            anchors.centerIn: parent
            spacing: 16

            Row {
                spacing: 16
                anchors.horizontalCenter: parent.horizontalCenter
                height: Math.max(cloudicon.height, tempgroup.height, humtxt.height)

                IconLabel {
                    id: cloudicon
                    icon: weatherIcon
                    size: 24
                    color: textColor
                    anchors.verticalCenter: parent.verticalCenter
                }

                Row {
                    id: tempgroup
                    spacing: 4
                    anchors.verticalCenter: parent.verticalCenter

                    Text {
                        id: tmptxt
                        text: (ambientTemperature !== undefined && ambientTemperature !== null) ? ambientTemperature : "--"
                        font.pixelSize: 40
                        color: textColor
                    }

                    Text {
                        text: "°C"
                        font.pixelSize: 14
                        color: textColor
                        anchors.bottom: tmptxt.bottom
                    }
                }

                Text {
                    id: humtxt
                    text: (ambientHumidity !== undefined && ambientHumidity !== null) ? ambientHumidity + "%" : "--%"
                    font.pixelSize: 14
                    color: textColor
                    anchors.verticalCenter: parent.verticalCenter
                }
            }

            Text {
                id: weathercommentxt
                text: weatherCondition ?? ""
                font.pixelSize: 16
                color: textColor
                anchors.horizontalCenter: parent.horizontalCenter
            }
        }
    }

    Rectangle {
        id: locationitem
        radius: 16
        height: 126
        color: glassyBgColor
        width: parent.width
        anchors.bottom: parent.bottom

        Row {
            id: locationitempadded
            anchors.fill: parent
            anchors.margins: 24

            Repeater {
                id: locationrepeater
                model: roomsModel

                delegate: Item {
                    id: roomdelegateitem
                    height: locationitempadded.height
                    width: locationitempadded.width / locationrepeater.model.count

                    property string label
                    property bool isActive: label === activeRoomLabel
                    property alias icon: iconlabel.icon
                    property alias size: iconlabel.size

                    signal clicked()

                    label: model.label
                    icon: model.icon
                    size: model.size
                    onClicked: activeRoomLabel = label

                    Column {
                        anchors.fill: parent
                        spacing: 8

                        IconLabel {
                            id: iconlabel
                            width: parent.height * 0.5
                            height: width
                            anchors.horizontalCenter: parent.horizontalCenter
                            horizontalAlignment: IconLabel.AlignHCenter
                            verticalAlignment: IconLabel.AlignVCenter
                            opacity: roomdelegateitem.isActive ? 1 : 0.5

                            Behavior on opacity { NumberAnimation { duration: 300 } }
                        }

                        Text {
                            text: roomdelegateitem.label
                            font.pixelSize: 10
                            color: textColor
                            anchors.horizontalCenter: parent.horizontalCenter
                            opacity: roomdelegateitem.isActive ? 1 : 0.5

                            Behavior on opacity { NumberAnimation { duration: 300 } }

                            Rectangle {
                                width: parent.parent.width * 0.8
                                height: 4
                                radius: 2
                                color: textColor
                                anchors.horizontalCenter: parent.horizontalCenter
                                anchors.bottom: parent.bottom
                                anchors.bottomMargin: -8
                                opacity: roomdelegateitem.isActive ? 1 : 0.5

                                Behavior on opacity { NumberAnimation { duration: 300 } }
                            }
                        }
                    }

                    MouseArea {
                        anchors.fill: parent
                        onClicked: roomdelegateitem.clicked()
                    }
                }
            }
        }
    }
}
