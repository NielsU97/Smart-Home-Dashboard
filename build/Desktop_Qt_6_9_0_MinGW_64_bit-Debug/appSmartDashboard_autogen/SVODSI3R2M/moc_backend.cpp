/****************************************************************************
** Meta object code from reading C++ file 'backend.h'
**
** Created by: The Qt Meta Object Compiler version 69 (Qt 6.9.0)
**
** WARNING! All changes made in this file will be lost!
*****************************************************************************/

#include "../../../../cpp/backend.h"
#include <QtNetwork/QSslError>
#include <QtCore/qmetatype.h>

#include <QtCore/qtmochelpers.h>

#include <memory>


#include <QtCore/qxptype_traits.h>
#if !defined(Q_MOC_OUTPUT_REVISION)
#error "The header file 'backend.h' doesn't include <QObject>."
#elif Q_MOC_OUTPUT_REVISION != 69
#error "This file was generated using the moc from 6.9.0. It"
#error "cannot be used with the include files from this version of Qt."
#error "(The moc has changed too much.)"
#endif

#ifndef Q_CONSTINIT
#define Q_CONSTINIT
#endif

QT_WARNING_PUSH
QT_WARNING_DISABLE_DEPRECATED
QT_WARNING_DISABLE_GCC("-Wuseless-cast")
namespace {
struct qt_meta_tag_ZN7BackendE_t {};
} // unnamed namespace

