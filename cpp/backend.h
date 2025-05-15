#ifndef BACKEND_H
#define BACKEND_H
#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QTimer>
#include <QUrl>

class Backend : public QObject
{
    Q_OBJECT
public:
    explicit Backend(QObject *parent = nullptr);

    // Existing methods
    Q_INVOKABLE void getWeatherState();
    Q_INVOKABLE void getAlarmState();
    Q_INVOKABLE void getTemperature(const QString& entityId);
    Q_INVOKABLE void getHumidity(const QString& entityId);

    Q_INVOKABLE void getLightState(const QString& entityId);
    Q_INVOKABLE void setLightBrightness(const QString& entityId, int brightness);
    Q_INVOKABLE void toggleLight(const QString& entityId, bool on);
    Q_INVOKABLE void startLightPolling(int intervalMs);
    Q_INVOKABLE void stopLightPolling();

    // New media player methods
    Q_INVOKABLE void getMediaPlayerState(const QString& entityId);
    Q_INVOKABLE void mediaPlayPause(const QString& entityId);
    Q_INVOKABLE void mediaPlay(const QString& entityId);
    Q_INVOKABLE void mediaPause(const QString& entityId);
    Q_INVOKABLE void mediaStop(const QString& entityId);
    Q_INVOKABLE void mediaNextTrack(const QString& entityId);
    Q_INVOKABLE void mediaPreviousTrack(const QString& entityId);
    Q_INVOKABLE void mediaVolumeUp(const QString& entityId);
    Q_INVOKABLE void mediaVolumeDown(const QString& entityId);
    Q_INVOKABLE void mediaSetVolume(const QString& entityId, int volume);
    Q_INVOKABLE void mediaPlayMedia(const QString& entityId, const QString& mediaUrl, const QString& mediaType);
    Q_INVOKABLE void startMediaPlayerPolling(const QString& entityId, int interval = 5000);
    Q_INVOKABLE void stopMediaPlayerPolling();

signals:
    // Existing signals
    void weatherUpdated(QString temperature, QString condition, QString humidity, QString icon);
    void alarmUpdated(const QString& state, const QString& icon);
    void temperatureUpdated(QString temp);
    void humidityUpdated(QString hum);
    void lightStateUpdated(const QString &entityId, bool isOn, int brightness);

    // New media player signals
    void mediaPlayerStateUpdated(const QString& state, const QString& title,
                                 const QString& artist, const QString& albumArt,
                                 int volume, bool isMuted);

private:
    QNetworkAccessManager manager;
    const QString token = "YOUR_HOMEASSISTANT_TOKEN";
    const QString baseUrl = "http://YOUR_HOMEASSISTANT_URL/api";

    QTimer pollTimer;
    QTimer* lightPollingTimer = new QTimer(this);

    QTimer mediaPlayerPollTimer;
    QString lastState;
    QString trackedEntity;
    QString trackedMediaPlayer;
    QHash<QString, QString> lastStateMap;
    QHash<QString, int> lastBrightnessMap;

    QString lastMediaPlayerState;
    QString lastMediaTitle;
    QString lastMediaArtist;
    QString lastMediaAlbumArt;
    int lastMediaVolume;
    bool lastMediaMuted;
};

#endif // BACKEND_H
