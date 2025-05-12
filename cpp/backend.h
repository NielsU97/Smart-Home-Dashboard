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

    Q_INVOKABLE void getWeatherState();
    Q_INVOKABLE void getAlarmState();

    Q_INVOKABLE void getTemperature(const QString& entityId);
    Q_INVOKABLE void getHumidity(const QString& entityId);

    Q_INVOKABLE void getLightState(const QString& entityId);
    Q_INVOKABLE void setLightBrightness(const QString& entityId, int brightness);
    Q_INVOKABLE void toggleLight(const QString& entityId, bool on);

signals:
    void weatherUpdated(QString temperature, QString condition, QString humidity, QString icon);
    void alarmUpdated(const QString& state, const QString& icon);
    void temperatureUpdated(QString temp);
    void humidityUpdated(QString hum);

    void lightStateUpdated(const QString &entityId, bool isOn, int brightness);

private:
    QNetworkAccessManager manager;
    const QString token = "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJmMThiOTUxOGY0MDQ0ZDU3YjcyN2Q2ZDBkZTAzNGUzZSIsImlhdCI6MTc0Njg2OTEzMiwiZXhwIjoyMDYyMjI5MTMyfQ.2oXtT8OpzYq-Cd7wz7Ubj76vDpHF_U9LzaGOTUP45R4";
    const QString baseUrl = "http://192.168.2.1:8123/api";
    QTimer pollTimer;
    QString lastState;
    QString trackedEntity;

    QHash<QString, QString> lastStateMap;
    QHash<QString, int> lastBrightnessMap;
};

#endif // BACKEND_H
