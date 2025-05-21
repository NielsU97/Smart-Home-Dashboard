#ifndef BACKEND_H
#define BACKEND_H

#include <QObject>
#include <QString>
#include <QUrl>
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QNetworkReply>
#include <QTimer>
#include <QHash>

class Backend : public QObject
{
    Q_OBJECT

public:
    explicit Backend(QObject *parent = nullptr);

    // Configuration
    Q_INVOKABLE void setAuthToken(const QString &authToken);
    Q_INVOKABLE void setUrl(const QString &url);

    // Weather
    Q_INVOKABLE void getWeatherState();

    // Alarm
    Q_INVOKABLE void getAlarmState();

    // Climate sensors
    Q_INVOKABLE void getTemperature(const QString &entityId);
    Q_INVOKABLE void getHumidity(const QString &entityId);

    // Lights
    Q_INVOKABLE void getLightState(const QString &entityId);
    Q_INVOKABLE void toggleLight(const QString &entityId, bool on);
    Q_INVOKABLE void setLightBrightness(const QString &entityId, int brightness);
    Q_INVOKABLE void startLightPolling(int interval);
    Q_INVOKABLE void stopLightPolling();

    // Media player
    Q_INVOKABLE void getMediaPlayerState(const QString &entityId);
    Q_INVOKABLE void mediaPlayPause(const QString &entityId);
    Q_INVOKABLE void mediaPlay(const QString &entityId);
    Q_INVOKABLE void mediaPause(const QString &entityId);
    Q_INVOKABLE void mediaStop(const QString &entityId);
    Q_INVOKABLE void mediaNextTrack(const QString &entityId);
    Q_INVOKABLE void mediaPreviousTrack(const QString &entityId);
    Q_INVOKABLE void mediaVolumeUp(const QString &entityId);
    Q_INVOKABLE void mediaVolumeDown(const QString &entityId);
    Q_INVOKABLE void mediaSetVolume(const QString &entityId, int volume);
    Q_INVOKABLE void mediaPlayMedia(const QString &entityId, const QString &mediaUrl, const QString &mediaType);
    Q_INVOKABLE void startMediaPlayerPolling(const QString &entityId, int interval);
    Q_INVOKABLE void stopMediaPlayerPolling();

signals:
    void weatherUpdated(const QString &temperature, const QString &condition, const QString &humidity, const QString &icon);
    void alarmUpdated(const QString &state, const QString &icon);
    void temperatureUpdated(const QString &temp);
    void humidityUpdated(const QString &hum);
    void lightStateUpdated(const QString &entityId, bool state, int brightness);
    void lightPollingStatusChanged(bool isActive);
    void mediaPlayerStateUpdated(const QString &state, const QString &title, const QString &artist, const QString &albumArt, int volume, bool muted);

private:
    QNetworkAccessManager manager;
    QString token;
    QString baseUrl;

    // Light polling timer
    QTimer lightPollingTimer;
    QHash<QString, QString> lastStateMap;
    QHash<QString, int> lastBrightnessMap;

    // Media player polling timer
    QTimer mediaPlayerPollTimer;
    QString trackedMediaPlayer;

    // Media player state cache
    QString lastMediaPlayerState;
    QString lastMediaTitle;
    QString lastMediaArtist;
    QString lastMediaAlbumArt;
    int lastMediaVolume = 0;
    bool lastMediaMuted = false;

    // Add helper method to ensure we can get cached media player state
    void updateMediaPlayerCache(const QString &state, const QString &title,
                                const QString &artist, const QString &albumArt,
                                int volume, bool muted);
};

#endif // BACKEND_H
