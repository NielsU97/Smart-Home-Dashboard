import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2
import '../components'

Item {
    id: musicItem

    // Your existing properties...
    property string mediaTitle: ""
    property string mediaArtist: ""
    property string playerState: "idle"
    property url albumArtUrl: ""
    property int mediaVolume: 50
    property bool isMuted: false
    property string mediaPlayerEntityId: "media_player.google_nest"

    // Spotify playlists data
    property var spotifyPlaylists: [
        { name: "Nederlands", id: "7mlnu1diy0G60IButOXyuq" },
        { name: "Franstalig", id: "7hGPyd5evcDjgpviVBLJVw" },
        { name: "Top 2000", id: "1DTzz7Nh2rJBnyFbjsH1Mh" },
        { name: "Indie Folk", id: "2wTQSRAUo9zdqcOmvkqhWf" }
    ]

    Connections {
        target: backend
        function onMediaPlayerStateUpdated(entityId, state, title, artist, albumArt, volume, muted) {
            if (entityId !== mediaPlayerEntityId)
                return;
            mediaTitle = title;
            mediaArtist = artist;
            playerState = state;
            albumArtUrl = albumArt;
            mediaVolume = volume;
            isMuted = muted;
        }
    }

    // Spotify Playlist Popup
    QQC2.Popup {
        id: spotifyPopup
        anchors.centerIn: parent
        width: 300
        height: 400
        modal: true
        focus: true
        closePolicy: QQC2.Popup.CloseOnEscape | QQC2.Popup.CloseOnPressOutside

        // Ensure popup resets properly when opened
        onOpened: {
            listView.currentIndex = -1
        }

        background: Rectangle {
            color: glassyBgColor
            radius: 16
        }

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 16
            rotation: rotate

            // Header
            RowLayout {
                Layout.fillWidth: true

                QQC2.Label {
                    text: "Selecteer Spotify Playlist"
                    font.pixelSize: 18
                    color: "white"
                    Layout.fillWidth: true
                    horizontalAlignment: Text.AlignHCenter
                    Layout.alignment: Qt.AlignHCenter
                }
            }

            // Playlist List
            QQC2.ScrollView {
                Layout.fillWidth: true
                Layout.fillHeight: true

                ListView {
                    id: listView
                    model: spotifyPlaylists
                    spacing: 8
                    clip: true

                    delegate: Rectangle {
                        width: ListView.view.width
                        height: 50
                        color: playlistMouseArea.containsMouse ? "#404040" : "transparent"
                        radius: 8
                        border.color: "#606060"
                        border.width: 1

                        RowLayout {
                            anchors.fill: parent
                            anchors.margins: 12
                            spacing: 12

                            // Spotify icon placeholder
                            Rectangle {
                                width: 26
                                height: 26
                                radius: 4
                                color: "#1DB954" // Spotify green

                                QQC2.Label {
                                    anchors.centerIn: parent
                                    text: "♪"
                                    color: "white"
                                    font.pixelSize: 14
                                    font.bold: true
                                }
                            }

                            // Playlist name
                            QQC2.Label {
                                text: modelData.name
                                color: "white"
                                font.pixelSize: 14
                                Layout.fillWidth: true
                            }

                            // Play arrow
                            QQC2.Label {
                                text: "▶"
                                color: "#1DB954"
                                font.pixelSize: 16
                            }
                        }

                        MouseArea {
                            id: playlistMouseArea
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor

                            onClicked: {
                                backend.playSpotifyPlaylist(modelData.id);
                                spotifyPopup.close();
                            }
                        }
                    }
                }
            }

            Button {
                buttonText: "Cancel"
                iconOnly: false
                Layout.fillWidth: true
                Layout.preferredHeight: 40
                onClicked: spotifyPopup.close()
            }
        }
    }

    ColumnLayout {
        anchors.fill: parent
        spacing: 16

        // Title Panel with Album Art and Media Info
        Rectangle {
            color: glassyBgColor
            radius: 16
            Layout.fillWidth: true
            Layout.preferredHeight: 250

            // Power Button in top right corner
            Button {
                id: powerButton
                anchors.right: parent.right
                anchors.top: parent.top
                anchors.margins: 12
                iconOnly: true
                iconSource: "qrc:/SmartDashboard/assets/power.svg"
                width: 40
                height: 40
                opacity: playerState === "off" ? 0.5 : 1.0
                onClicked: {
                    backend.mediaTogglePower(mediaPlayerEntityId);
                }
            }

            // Album Art and Info Container
            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 20
                spacing: 16

                // Album Art
                Rectangle {
                    Layout.alignment: Qt.AlignHCenter
                    width: 120
                    height: 120
                    radius: 12
                    color: "#2A3141"

                    Image {
                        id: albumArtImage
                        anchors.fill: parent
                        anchors.margins: albumArtUrl != "" ? 0 : 20
                        source: albumArtUrl != "" ? albumArtUrl : ""
                        fillMode: Image.PreserveAspectCrop
                        visible: albumArtUrl != ""
                    }

                    QQC2.Label {
                        anchors.centerIn: parent
                        text: "♪"
                        font.pixelSize: 40
                        color: "white"
                        visible: albumArtUrl == ""
                    }
                }

                // Media Information
                ColumnLayout {
                    Layout.fillWidth: true
                    spacing: 4
                    Layout.alignment: Qt.AlignHCenter

                    QQC2.Label {
                        Layout.alignment: Qt.AlignHCenter
                        text: {
                            if (mediaTitle !== "")
                                return mediaTitle
                            else if (playerState === "playing")
                                return "Radio wordt afgespeeld"
                            else if (playerState === "off")
                                return "Apparaat staat uit"
                            else
                                return "Er wordt niks afgespeeld"
                        }
                        font.pixelSize: 16
                        font.bold: true
                        color: "white"
                        horizontalAlignment: Text.AlignHCenter
                        elide: Text.ElideRight
                    }

                    QQC2.Label {
                        Layout.alignment: Qt.AlignHCenter
                        text: mediaArtist !== "" ? mediaArtist : "Google Nest Mini"
                        font.pixelSize: 14
                        color: "white"
                        opacity: 0.7
                        horizontalAlignment: Text.AlignHCenter
                    }
                }
            }
        }

        // Controls Panel
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

                    Button {
                        icon: "\u2212"
                        iconOnly: true
                        onClicked: {
                            backend.mediaVolumeDown(mediaPlayerEntityId);
                        }
                    }

                    Button {
                        icon: "\u002B"
                        iconOnly: true
                        onClicked: {
                            backend.mediaVolumeUp(mediaPlayerEntityId);
                        }
                    }

                    Button {
                        icon: "\u25C0\u25C0"
                        iconOnly: true
                        onClicked: {
                            backend.mediaPreviousTrack(mediaPlayerEntityId);
                        }
                    }

                    Button {
                        icon: "\u25B6\u25B6"
                        iconOnly: true
                        onClicked: {
                            backend.mediaNextTrack(mediaPlayerEntityId);
                        }
                    }

                    Button {
                        id: playPauseButton
                        icon: playerState === "playing" ? "\u25A0" : "\u25B6"
                        iconOnly: true
                        onClicked: {
                            if (playerState === "playing") {
                                backend.mediaPause(mediaPlayerEntityId);
                            } else {
                                backend.mediaPlay(mediaPlayerEntityId);
                            }
                        }
                    }
                }

                // Radio Stations Row
                RowLayout {
                    Layout.fillWidth: true
                    Layout.alignment: Qt.AlignHCenter
                    spacing: 10

                    Button {
                        buttonText: "NPO 2"
                        iconOnly: false
                        onClicked: {
                            backend.mediaPlayMedia(
                                mediaPlayerEntityId,
                                "http://icecast.omroep.nl/radio2-bb-mp3",
                                "music"
                            );
                        }
                    }

                    Button {
                        buttonText: "NPO 5"
                        iconOnly: false
                        onClicked: {
                            backend.mediaPlayMedia(
                                mediaPlayerEntityId,
                                "http://icecast.omroep.nl/radio5-bb-mp3",
                                "music"
                            );
                        }
                    }

                    Button {
                        buttonText: "Qmusic"
                        iconOnly: false
                        onClicked: {
                            backend.mediaPlayMedia(
                                mediaPlayerEntityId,
                                "https://icecast-qmusicnl-cdp.triple-it.nl/Qmusic_nl_live.mp3?aw_0_1st.playerId=redirect",
                                "music"
                            );
                        }
                    }

                    Button {
                        buttonText: "538"
                        iconOnly: false
                        onClicked: {
                            backend.mediaPlayMedia(
                                mediaPlayerEntityId,
                                "http://playerservices.streamtheworld.com/api/livestream-redirect/RADIO538.mp3",
                                "music"
                            );
                        }
                    }

                    // Updated Spotify Button
                    Button {
                        buttonText: "Spotify"
                        iconOnly: false
                        onClicked: {
                            spotifyPopup.open();
                        }
                    }
                }
            }
        }
    }
}
