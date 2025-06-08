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
#include <QSet>
#include <QtWebSockets/QWebSocket>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>

class Backend : public QObject
{
    Q_OBJECT

public:
    explicit Backend(QObject *parent = nullptr);

    // Configuration
    Q_INVOKABLE void setAuthToken(const QString &authToken);
    Q_INVOKABLE void setUrl(const QString &url);
    Q_INVOKABLE void connectWebSocket();
    Q_INVOKABLE void disconnectWebSocket();

    // Weather
    Q_INVOKABLE void subscribeToWeather();

    // Alarm
    Q_INVOKABLE void subscribeToAlarm();

    // Climate sensors
    Q_INVOKABLE void subscribeToTemperature();
    Q_INVOKABLE void subscribeToHumidity();

    // Lights
    Q_INVOKABLE void subscribeToLights();
    Q_INVOKABLE void toggleLight(const QString &entityId, bool on);
    Q_INVOKABLE void setLightBrightness(const QString &entityId, int brightness);

    // Media player
    Q_INVOKABLE void subscribeToMediaPlayer(const QString &entityId);
    Q_INVOKABLE void mediaPlayPause(const QString &entityId);
    Q_INVOKABLE void mediaTogglePower(const QString &entityId);
    Q_INVOKABLE void mediaPlay(const QString &entityId);
    Q_INVOKABLE void mediaPause(const QString &entityId);
    Q_INVOKABLE void mediaStop(const QString &entityId);
    Q_INVOKABLE void mediaNextTrack(const QString &entityId);
    Q_INVOKABLE void mediaPreviousTrack(const QString &entityId);
    Q_INVOKABLE void mediaVolumeUp(const QString &entityId);
    Q_INVOKABLE void mediaVolumeDown(const QString &entityId);
    Q_INVOKABLE void mediaSetVolume(const QString &entityId, int volume);
    Q_INVOKABLE void mediaPlayMedia(const QString &entityId, const QString &mediaUrl, const QString &mediaType);

    Q_INVOKABLE void setFanPresetMode(const QString& entityId, const QString& presetMode);
    Q_INVOKABLE void subscribeToFan(const QString& entityId);

signals:
    void connectionStatusChanged(bool connected);
    void weatherUpdated(const QString &temperature, const QString &condition, const QString &humidity, const QString &icon);
    void alarmUpdated(const QString &state, const QString &icon);
    void temperatureUpdated(const QString &entityId, const QString &temp);
    void humidityUpdated(const QString &entityId, const QString &hum);
    void lightStateUpdated(const QString &entityId, bool state, int brightness);
    void mediaPlayerStateUpdated(const QString &entityId, const QString &state, const QString &title, const QString &artist, const QString &albumArt, int volume, bool muted);
    void fanStateUpdated(const QString& entityId, const QString& state, const QString& presetMode);

private slots:
    void onWebSocketConnected();
    void onWebSocketDisconnected();
    void onWebSocketMessageReceived(const QString &message);

private:
    // WebSocket connection
    QWebSocket *m_webSocket;
    QString m_token;
    QString m_baseUrl;
    QString m_wsUrl;
    quint64 m_messageId;
    bool m_authenticated;

    // Subscription tracking
    QHash<quint64, QString> m_pendingSubscriptions;
    QSet<QString> m_subscribedEntities;

    // Helper methods
    void sendMessage(const QJsonObject &message);
    void authenticate();
    void subscribeToStateChangeEvents();
    void requestCurrentStates();
    void handleAuthResult(const QJsonObject &message);
    void handleSubscriptionResult(const QJsonObject &message);
    void handleStateChanged(const QJsonObject &event);

    void processEntityState(const QString &entityId, const QJsonObject &state);
    void processWeatherState(const QJsonObject &state);
    void processAlarmState(const QJsonObject &state);
    void processLightState(const QString &entityId, const QJsonObject &state);
    void processMediaPlayerState(const QString &entityId, const QJsonObject &state);
    void processFanState(const QString &entityId, const QJsonObject &state);

    void callService(const QString &domain, const QString &service, const QJsonObject &serviceData);
};

#endif // BACKEND_H
