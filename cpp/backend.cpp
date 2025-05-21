#include "backend.h"
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QDebug>

Backend::Backend(QObject* parent) : QObject(parent) {

}

void Backend::setAuthToken(const QString& authToken) {
    token = authToken;
}

void Backend::setUrl(const QString& url) {
    baseUrl = url;
}

void Backend::getWeatherState() {
    QNetworkRequest request(QUrl(baseUrl + "/states/weather.forecast_thuis"));
    request.setRawHeader("Authorization", "Bearer " + token.toUtf8());

    QNetworkReply* reply = manager.get(request);
    connect(reply, &QNetworkReply::finished, this, [this, reply]() {
        if (reply->error() == QNetworkReply::NoError) {
            QJsonDocument doc = QJsonDocument::fromJson(reply->readAll());
            QJsonObject obj = doc.object();

            QString temperature = obj["attributes"].toObject().value("temperature").toVariant().toString();
            QString condition = obj["state"].toString();
            QString humidity = obj["attributes"].toObject().value("humidity").toVariant().toString();

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
        } else {
            qWarning() << "Weather fetch failed:" << reply->errorString();
        }

        reply->deleteLater();
    }, Qt::QueuedConnection);
}

void Backend::getAlarmState() {
    QNetworkRequest request(QUrl(baseUrl + "/states/alarm_control_panel.alarm"));
    request.setRawHeader("Authorization", "Bearer " + token.toUtf8());

    QNetworkReply* reply = manager.get(request);
    connect(reply, &QNetworkReply::finished, this, [this, reply]() {
        if (reply->error() == QNetworkReply::NoError) {
            QJsonDocument doc = QJsonDocument::fromJson(reply->readAll());
            QJsonObject obj = doc.object();

            QString state = obj["state"].toString();

            static const QHash<QString, QString> iconMap = {
                { "disarmed",       "\uf3ed" },  // lock open
                { "armed_home",     "\uf015" },  // home
                { "armed_away",     "\uf132" },  // lock
                { "armed_night",    "\uf186" },  // moon
                { "triggered",      "\uf12a" }   // exclamation
            };

            QString icon = iconMap.value(state, "\u231b"); // fallback icon

            emit alarmUpdated(state, icon);
        } else {
            qWarning() << "Alarm state fetch failed:" << reply->errorString();
        }

        reply->deleteLater();
    }, Qt::QueuedConnection);
}

void Backend::getTemperature(const QString& entityId) {
    QNetworkRequest request(QUrl(baseUrl + "/states/" + entityId));
    request.setRawHeader("Authorization", "Bearer " + token.toUtf8());

    QNetworkReply* reply = manager.get(request);
    connect(reply, &QNetworkReply::finished, this, [this, reply]() {
        QJsonDocument doc = QJsonDocument::fromJson(reply->readAll());
        QString temp = doc.object().value("state").toString();
        emit temperatureUpdated(temp);
        reply->deleteLater();
    }, Qt::QueuedConnection);
}

void Backend::getHumidity(const QString& entityId) {
    QNetworkRequest request(QUrl(baseUrl + "/states/" + entityId));
    request.setRawHeader("Authorization", "Bearer " + token.toUtf8());

    QNetworkReply* reply = manager.get(request);
    connect(reply, &QNetworkReply::finished, this, [this, reply]() {
        QJsonDocument doc = QJsonDocument::fromJson(reply->readAll());
        QString hum = doc.object().value("state").toString();
        emit humidityUpdated(hum);
        reply->deleteLater();
    }, Qt::QueuedConnection);
}