template <> constexpr inline auto Backend::qt_create_metaobjectdata<qt_meta_tag_ZN7BackendE_t>()
{
    namespace QMC = QtMocConstants;
    QtMocHelpers::StringRefStorage qt_stringData {
        "Backend",
        "weatherUpdated",
        "",
        "temperature",
        "condition",
        "humidity",
        "icon",
        "alarmUpdated",
        "state",
        "temperatureUpdated",
        "temp",
        "humidityUpdated",
        "hum",
        "lightStateUpdated",
        "entityId",
        "isOn",
        "brightness",
        "mediaPlayerStateUpdated",
        "title",
        "artist",
        "albumArt",
        "volume",
        "isMuted",
        "getWeatherState",
        "getAlarmState",
        "getTemperature",
        "getHumidity",
        "getLightState",
        "setLightBrightness",
        "toggleLight",
        "on",
        "getMediaPlayerState",
        "mediaPlayPause",
        "mediaPlay",
        "mediaPause",
        "mediaStop",
        "mediaNextTrack",
        "mediaPreviousTrack",
        "mediaVolumeUp",
        "mediaVolumeDown",
        "mediaSetVolume",
        "mediaPlayMedia",
        "mediaUrl",
        "mediaType",
        "startMediaPlayerPolling",
        "interval",
        "stopMediaPlayerPolling"
    };

    QtMocHelpers::UintData qt_methods {
        // Signal 'weatherUpdated'
        QtMocHelpers::SignalData<void(QString, QString, QString, QString)>(1, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QString, 3 }, { QMetaType::QString, 4 }, { QMetaType::QString, 5 }, { QMetaType::QString, 6 },
        }}),
        // Signal 'alarmUpdated'
        QtMocHelpers::SignalData<void(const QString &, const QString &)>(7, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QString, 8 }, { QMetaType::QString, 6 },
        }}),
        // Signal 'temperatureUpdated'
        QtMocHelpers::SignalData<void(QString)>(9, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QString, 10 },
        }}),
        // Signal 'humidityUpdated'
        QtMocHelpers::SignalData<void(QString)>(11, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QString, 12 },
        }}),
        // Signal 'lightStateUpdated'
        QtMocHelpers::SignalData<void(const QString &, bool, int)>(13, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QString, 14 }, { QMetaType::Bool, 15 }, { QMetaType::Int, 16 },
        }}),
        // Signal 'mediaPlayerStateUpdated'
        QtMocHelpers::SignalData<void(const QString &, const QString &, const QString &, const QString &, int, bool)>(17, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QString, 8 }, { QMetaType::QString, 18 }, { QMetaType::QString, 19 }, { QMetaType::QString, 20 },
            { QMetaType::Int, 21 }, { QMetaType::Bool, 22 },
        }}),
        // Method 'getWeatherState'
        QtMocHelpers::MethodData<void()>(23, 2, QMC::AccessPublic, QMetaType::Void),
        // Method 'getAlarmState'
        QtMocHelpers::MethodData<void()>(24, 2, QMC::AccessPublic, QMetaType::Void),
        // Method 'getTemperature'
        QtMocHelpers::MethodData<void(const QString &)>(25, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QString, 14 },
        }}),
        // Method 'getHumidity'
        QtMocHelpers::MethodData<void(const QString &)>(26, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QString, 14 },
        }}),
        // Method 'getLightState'
        QtMocHelpers::MethodData<void(const QString &)>(27, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QString, 14 },
        }}),
        // Method 'setLightBrightness'
        QtMocHelpers::MethodData<void(const QString &, int)>(28, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QString, 14 }, { QMetaType::Int, 16 },
        }}),
        // Method 'toggleLight'
        QtMocHelpers::MethodData<void(const QString &, bool)>(29, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QString, 14 }, { QMetaType::Bool, 30 },
        }}),
        // Method 'getMediaPlayerState'
        QtMocHelpers::MethodData<void(const QString &)>(31, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QString, 14 },
        }}),
        // Method 'mediaPlayPause'
        QtMocHelpers::MethodData<void(const QString &)>(32, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QString, 14 },
        }}),
        // Method 'mediaPlay'
        QtMocHelpers::MethodData<void(const QString &)>(33, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QString, 14 },
        }}),
        // Method 'mediaPause'
        QtMocHelpers::MethodData<void(const QString &)>(34, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QString, 14 },
        }}),
        // Method 'mediaStop'
        QtMocHelpers::MethodData<void(const QString &)>(35, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QString, 14 },
        }}),
        // Method 'mediaNextTrack'
        QtMocHelpers::MethodData<void(const QString &)>(36, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QString, 14 },
        }}),
        // Method 'mediaPreviousTrack'
        QtMocHelpers::MethodData<void(const QString &)>(37, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QString, 14 },
        }}),
        // Method 'mediaVolumeUp'
        QtMocHelpers::MethodData<void(const QString &)>(38, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QString, 14 },
        }}),
        // Method 'mediaVolumeDown'
        QtMocHelpers::MethodData<void(const QString &)>(39, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QString, 14 },
        }}),
        // Method 'mediaSetVolume'
        QtMocHelpers::MethodData<void(const QString &, int)>(40, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QString, 14 }, { QMetaType::Int, 21 },
        }}),
        // Method 'mediaPlayMedia'
        QtMocHelpers::MethodData<void(const QString &, const QString &, const QString &)>(41, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QString, 14 }, { QMetaType::QString, 42 }, { QMetaType::QString, 43 },
        }}),
        // Method 'startMediaPlayerPolling'
        QtMocHelpers::MethodData<void(const QString &, int)>(44, 2, QMC::AccessPublic, QMetaType::Void, {{
            { QMetaType::QString, 14 }, { QMetaType::Int, 45 },
        }}),
        // Method 'startMediaPlayerPolling'
        QtMocHelpers::MethodData<void(const QString &)>(44, 2, QMC::AccessPublic | QMC::MethodCloned, QMetaType::Void, {{
            { QMetaType::QString, 14 },
        }}),
        // Method 'stopMediaPlayerPolling'
        QtMocHelpers::MethodData<void()>(46, 2, QMC::AccessPublic, QMetaType::Void),
    };
    QtMocHelpers::UintData qt_properties {
    };
    QtMocHelpers::UintData qt_enums {
    };
    return QtMocHelpers::metaObjectData<Backend, qt_meta_tag_ZN7BackendE_t>(QMC::MetaObjectFlag{}, qt_stringData,
            qt_methods, qt_properties, qt_enums);
}
Q_CONSTINIT const QMetaObject Backend::staticMetaObject = { {
    QMetaObject::SuperData::link<QObject::staticMetaObject>(),
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN7BackendE_t>.stringdata,
    qt_staticMetaObjectStaticContent<qt_meta_tag_ZN7BackendE_t>.data,
    qt_static_metacall,
    nullptr,
    qt_staticMetaObjectRelocatingContent<qt_meta_tag_ZN7BackendE_t>.metaTypes,
    nullptr
} };

