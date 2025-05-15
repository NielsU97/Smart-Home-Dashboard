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
    engine.rootContext()->setContextProperty("backend", &backend);

    const QUrl url(QStringLiteral("qrc:/SmartDashboard/qml/Main.qml"));

    QObject::connect(
      &engine,
      &QQmlApplicationEngine::objectCreationFailed,
       &app,
       []() { QCoreApplication::exit(-1); },
       Qt::QueuedConnection);

    engine.load(url);

    return app.exec();
}