void Backend::getLightState(const QString& entityId) {
    QNetworkRequest request(QUrl(baseUrl + "/states/" + entityId));
    request.setRawHeader("Authorization", "Bearer " + token.toUtf8());
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");

    QNetworkReply* reply = manager.get(request);

    connect(reply, &QNetworkReply::finished, this, [this, reply, entityId]() {
        if (reply->error() == QNetworkReply::NoError) {
            const QByteArray response = reply->readAll();
            QJsonDocument json = QJsonDocument::fromJson(response);
            QJsonObject obj = json.object();
            QString state = obj["state"].toString();

            int brightness = obj["attributes"].toObject().value("brightness").toInt();
            int brightnessPct = brightness * 100 / 255;

            // Always update our internal cache
            lastStateMap[entityId] = state;
            lastBrightnessMap[entityId] = brightnessPct;

            // Always emit the signal when actively requested
            emit lightStateUpdated(entityId, state == "on", brightnessPct);
        } else {
            qWarning() << "Polling error:" << reply->errorString();
        }
        reply->deleteLater();
    });
}

void Backend::toggleLight(const QString& entityId, bool on) {
    QNetworkRequest request(QUrl(baseUrl + "/services/light/" + (on ? "turn_on" : "turn_off")));
    request.setRawHeader("Authorization", "Bearer " + token.toUtf8());
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");

    QJsonObject payload;
    payload["entity_id"] = entityId;

    // Update our internal state cache immediately for better responsiveness
    lastStateMap[entityId] = on ? "on" : "off";

    manager.post(request, QJsonDocument(payload).toJson());
}

void Backend::setLightBrightness(const QString& entityId, int brightness) {
    QNetworkRequest request(QUrl(baseUrl + "/services/light/turn_on"));
    request.setRawHeader("Authorization", "Bearer " + token.toUtf8());
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");

    QJsonObject payload;
    payload["entity_id"] = entityId;
    payload["brightness_pct"] = brightness;

    // Update our internal brightness cache immediately
    lastBrightnessMap[entityId] = brightness;
    lastStateMap[entityId] = "on"; // If setting brightness, the light must be on

    manager.post(request, QJsonDocument(payload).toJson());
}

void Backend::startLightPolling(int interval) {
    // Initial fetch
    getLightState("light.woonkamer");
    getLightState("light.slaapkamer");
    getLightState("light.ganglamp_licht");
    getLightState("light.berginglamp_licht");

    // Stop existing timer if running
    if (lightPollingTimer.isActive()) {
        lightPollingTimer.stop();
        emit lightPollingStatusChanged(false);
    }

    lightPollingTimer.setInterval(interval);

    // Avoid multiple connections
    disconnect(&lightPollingTimer, nullptr, this, nullptr);

    // Set up timer for polling
    connect(&lightPollingTimer, &QTimer::timeout, this, [this]() {
        getLightState("light.woonkamer");
        getLightState("light.slaapkamer");
        getLightState("light.ganglamp_licht");
        getLightState("light.berginglamp_licht");
    });

    lightPollingTimer.start();
    emit lightPollingStatusChanged(true);
}

void Backend::stopLightPolling() {
    if (lightPollingTimer.isActive()) {
        lightPollingTimer.stop();
        emit lightPollingStatusChanged(false);
    }
}

// Helper method to update cache and emit signal
void Backend::updateMediaPlayerCache(const QString &state, const QString &title,
                                     const QString &artist, const QString &albumArt,
                                     int volume, bool muted) {
    // Update cache
    lastMediaPlayerState = state;
    lastMediaTitle = title;
    lastMediaArtist = artist;
    lastMediaAlbumArt = albumArt;
    lastMediaVolume = volume;
    lastMediaMuted = muted;

    // Emit signal
    emit mediaPlayerStateUpdated(state, title, artist, albumArt, volume, muted);
}

