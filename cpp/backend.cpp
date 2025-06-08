#include "backend.h"
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>

Backend::Backend(QObject* parent)
    : QObject(parent)
    , m_webSocket(nullptr)
    , m_messageId(1)
    , m_authenticated(false)
{
}

void Backend::setAuthToken(const QString& authToken) {
    m_token = authToken;
}

void Backend::setUrl(const QString& url) {
    m_baseUrl = url;
    m_wsUrl = url;
    m_wsUrl.replace("http://", "ws://");
    m_wsUrl.replace("https://", "wss://");
    m_wsUrl.replace("/api", "/api/websocket");
}

void Backend::connectWebSocket() {
    if (m_webSocket) {
        m_webSocket->deleteLater();
    }

    m_webSocket = new QWebSocket(QString(), QWebSocketProtocol::VersionLatest, this);

    connect(m_webSocket, &QWebSocket::connected, this, &Backend::onWebSocketConnected);
    connect(m_webSocket, &QWebSocket::disconnected, this, &Backend::onWebSocketDisconnected);
    connect(m_webSocket, &QWebSocket::textMessageReceived, this, &Backend::onWebSocketMessageReceived);

    m_webSocket->open(QUrl(m_wsUrl));
}

void Backend::disconnectWebSocket() {
    if (m_webSocket && m_webSocket->state() == QAbstractSocket::ConnectedState) {
        m_webSocket->close();
    }
}

void Backend::onWebSocketConnected() {
    m_authenticated = false;
    emit connectionStatusChanged(true);
    authenticate();
}

void Backend::onWebSocketDisconnected() {
    m_authenticated = false;
    emit connectionStatusChanged(false);
}

void Backend::onWebSocketMessageReceived(const QString &message) {
    QJsonDocument doc = QJsonDocument::fromJson(message.toUtf8());
    QJsonObject obj = doc.object();

    QString type = obj["type"].toString();

    if (type == "auth_required") {
        authenticate();
    } else if (type == "auth_ok") {
        handleAuthResult(obj);
    } else if (type == "auth_invalid") {
        m_authenticated = false;
        emit connectionStatusChanged(false);
    } else if (type == "result") {
        handleSubscriptionResult(obj);
    } else if (type == "event") {
        handleStateChanged(obj);
    }
}



void Backend::sendMessage(const QJsonObject &message) {
    if (!m_webSocket || m_webSocket->state() != QAbstractSocket::ConnectedState) {
        return;
    }

    QJsonDocument doc(message);
    QString jsonString = doc.toJson(QJsonDocument::Compact);

    m_webSocket->sendTextMessage(jsonString);
}

void Backend::authenticate() {
    QJsonObject authMessage;
    authMessage["type"] = "auth";
    authMessage["access_token"] = m_token;
    sendMessage(authMessage);
}

void Backend::handleAuthResult(const QJsonObject &) {
    m_authenticated = true;
    subscribeToStateChangeEvents();
}

void Backend::subscribeToStateChangeEvents()
{
    if (!m_authenticated) return;

    QJsonObject subscribeMessage;
    subscribeMessage["id"] = static_cast<qint64>(m_messageId);
    subscribeMessage["type"] = "subscribe_events";
    subscribeMessage["event_type"] = "state_changed";

    m_pendingSubscriptions[m_messageId] = "state_changed";
    m_messageId++;

    sendMessage(subscribeMessage);
}

void Backend::requestCurrentStates() {
    if (!m_authenticated) {
        return;
    }

    QJsonObject message;
    message["id"] = static_cast<qint64>(m_messageId);
    message["type"] = "get_states";

    m_pendingSubscriptions[m_messageId] = "get_states";
    m_messageId++;

    sendMessage(message);
}

void Backend::handleSubscriptionResult(const QJsonObject &message) {
    quint64 id = message["id"].toVariant().toULongLong();

    if (m_pendingSubscriptions.contains(id)) {
        QString requestType = m_pendingSubscriptions[id];
        m_pendingSubscriptions.remove(id);

        // If this was a state_changed subscription, now request current states
        if (requestType == "state_changed") {
            requestCurrentStates();
        }

        // Handle get_states response
        if (requestType == "get_states" && message.contains("result")) {
            QJsonArray states = message["result"].toArray();

            for (int i = 0; i < states.size(); ++i) {
                QJsonObject state = states[i].toObject();
                QString entityId = state["entity_id"].toString();

                if (m_subscribedEntities.contains(entityId)) {
                    processEntityState(entityId, state);
                }
            }
        }
    }
}

