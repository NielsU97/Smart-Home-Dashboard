#include "backend.h"
#include <QJsonDocument>
#include <QJsonObject>
#include <QNetworkRequest>
#include <QJsonArray>

Backend::Backend(QObject* parent) : QObject(parent) {
    connect(&pollTimer, &QTimer::timeout, this, [this]() {
        if (!trackedEntity.isEmpty())
            getLightState(trackedEntity);
    });
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

            QString previousState = lastStateMap.value(entityId, "");
            int previousBrightness = lastBrightnessMap.value(entityId, -1);

            if (state != previousState || brightnessPct != previousBrightness) {
                lastStateMap[entityId] = state;
                lastBrightnessMap[entityId] = brightnessPct;

                emit lightStateUpdated(entityId, state == "on", brightnessPct);
            }
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

    manager.post(request, QJsonDocument(payload).toJson());
}

void Backend::setLightBrightness(const QString& entityId, int brightness) {
    QNetworkRequest request(QUrl(baseUrl + "/services/light/turn_on"));
    request.setRawHeader("Authorization", "Bearer " + token.toUtf8());
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");

    QJsonObject payload;
    payload["entity_id"] = entityId;
    payload["brightness_pct"] = brightness;

    manager.post(request, QJsonDocument(payload).toJson());
}

void Backend::startLightPolling(int intervalMs) {
    disconnect(lightPollingTimer, nullptr, nullptr, nullptr);

    connect(lightPollingTimer, &QTimer::timeout, this, [this]() {
        getLightState("light.woonkamer");
        getLightState("light.slaapkamer");
        getLightState("light.ganglamp_licht");
        getLightState("light.berginglamp_licht");
    });

    lightPollingTimer->start(intervalMs);
}

void Backend::stopLightPolling() {
    if (lightPollingTimer->isActive())
        lightPollingTimer->stop();
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

            // Check if anything changed before emitting signal
            if (state != lastMediaPlayerState ||
                mediaTitle != lastMediaTitle ||
                mediaArtist != lastMediaArtist ||
                albumArt != lastMediaAlbumArt ||
                volume != lastMediaVolume ||
                isMuted != lastMediaMuted) {

                // Update last known values
                lastMediaPlayerState = state;
                lastMediaTitle = mediaTitle;
                lastMediaArtist = mediaArtist;
                lastMediaAlbumArt = albumArt;
                lastMediaVolume = volume;
                lastMediaMuted = isMuted;

                // Emit the signal with updated values
                emit mediaPlayerStateUpdated(state, mediaTitle, mediaArtist, albumArt, volume, isMuted);
            }
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

    QNetworkReply* reply = manager.post(request, QJsonDocument(payload).toJson());
    connect(reply, &QNetworkReply::finished, reply, &QObject::deleteLater);
}

void Backend::mediaPause(const QString& entityId) {
    QNetworkRequest request(QUrl(baseUrl + "/services/media_player/media_pause"));
    request.setRawHeader("Authorization", "Bearer " + token.toUtf8());
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");

    QJsonObject payload;
    payload["entity_id"] = entityId;

    QNetworkReply* reply = manager.post(request, QJsonDocument(payload).toJson());
    connect(reply, &QNetworkReply::finished, reply, &QObject::deleteLater);
}

void Backend::mediaStop(const QString& entityId) {
    QNetworkRequest request(QUrl(baseUrl + "/services/media_player/media_stop"));
    request.setRawHeader("Authorization", "Bearer " + token.toUtf8());
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");

    QJsonObject payload;
    payload["entity_id"] = entityId;

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
}

void Backend::mediaPreviousTrack(const QString& entityId) {
    QNetworkRequest request(QUrl(baseUrl + "/services/media_player/media_previous_track"));
    request.setRawHeader("Authorization", "Bearer " + token.toUtf8());
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");

    QJsonObject payload;
    payload["entity_id"] = entityId;

    QNetworkReply* reply = manager.post(request, QJsonDocument(payload).toJson());
    connect(reply, &QNetworkReply::finished, reply, &QObject::deleteLater);
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