void Backend::getMediaPlayerState(const QString& entityId) {
    QNetworkRequest request(QUrl(baseUrl + "/states/" + entityId));
    request.setRawHeader("Authorization", "Bearer " + token.toUtf8());
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");

    QNetworkReply* reply = manager.get(request);

    connect(reply, &QNetworkReply::finished, this, [this, reply, entityId]() {
        if (reply->error() == QNetworkReply::NoError) {
            const QByteArray response = reply->readAll();
            QJsonDocument json = QJsonDocument::fromJson(response);
            QJsonObject obj = json.object();
            QJsonObject attributes = obj["attributes"].toObject();

            // Get basic state
            QString state = obj["state"].toString();

            // Get media information from attributes
            QString mediaTitle = attributes.value("media_title").toString();
            QString mediaArtist = attributes.value("media_artist").toString();
            QString albumArt = attributes.value("entity_picture").toString();
            int volume = qRound(attributes.value("volume_level").toDouble() * 100); // Convert 0.0-1.0 to 0-100
            bool isMuted = attributes.value("is_volume_muted").toBool();

            // If the album art URL is relative, prepend the base URL
            if (!albumArt.isEmpty() && !albumArt.startsWith("http")) {
                // Remove /api from baseUrl for entity pictures
                QString baseUrlPrefix = baseUrl;
                baseUrlPrefix.replace("/api", "");
                albumArt = baseUrlPrefix + albumArt;
            }

            // Always update cache and emit signal when explicitly requested
            updateMediaPlayerCache(state, mediaTitle, mediaArtist, albumArt, volume, isMuted);
        } else {
            qWarning() << "Media player state fetch failed:" << reply->errorString();
        }
        reply->deleteLater();
    });
}

void Backend::mediaPlayPause(const QString& entityId) {
    QNetworkRequest request(QUrl(baseUrl + "/services/media_player/media_play_pause"));
    request.setRawHeader("Authorization", "Bearer " + token.toUtf8());
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");

    QJsonObject payload;
    payload["entity_id"] = entityId;

    QNetworkReply* reply = manager.post(request, QJsonDocument(payload).toJson());
    connect(reply, &QNetworkReply::finished, reply, &QObject::deleteLater);
}

void Backend::mediaPlay(const QString& entityId) {
    QNetworkRequest request(QUrl(baseUrl + "/services/media_player/media_play"));
    request.setRawHeader("Authorization", "Bearer " + token.toUtf8());
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");

    QJsonObject payload;
    payload["entity_id"] = entityId;

    // Update our cached state optimistically for better responsiveness
    if (!lastMediaPlayerState.isEmpty()) {
        updateMediaPlayerCache("playing", lastMediaTitle, lastMediaArtist,
                               lastMediaAlbumArt, lastMediaVolume, lastMediaMuted);
    }

    QNetworkReply* reply = manager.post(request, QJsonDocument(payload).toJson());
    connect(reply, &QNetworkReply::finished, reply, &QObject::deleteLater);
}

void Backend::mediaPause(const QString& entityId) {
    QNetworkRequest request(QUrl(baseUrl + "/services/media_player/media_pause"));
    request.setRawHeader("Authorization", "Bearer " + token.toUtf8());
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");

    QJsonObject payload;
    payload["entity_id"] = entityId;

    // Update our cached state optimistically for better responsiveness
    if (!lastMediaPlayerState.isEmpty()) {
        updateMediaPlayerCache("paused", lastMediaTitle, lastMediaArtist,
                               lastMediaAlbumArt, lastMediaVolume, lastMediaMuted);
    }

    QNetworkReply* reply = manager.post(request, QJsonDocument(payload).toJson());
    connect(reply, &QNetworkReply::finished, reply, &QObject::deleteLater);
}

void Backend::mediaStop(const QString& entityId) {
    QNetworkRequest request(QUrl(baseUrl + "/services/media_player/media_stop"));
    request.setRawHeader("Authorization", "Bearer " + token.toUtf8());
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");

    QJsonObject payload;
    payload["entity_id"] = entityId;

    // Update our cached state optimistically
    if (!lastMediaPlayerState.isEmpty()) {
        updateMediaPlayerCache("idle", lastMediaTitle, lastMediaArtist,
                               lastMediaAlbumArt, lastMediaVolume, lastMediaMuted);
    }

    QNetworkReply* reply = manager.post(request, QJsonDocument(payload).toJson());
    connect(reply, &QNetworkReply::finished, reply, &QObject::deleteLater);
}

