#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QFontDatabase>
#include <QFont>
#include <QQuickStyle>
#include <QQmlContext>
#include <QtCore/QStringLiteral>
#include <QCursor>

#include "backend.h"

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    //QGuiApplication::setOverrideCursor(Qt::BlankCursor);

    QQuickStyle::setStyle("Basic");

    QFontDatabase::addApplicationFont(":/SmartDashboard/assets/fonts/CodecPro-Regular.ttf");

    QFont font("Codec Pro");
    QGuiApplication::setFont(font);

    QQmlApplicationEngine engine;

    Backend backend;
    backend.setUrl("http://YOUR_HOMEASSISTANT_URL:8123/api");
    backend.setAuthToken("YOUR_HOMEASSISTANT_TOKEN");

    engine.rootContext()->setContextProperty("backend", &backend);

    const QUrl url(QStringLiteral("qrc:/SmartDashboard/qml/Main.qml"));

    QObject::connect(
        &engine,
        &QQmlApplicationEngine::objectCreationFailed,
        &app,
        []() { QCoreApplication::exit(-1); },
        Qt::QueuedConnection);

    engine.load(url);

    backend.subscribeToWeather();
    backend.subscribeToAlarm();
    backend.subscribeToLights();
    backend.subscribeToMediaPlayer("media_player.google_nest");
    backend.subscribeToFan("fan.ecofan");
    backend.subscribeToTemperature();
    backend.subscribeToHumidity();

    QMetaObject::invokeMethod(&backend, "connectWebSocket", Qt::QueuedConnection);

    return app.exec();
}
