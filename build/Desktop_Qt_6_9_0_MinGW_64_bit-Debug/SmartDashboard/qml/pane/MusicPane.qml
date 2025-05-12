import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2
import '../components'

Item {
    id: musicItem
    anchors.fill: parent

    ColumnLayout {
        anchors.fill: parent
        spacing: 16

        // Title Panel
        Rectangle {
            color: glassyBgColor
            radius: 16
            Layout.fillWidth: true
            Layout.preferredHeight: 250

            QQC2.Label {
                anchors.centerIn: parent
                text: "Google nest"
                font.pixelSize: 18
                font.bold: true
                color: "white"
            }
        }

        Rectangle {
            color: glassyBgColor
            radius: 16
            Layout.fillWidth: true
            Layout.fillHeight: true

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 10
                spacing: 10

                // Media Controls Row
                RowLayout {
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignHCenter
                    spacing: 10

                    // Volume Down
                    Button {
                        icon: "\u2212"
                        iconOnly: true
                        onClicked: {
                            // Implement volume down action
                            // backend.volumeDown()
                        }
                    }

                    // Volume Up
                    Button {
                        icon: "\u002B"
                        iconOnly: true
                        onClicked: {
                            // Implement volume up action
                            // backend.volumeUp()
                        }
                    }

                    // Previous Track
                    Button {
                        icon: "\u25C0\u25C0"
                        iconOnly: true
                        onClicked: {
                            // Implement previous track action
                            // backend.previousTrack()
                        }
                    }

                    // Next Track
                    Button {
                        icon: "\u25B6\u25B6"
                        iconOnly: true
                        onClicked: {
                            // Implement next track action
                            // backend.nextTrack()
                        }
                    }

                    // Play/Pause
                    Button {
                        id: playPauseButton
                        icon: "\u25B6"
                        iconOnly: true
                        onClicked: {
                            // Implement play/pause action
                            // backend.playPause()
                        }
                    }
                }

                // Radio Stations Row
                RowLayout {
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignHCenter
                    spacing: 10

                    // NPO 2
                    Button {
                        buttonText: "NPO 2"
                        iconOnly: false
                        onClicked: {
                            // Implement NPO 2 radio station action
                            // backend.playRadioStation("NPO 2")
                        }
                    }

                    // NPO 5
                    Button {
                        buttonText: "NPO 5"
                        iconOnly: false
                        onClicked: {
                            // Implement NPO 5 radio station action
                            // backend.playRadioStation("NPO 5")
                        }
                    }

                    // Qmusic
                    Button {
                        buttonText: "Qmusic"
                        iconOnly: false
                        onClicked: {
                            // Implement Qmusic radio station action
                            // backend.playRadioStation("Qmusic")
                        }
                    }

                    // 538
                    Button {
                        buttonText: "538"
                        iconOnly: false
                        onClicked: {
                            // Implement 538 radio station action
                            // backend.playRadioStation("538")
                        }
                    }

                    // Spotify Nederlands
                    Button {
                        buttonText: "Nederlands"
                        iconOnly: false
                        onClicked: {
                            // Implement Spotify playlist action
                            // backend.playSpotifyPlaylist("Nederlands")
                        }
                    }
                }
            }
        }
    }
}
