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

void Backend::getWeather() {
    QNetworkRequest request(QUrl(baseUrl + "/states/weather.forecast_thuis"));
    request.setRawHeader("Authorization", "Bearer " + token.toUtf8());

    QNetworkReply* reply = manager.get(request);
    connect(reply, &QNetworkReply::finished, [this, reply]() {
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
            QString translatedCondition = conditionTranslationMap.value(condition, condition);  // fallback to original if no match

            emit weatherUpdated(temperature, translatedCondition, humidity, icon);
        } else {
            qWarning() << "Weather fetch failed:" << reply->errorString();
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

void Backend::startLightPolling(const QString& entityId) {
    trackedEntity = entityId;
    getLightState(entityId);  // Initial fetch
    pollTimer.start(1000);    // Poll every 3 seconds
}

void Backend::getLightState(const QString& entityId) {
    QNetworkRequest request(QUrl(baseUrl + "/states/" + entityId));
    request.setRawHeader("Authorization", "Bearer " + token.toUtf8());
    request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");

    QNetworkReply* reply = manager.get(request);

    connect(reply, &QNetworkReply::finished, this, [this, reply]() {
        if (reply->error() == QNetworkReply::NoError) {
            const QByteArray response = reply->readAll();
            QJsonDocument json = QJsonDocument::fromJson(response);
            QJsonObject obj = json.object();
            QString state = obj["state"].toString();

            if (state != lastState) {
                lastState = state;
                emit lightStateUpdated(state == "on");
            }
        } else {
            qWarning() << "Polling error:" << reply->errorString();
        }
        reply->deleteLater();
    });
}

void Backend::getTemperature() {
    QNetworkRequest request(QUrl(baseUrl + "/states/sensor.klimaatsensor_1_temperature"));
    request.setRawHeader("Authorization", "Bearer " + token.toUtf8());

    QNetworkReply *reply = manager.get(request);
    connect(reply, &QNetworkReply::finished, [this, reply]() {
        QJsonDocument doc = QJsonDocument::fromJson(reply->readAll());
        QString temp = doc.object().value("state").toString();
        emit temperatureUpdated(temp);
        reply->deleteLater();
    });
}