void Backend::handleStateChanged(const QJsonObject &event) {
    QJsonObject eventData = event["event"].toObject();
    QJsonObject data = eventData["data"].toObject();

    QString entityId = data["entity_id"].toString();

    if (!m_subscribedEntities.contains(entityId)) {
        // Not a relevant entity, skip it
        return;
    }

    QJsonObject newState = data["new_state"].toObject();

    processEntityState(entityId, newState);
}

void Backend::processEntityState(const QString &entityId, const QJsonObject &state) {
    if (entityId == "weather.forecast_thuis") {
        processWeatherState(state);
    } else if (entityId == "alarm_control_panel.alarm") {
        processAlarmState(state);
    } else if (entityId.startsWith("light.")) {
        processLightState(entityId, state);
    } else if (entityId.startsWith("media_player.")) {
        processMediaPlayerState(entityId, state);
    } else if (entityId.startsWith("fan.")) {
        processFanState(entityId, state);
    } else if (entityId.startsWith("sensor.")) {
        QString stateValue = state["state"].toString();
        if (entityId.contains("temperature")) {
            emit temperatureUpdated(entityId, stateValue);
        } else if (entityId.contains("humidity")) {
            emit humidityUpdated(entityId, stateValue);
        }
    }
}

void Backend::processWeatherState(const QJsonObject &state) {
    QJsonObject attributes = state["attributes"].toObject();
    QString temperature = attributes["temperature"].toVariant().toString();
    QString condition = state["state"].toString();
    QString humidity = attributes["humidity"].toVariant().toString();

    static const QHash<QString, QString> iconMap = {
        { "sunny",         "\uf185" },
        { "clear-night",   "\uf186" },
        { "partlycloudy",  "\uf6c4" },
        { "cloudy",        "\uf0c2" },
        { "rainy",         "\uf740" },
        { "pouring",       "\uf73d" },
        { "snowy",         "\uf2dc" },
        { "windy",         "\uf72e" },
        { "fog",           "\uf74e" }
    };

    static const QHash<QString, QString> conditionTranslationMap = {
        { "sunny",         "Zonnig" },
        { "clear-night",   "Heldere nacht" },
        { "partlycloudy",  "Gedeeltelijk bewolkt" },
        { "cloudy",        "Bewolkt" },
        { "rainy",         "Regenachtig" },
        { "pouring",       "Gietende regen" },
        { "snowy",         "Sneeuwachtig" },
        { "windy",         "Winderig" },
        { "fog",           "Mistig" }
    };

    QString icon = iconMap.value(condition, "\uf75f");
    QString translatedCondition = conditionTranslationMap.value(condition, condition);

    emit weatherUpdated(temperature, translatedCondition, humidity, icon);
}

void Backend::processAlarmState(const QJsonObject &state) {
    QString stateValue = state["state"].toString();

    static const QHash<QString, QString> iconMap = {
        { "disarmed",       "\uf3ed" },
        { "armed_home",     "\uf015" },
        { "armed_away",     "\uf132" },
        { "armed_night",    "\uf186" },
        { "triggered",      "\uf12a" }
    };

    QString icon = iconMap.value(stateValue, "\u231b");
    emit alarmUpdated(stateValue, icon);
}

void Backend::processLightState(const QString &entityId, const QJsonObject &state) {
    QString stateValue = state["state"].toString();
    QJsonObject attributes = state["attributes"].toObject();
    int brightness = attributes["brightness"].toInt();
    int brightnessPct = brightness * 100 / 255;

    emit lightStateUpdated(entityId, stateValue == "on", brightnessPct);
}

void Backend::processMediaPlayerState(const QString &entityId, const QJsonObject &state) {
    QString stateValue = state["state"].toString();
    QJsonObject attributes = state["attributes"].toObject();

    QString mediaTitle = attributes["media_title"].toString();
    QString mediaArtist = attributes["media_artist"].toString();
    QString albumArt = attributes["entity_picture"].toString();
    int volume = qRound(attributes["volume_level"].toDouble() * 100);
    bool isMuted = attributes["is_volume_muted"].toBool();

    if (!albumArt.isEmpty() && !albumArt.startsWith("http")) {
        QString baseUrlPrefix = m_baseUrl;
        baseUrlPrefix.replace("/api", "");
        albumArt = baseUrlPrefix + albumArt;
    }

    emit mediaPlayerStateUpdated(entityId, stateValue, mediaTitle, mediaArtist, albumArt, volume, isMuted);
}

void Backend::processFanState(const QString &entityId, const QJsonObject &state) {
    QString stateValue = state["state"].toString();
    QJsonObject attributes = state["attributes"].toObject();
    QString presetMode = attributes["preset_mode"].toString();

    emit fanStateUpdated(entityId, stateValue, presetMode);
}