void Backend::mediaNextTrack(const QString& entityId) {
    QNetworkRequest request(QUrl(baseUrl + "/services/media_player/media_next_track"));
    request.setRawHeader("Authorization", "Bearer " + token.toUtf8());
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");

    QJsonObject payload;
    payload["entity_id"] = entityId;

    QNetworkReply* reply = manager.post(request, QJsonDocument(payload).toJson());
    connect(reply, &QNetworkReply::finished, reply, &QObject::deleteLater);

    // Force update after a short delay to get the new track info
    QTimer::singleShot(500, this, [this, entityId]() {
        getMediaPlayerState(entityId);
    });
}

void Backend::mediaPreviousTrack(const QString& entityId) {
    QNetworkRequest request(QUrl(baseUrl + "/services/media_player/media_previous_track"));
    request.setRawHeader("Authorization", "Bearer " + token.toUtf8());
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");

    QJsonObject payload;
    payload["entity_id"] = entityId;

    QNetworkReply* reply = manager.post(request, QJsonDocument(payload).toJson());
    connect(reply, &QNetworkReply::finished, reply, &QObject::deleteLater);

    // Force update after a short delay to get the new track info
    QTimer::singleShot(500, this, [this, entityId]() {
        getMediaPlayerState(entityId);
    });
}

void Backend::mediaVolumeUp(const QString& entityId) {
    QNetworkRequest request(QUrl(baseUrl + "/services/media_player/volume_up"));
    request.setRawHeader("Authorization", "Bearer " + token.toUtf8());
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");

    QJsonObject payload;
    payload["entity_id"] = entityId;

    QNetworkReply* reply = manager.post(request, QJsonDocument(payload).toJson());
    connect(reply, &QNetworkReply::finished, reply, &QObject::deleteLater);
}

void Backend::mediaVolumeDown(const QString& entityId) {
    QNetworkRequest request(QUrl(baseUrl + "/services/media_player/volume_down"));
    request.setRawHeader("Authorization", "Bearer " + token.toUtf8());
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");

    QJsonObject payload;
    payload["entity_id"] = entityId;

    QNetworkReply* reply = manager.post(request, QJsonDocument(payload).toJson());
    connect(reply, &QNetworkReply::finished, reply, &QObject::deleteLater);
}

void Backend::mediaSetVolume(const QString& entityId, int volume) {
    QNetworkRequest request(QUrl(baseUrl + "/services/media_player/volume_set"));
    request.setRawHeader("Authorization", "Bearer " + token.toUtf8());
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");

    QJsonObject payload;
    payload["entity_id"] = entityId;
    payload["volume_level"] = volume / 100.0; // Convert from 0-100 to 0.0-1.0

    QNetworkReply* reply = manager.post(request, QJsonDocument(payload).toJson());
    connect(reply, &QNetworkReply::finished, reply, &QObject::deleteLater);
}

void Backend::mediaPlayMedia(const QString& entityId, const QString& mediaUrl, const QString& mediaType) {
    QNetworkRequest request(QUrl(baseUrl + "/services/media_player/play_media"));
    request.setRawHeader("Authorization", "Bearer " + token.toUtf8());
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");

    QJsonObject payload;
    payload["entity_id"] = entityId;
    payload["media_content_id"] = mediaUrl;
    payload["media_content_type"] = mediaType;

    QNetworkReply* reply = manager.post(request, QJsonDocument(payload).toJson());
    connect(reply, &QNetworkReply::finished, reply, &QObject::deleteLater);
}

void Backend::startMediaPlayerPolling(const QString& entityId, int interval) {
    // Store the entity ID we're tracking
    trackedMediaPlayer = entityId;

    // Initial fetch
    getMediaPlayerState(entityId);

    // Set up timer for polling
    mediaPlayerPollTimer.stop();
    mediaPlayerPollTimer.setInterval(interval);
    connect(&mediaPlayerPollTimer, &QTimer::timeout, this, [this, entityId]() {
        getMediaPlayerState(entityId);
    });
    mediaPlayerPollTimer.start();
}

void Backend::stopMediaPlayerPolling() {
    mediaPlayerPollTimer.stop();
    trackedMediaPlayer.clear();
}