void Backend::qt_static_metacall(QObject *_o, QMetaObject::Call _c, int _id, void **_a)
{
    auto *_t = static_cast<Backend *>(_o);
    if (_c == QMetaObject::InvokeMetaMethod) {
        switch (_id) {
        case 0: _t->weatherUpdated((*reinterpret_cast< std::add_pointer_t<QString>>(_a[1])),(*reinterpret_cast< std::add_pointer_t<QString>>(_a[2])),(*reinterpret_cast< std::add_pointer_t<QString>>(_a[3])),(*reinterpret_cast< std::add_pointer_t<QString>>(_a[4]))); break;
        case 1: _t->alarmUpdated((*reinterpret_cast< std::add_pointer_t<QString>>(_a[1])),(*reinterpret_cast< std::add_pointer_t<QString>>(_a[2]))); break;
        case 2: _t->temperatureUpdated((*reinterpret_cast< std::add_pointer_t<QString>>(_a[1]))); break;
        case 3: _t->humidityUpdated((*reinterpret_cast< std::add_pointer_t<QString>>(_a[1]))); break;
        case 4: _t->lightStateUpdated((*reinterpret_cast< std::add_pointer_t<QString>>(_a[1])),(*reinterpret_cast< std::add_pointer_t<bool>>(_a[2])),(*reinterpret_cast< std::add_pointer_t<int>>(_a[3]))); break;
        case 5: _t->mediaPlayerStateUpdated((*reinterpret_cast< std::add_pointer_t<QString>>(_a[1])),(*reinterpret_cast< std::add_pointer_t<QString>>(_a[2])),(*reinterpret_cast< std::add_pointer_t<QString>>(_a[3])),(*reinterpret_cast< std::add_pointer_t<QString>>(_a[4])),(*reinterpret_cast< std::add_pointer_t<int>>(_a[5])),(*reinterpret_cast< std::add_pointer_t<bool>>(_a[6]))); break;
        case 6: _t->getWeatherState(); break;
        case 7: _t->getAlarmState(); break;
        case 8: _t->getTemperature((*reinterpret_cast< std::add_pointer_t<QString>>(_a[1]))); break;
        case 9: _t->getHumidity((*reinterpret_cast< std::add_pointer_t<QString>>(_a[1]))); break;
        case 10: _t->getLightState((*reinterpret_cast< std::add_pointer_t<QString>>(_a[1]))); break;
        case 11: _t->setLightBrightness((*reinterpret_cast< std::add_pointer_t<QString>>(_a[1])),(*reinterpret_cast< std::add_pointer_t<int>>(_a[2]))); break;
        case 12: _t->toggleLight((*reinterpret_cast< std::add_pointer_t<QString>>(_a[1])),(*reinterpret_cast< std::add_pointer_t<bool>>(_a[2]))); break;
        case 13: _t->getMediaPlayerState((*reinterpret_cast< std::add_pointer_t<QString>>(_a[1]))); break;
        case 14: _t->mediaPlayPause((*reinterpret_cast< std::add_pointer_t<QString>>(_a[1]))); break;
        case 15: _t->mediaPlay((*reinterpret_cast< std::add_pointer_t<QString>>(_a[1]))); break;
        case 16: _t->mediaPause((*reinterpret_cast< std::add_pointer_t<QString>>(_a[1]))); break;
        case 17: _t->mediaStop((*reinterpret_cast< std::add_pointer_t<QString>>(_a[1]))); break;
        case 18: _t->mediaNextTrack((*reinterpret_cast< std::add_pointer_t<QString>>(_a[1]))); break;
        case 19: _t->mediaPreviousTrack((*reinterpret_cast< std::add_pointer_t<QString>>(_a[1]))); break;
        case 20: _t->mediaVolumeUp((*reinterpret_cast< std::add_pointer_t<QString>>(_a[1]))); break;
        case 21: _t->mediaVolumeDown((*reinterpret_cast< std::add_pointer_t<QString>>(_a[1]))); break;
        case 22: _t->mediaSetVolume((*reinterpret_cast< std::add_pointer_t<QString>>(_a[1])),(*reinterpret_cast< std::add_pointer_t<int>>(_a[2]))); break;
        case 23: _t->mediaPlayMedia((*reinterpret_cast< std::add_pointer_t<QString>>(_a[1])),(*reinterpret_cast< std::add_pointer_t<QString>>(_a[2])),(*reinterpret_cast< std::add_pointer_t<QString>>(_a[3]))); break;
        case 24: _t->startMediaPlayerPolling((*reinterpret_cast< std::add_pointer_t<QString>>(_a[1])),(*reinterpret_cast< std::add_pointer_t<int>>(_a[2]))); break;
        case 25: _t->startMediaPlayerPolling((*reinterpret_cast< std::add_pointer_t<QString>>(_a[1]))); break;
        case 26: _t->stopMediaPlayerPolling(); break;
        default: ;
        }
    }
    if (_c == QMetaObject::IndexOfMethod) {
        if (QtMocHelpers::indexOfMethod<void (Backend::*)(QString , QString , QString , QString )>(_a, &Backend::weatherUpdated, 0))
            return;
        if (QtMocHelpers::indexOfMethod<void (Backend::*)(const QString & , const QString & )>(_a, &Backend::alarmUpdated, 1))
            return;
        if (QtMocHelpers::indexOfMethod<void (Backend::*)(QString )>(_a, &Backend::temperatureUpdated, 2))
            return;
        if (QtMocHelpers::indexOfMethod<void (Backend::*)(QString )>(_a, &Backend::humidityUpdated, 3))
            return;
        if (QtMocHelpers::indexOfMethod<void (Backend::*)(const QString & , bool , int )>(_a, &Backend::lightStateUpdated, 4))
            return;
        if (QtMocHelpers::indexOfMethod<void (Backend::*)(const QString & , const QString & , const QString & , const QString & , int , bool )>(_a, &Backend::mediaPlayerStateUpdated, 5))
            return;
    }
}