void Backend::callService(const QString &domain, const QString &service, const QJsonObject &serviceData) {
    QJsonObject message;
    message["id"] = static_cast<qint64>(m_messageId++);
    message["type"] = "call_service";
    message["domain"] = domain;
    message["service"] = service;
    message["service_data"] = serviceData;

    sendMessage(message);
}

void Backend::toggleLight(const QString& entityId, bool on) {
    QJsonObject serviceData;
    serviceData["entity_id"] = entityId;
    callService("light", on ? "turn_on" : "turn_off", serviceData);
}

void Backend::setLightBrightness(const QString& entityId, int brightness) {
    QJsonObject serviceData;
    serviceData["entity_id"] = entityId;
    serviceData["brightness_pct"] = brightness;
    callService("light", "turn_on", serviceData);
}

void Backend::setFanPresetMode(const QString& entityId, const QString& presetMode) {
    QJsonObject serviceData;
    serviceData["entity_id"] = entityId;
    serviceData["preset_mode"] = presetMode;
    callService("fan", "set_preset_mode", serviceData);
}

void Backend::mediaPlayPause(const QString& entityId) {
    QJsonObject serviceData;
    serviceData["entity_id"] = entityId;
    callService("media_player", "media_play_pause", serviceData);
}

void Backend::mediaPlay(const QString& entityId) {
    QJsonObject serviceData;
    serviceData["entity_id"] = entityId;
    callService("media_player", "media_play", serviceData);
}

void Backend::mediaPause(const QString& entityId) {
    QJsonObject serviceData;
    serviceData["entity_id"] = entityId;
    callService("media_player", "media_pause", serviceData);
}

void Backend::mediaStop(const QString& entityId) {
    QJsonObject serviceData;
    serviceData["entity_id"] = entityId;
    callService("media_player", "media_stop", serviceData);
}

void Backend::mediaNextTrack(const QString& entityId) {
    QJsonObject serviceData;
    serviceData["entity_id"] = entityId;
    callService("media_player", "media_next_track", serviceData);
}

void Backend::mediaPreviousTrack(const QString& entityId) {
    QJsonObject serviceData;
    serviceData["entity_id"] = entityId;
    callService("media_player", "media_previous_track", serviceData);
}

void Backend::mediaVolumeUp(const QString& entityId) {
    QJsonObject serviceData;
    serviceData["entity_id"] = entityId;
    callService("media_player", "volume_up", serviceData);
}

void Backend::mediaVolumeDown(const QString& entityId) {
    QJsonObject serviceData;
    serviceData["entity_id"] = entityId;
    callService("media_player", "volume_down", serviceData);
}

void Backend::mediaSetVolume(const QString& entityId, int volume) {
    QJsonObject serviceData;
    serviceData["entity_id"] = entityId;
    serviceData["volume_level"] = volume / 100.0;
    callService("media_player", "volume_set", serviceData);
}

void Backend::mediaPlayMedia(const QString& entityId, const QString& mediaUrl, const QString& mediaType) {
    QJsonObject serviceData;
    serviceData["entity_id"] = entityId;
    serviceData["media_content_id"] = mediaUrl;
    serviceData["media_content_type"] = mediaType;
    callService("media_player", "play_media", serviceData);
}

void Backend::mediaTogglePower(const QString& entityId) {
    QJsonObject serviceData;
    serviceData["entity_id"] = entityId;
    callService("media_player", "toggle", serviceData);
}

void Backend::subscribeToWeather() {
    m_subscribedEntities.insert("weather.forecast_thuis");
}

void Backend::subscribeToAlarm() {
    m_subscribedEntities.insert("alarm_control_panel.alarm");
}

void Backend::subscribeToLights() {
    m_subscribedEntities.insert("light.woonkamer");
    m_subscribedEntities.insert("light.slaapkamer");
    m_subscribedEntities.insert("light.ganglamp_licht");
    m_subscribedEntities.insert("light.berginglamp_licht");
}

void Backend::subscribeToTemperature() {
    m_subscribedEntities.insert("sensor.klimaatsensor_1_temperature");
    m_subscribedEntities.insert("sensor.klimaatsensor_2_temperature");
    m_subscribedEntities.insert("sensor.klimaatsensor_3_temperature");
}

void Backend::subscribeToHumidity() {
    m_subscribedEntities.insert("sensor.klimaatsensor_1_humidity");
    m_subscribedEntities.insert("sensor.klimaatsensor_2_humidity");
    m_subscribedEntities.insert("sensor.klimaatsensor_3_humidity");
}

void Backend::subscribeToMediaPlayer(const QString &entityId) {
    m_subscribedEntities.insert(entityId);
}

void Backend::subscribeToFan(const QString& entityId) {
    m_subscribedEntities.insert(entityId);
}
