import QtQuick
import QtQuick.Layouts
import QtQuick.Controls as QQC2
import '../components'

Item {
    id: musicItem
    anchors.fill: parent

    // Properties to bind with Home Assistant data
    property string mediaTitle: "" // Current playing media title
    property string mediaArtist: "" // Current artist
    property string playerState: "idle" // playing, paused, idle, off
    property url albumArtUrl: "" // Album art URL
    property int mediaVolume: 50
    property bool isMuted: false

    // Entity ID for your Google Nest
    property string mediaPlayerEntityId: "media_player.google_nest"


    // Connect to signals from backend
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


    ColumnLayout {
        anchors.fill: parent
        spacing: 16

        // Title Panel with Album Art and Media Info
        Rectangle {
            color: glassyBgColor
            radius: 16
            Layout.fillWidth: true
            Layout.preferredHeight: 250

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
                        source: albumArtUrl != "" ? albumArtUrl : "" // Placeholder or actual album art
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

                    // Volume Down
                    Button {
                        icon: "\u2212"  // Minus sign
                        iconOnly: true
                        onClicked: {
                            // Call Home Assistant service to decrease volume
                            backend.mediaVolumeDown(mediaPlayerEntityId);
                        }
                    }

                    // Volume Up
                    Button {
                        icon: "\u002B"  // Plus sign
                        iconOnly: true
                        onClicked: {
                            // Call Home Assistant service to increase volume
                            backend.mediaVolumeUp(mediaPlayerEntityId);
                        }
                    }

                    // Previous Track
                    Button {
                        icon: "\u25C0\u25C0"  // Double left arrow
                        iconOnly: true
                        onClicked: {
                            // Call Home Assistant service for previous track
                            backend.mediaPreviousTrack(mediaPlayerEntityId);
                        }
                    }

                    // Next Track
                    Button {
                        icon: "\u25B6\u25B6"  // Double right arrow
                        iconOnly: true
                        onClicked: {
                            // Call Home Assistant service for next track
                            backend.mediaNextTrack(mediaPlayerEntityId);
                        }
                    }

                    // Play/Pause
                    Button {
                        id: playPauseButton
                        icon: playerState === "playing" ? "\u25A0" : "\u25B6"  // Pause or Play icon
                        iconOnly: true
                        onClicked: {
                            // Call Home Assistant service for play/pause
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

                    // NPO 2
                    Button {
                        buttonText: "NPO 2"
                        iconOnly: false
                        onClicked: {
                            // Call Home Assistant service to play this radio station
                            backend.mediaPlayMedia(
                                mediaPlayerEntityId,
                                "http://icecast.omroep.nl/radio2-bb-mp3",
                                "music"
                            );
                        }
                    }

                    // NPO 5
                    Button {
                        buttonText: "NPO 5"
                        iconOnly: false
                        onClicked: {
                            // Call Home Assistant service to play this radio station
                            backend.mediaPlayMedia(
                                mediaPlayerEntityId,
                                "http://icecast.omroep.nl/radio5-bb-mp3",
                                "music"
                            );
                        }
                    }

                    // Qmusic
                    Button {
                        buttonText: "Qmusic"
                        iconOnly: false
                        onClicked: {
                            // Call Home Assistant service to play this radio station
                            backend.mediaPlayMedia(
                                mediaPlayerEntityId,
                                "https://stream.qmusic.nl/qmusic/mp3",
                                "music"
                            );
                        }
                    }

                    // 538
                    Button {
                        buttonText: "538"
                        iconOnly: false
                        onClicked: {
                            // Call Home Assistant service to play this radio station
                            backend.mediaPlayMedia(
                                mediaPlayerEntityId,
                                "http://playerservices.streamtheworld.com/api/livestream-redirect/RADIO538.mp3",
                                "music"
                            );
                        }
                    }

                    // Spotify
                    Button {
                        buttonText: "Spotify"
                        iconOnly: false
                        onClicked: {
                            // Call Home Assistant service to play this radio station
                            backend.mediaPlayMedia(
                                mediaPlayerEntityId,
                                "spotify:playlist:7mlnu1diy0G60IButOXyuq",
                                "music"
                            );
                        }
                    }
                }
            }
        }
    }
}