const QMetaObject *Backend::metaObject() const
{
    return QObject::d_ptr->metaObject ? QObject::d_ptr->dynamicMetaObject() : &staticMetaObject;
}

void *Backend::qt_metacast(const char *_clname)
{
    if (!_clname) return nullptr;
    if (!strcmp(_clname, qt_staticMetaObjectStaticContent<qt_meta_tag_ZN7BackendE_t>.strings))
        return static_cast<void*>(this);
    return QObject::qt_metacast(_clname);
}

int Backend::qt_metacall(QMetaObject::Call _c, int _id, void **_a)
{
    _id = QObject::qt_metacall(_c, _id, _a);
    if (_id < 0)
        return _id;
    if (_c == QMetaObject::InvokeMetaMethod) {
        if (_id < 27)
            qt_static_metacall(this, _c, _id, _a);
        _id -= 27;
    }
    if (_c == QMetaObject::RegisterMethodArgumentMetaType) {
        if (_id < 27)
            *reinterpret_cast<QMetaType *>(_a[0]) = QMetaType();
        _id -= 27;
    }
    return _id;
}

// SIGNAL 0
void Backend::weatherUpdated(QString _t1, QString _t2, QString _t3, QString _t4)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 0, nullptr, _t1, _t2, _t3, _t4);
}

// SIGNAL 1
void Backend::alarmUpdated(const QString & _t1, const QString & _t2)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 1, nullptr, _t1, _t2);
}

// SIGNAL 2
void Backend::temperatureUpdated(QString _t1)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 2, nullptr, _t1);
}

// SIGNAL 3
void Backend::humidityUpdated(QString _t1)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 3, nullptr, _t1);
}

// SIGNAL 4
void Backend::lightStateUpdated(const QString & _t1, bool _t2, int _t3)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 4, nullptr, _t1, _t2, _t3);
}

// SIGNAL 5
void Backend::mediaPlayerStateUpdated(const QString & _t1, const QString & _t2, const QString & _t3, const QString & _t4, int _t5, bool _t6)
{
    QMetaObject::activate<void>(this, &staticMetaObject, 5, nullptr, _t1, _t2, _t3, _t4, _t5, _t6);
}
QT_WARNING_POP
