#ifndef BACKEND_H
#define BACKEND_H

#include <QObject>
#include <QNetworkAccessManager>
#include <QNetworkReply>
#include <QTimer>

class Backend : public QObject
{
    Q_OBJECT
public:
    explicit Backend(QObject *parent = nullptr);

    Q_INVOKABLE void toggleLight(const QString& entityId, bool on);
    Q_INVOKABLE void getLightState(const QString& entityId);
    Q_INVOKABLE void startLightPolling(const QString& entityId);

    Q_INVOKABLE void getTemperature();

    Q_INVOKABLE void getWeather();


    Q_INVOKABLE QString getWeatherIcon(const QString &state) {
        QString icon;
        if (state.toLower() == "sunny") {
            icon = "\uf185";  // Sun icon
        } else if (state.toLower() == "clear-night") {
            icon = "\uf186";  // Moon icon
        } else if (state.toLower() == "partlycloudy") {
            icon = "\uf6c4";  // Cloud-Sun icon
        } else if (state.toLower() == "cloudy") {
            icon = "\uf0c2";  // Cloud icon
        } else if (state.toLower() == "rainy") {
            icon = "\uf740";  // Cloud-Rain icon
        } else if (state.toLower() == "pouring") {
            icon = "\uf73d";  // Heavy Rain icon
        } else if (state.toLower() == "snowy") {
            icon = "\uf2dc";  // Snowflake icon
        } else if (state.toLower() == "windy") {
            icon = "\uf72e";  // Wind icon
        } else if (state.toLower() == "fog") {
            icon = "\uf74e";  // Smog icon
        } else {
            icon = "\uf75f";  // Unknown icon
        }

        return icon;
    }

signals:
    void temperatureUpdated(QString temp);
    void lightStateUpdated(bool isOn);
    void weatherUpdated(QString temperature, QString condition, QString min, QString max);

private:
    QNetworkAccessManager manager;
    const QString token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJmMThiOTUxOGY0MDQ0ZDU3YjcyN2Q2ZDBkZTAzNGUzZSIsImlhdCI6MTc0Njg2OTEzMiwiZXhwIjoyMDYyMjI5MTMyfQ.2oXtT8OpzYq-Cd7wz7Ubj76vDpHF_U9LzaGOTUP45R4";
    const QString baseUrl = "http://192.168.2.1:8123/api";
    QTimer pollTimer;
    QString lastState;
    QString trackedEntity;
};

#endif // BACKEND_H
