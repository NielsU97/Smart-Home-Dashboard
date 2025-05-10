#include <QtQml/qqmlprivate.h>
#include <QtCore/qdir.h>
#include <QtCore/qurl.h>
#include <QtCore/qhash.h>
#include <QtCore/qstring.h>

namespace QmlCacheGeneratedCode {
namespace _0x5f_SmartDashboard_qml_Main_qml { 
    extern const unsigned char qmlData[];
    extern const QQmlPrivate::AOTCompiledFunction aotBuiltFunctions[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), &aotBuiltFunctions[0], nullptr
    };
}
namespace _0x5f_SmartDashboard_qml_components_IconLabel_qml { 
    extern const unsigned char qmlData[];
    extern const QQmlPrivate::AOTCompiledFunction aotBuiltFunctions[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), &aotBuiltFunctions[0], nullptr
    };
}
namespace _0x5f_SmartDashboard_qml_components_LeftPane_qml { 
    extern const unsigned char qmlData[];
    extern const QQmlPrivate::AOTCompiledFunction aotBuiltFunctions[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), &aotBuiltFunctions[0], nullptr
    };
}
namespace _0x5f_SmartDashboard_qml_components_MiddlePane_qml { 
    extern const unsigned char qmlData[];
    extern const QQmlPrivate::AOTCompiledFunction aotBuiltFunctions[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), &aotBuiltFunctions[0], nullptr
    };
}
namespace _0x5f_SmartDashboard_qml_components_RightPane_qml { 
    extern const unsigned char qmlData[];
    extern const QQmlPrivate::AOTCompiledFunction aotBuiltFunctions[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), &aotBuiltFunctions[0], nullptr
    };
}
namespace _0x5f_SmartDashboard_qml_components_MiddlePaneWidget_qml { 
    extern const unsigned char qmlData[];
    extern const QQmlPrivate::AOTCompiledFunction aotBuiltFunctions[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), &aotBuiltFunctions[0], nullptr
    };
}
namespace _0x5f_SmartDashboard_qml_components_Switch_qml { 
    extern const unsigned char qmlData[];
    extern const QQmlPrivate::AOTCompiledFunction aotBuiltFunctions[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), &aotBuiltFunctions[0], nullptr
    };
}
namespace _0x5f_SmartDashboard_qml_components_Progressbar_qml { 
    extern const unsigned char qmlData[];
    extern const QQmlPrivate::AOTCompiledFunction aotBuiltFunctions[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), &aotBuiltFunctions[0], nullptr
    };
}
namespace _0x5f_SmartDashboard_qml_components_RightPaneLightSwitchComponent_qml { 
    extern const unsigned char qmlData[];
    extern const QQmlPrivate::AOTCompiledFunction aotBuiltFunctions[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), &aotBuiltFunctions[0], nullptr
    };
}
namespace _0x5f_SmartDashboard_qml_components_CircularProgressBar_qml { 
    extern const unsigned char qmlData[];
    extern const QQmlPrivate::AOTCompiledFunction aotBuiltFunctions[];
    const QQmlPrivate::CachedQmlUnit unit = {
        reinterpret_cast<const QV4::CompiledData::Unit*>(&qmlData), &aotBuiltFunctions[0], nullptr
    };
}

}
namespace {
struct Registry {
    Registry();
    ~Registry();
    QHash<QString, const QQmlPrivate::CachedQmlUnit*> resourcePathToCachedUnit;
    static const QQmlPrivate::CachedQmlUnit *lookupCachedUnit(const QUrl &url);
};

Q_GLOBAL_STATIC(Registry, unitRegistry)


Registry::Registry() {
    resourcePathToCachedUnit.insert(QStringLiteral("/SmartDashboard/qml/Main.qml"), &QmlCacheGeneratedCode::_0x5f_SmartDashboard_qml_Main_qml::unit);
    resourcePathToCachedUnit.insert(QStringLiteral("/SmartDashboard/qml/components/IconLabel.qml"), &QmlCacheGeneratedCode::_0x5f_SmartDashboard_qml_components_IconLabel_qml::unit);
    resourcePathToCachedUnit.insert(QStringLiteral("/SmartDashboard/qml/components/LeftPane.qml"), &QmlCacheGeneratedCode::_0x5f_SmartDashboard_qml_components_LeftPane_qml::unit);
    resourcePathToCachedUnit.insert(QStringLiteral("/SmartDashboard/qml/components/MiddlePane.qml"), &QmlCacheGeneratedCode::_0x5f_SmartDashboard_qml_components_MiddlePane_qml::unit);
    resourcePathToCachedUnit.insert(QStringLiteral("/SmartDashboard/qml/components/RightPane.qml"), &QmlCacheGeneratedCode::_0x5f_SmartDashboard_qml_components_RightPane_qml::unit);
    resourcePathToCachedUnit.insert(QStringLiteral("/SmartDashboard/qml/components/MiddlePaneWidget.qml"), &QmlCacheGeneratedCode::_0x5f_SmartDashboard_qml_components_MiddlePaneWidget_qml::unit);
    resourcePathToCachedUnit.insert(QStringLiteral("/SmartDashboard/qml/components/Switch.qml"), &QmlCacheGeneratedCode::_0x5f_SmartDashboard_qml_components_Switch_qml::unit);
    resourcePathToCachedUnit.insert(QStringLiteral("/SmartDashboard/qml/components/Progressbar.qml"), &QmlCacheGeneratedCode::_0x5f_SmartDashboard_qml_components_Progressbar_qml::unit);
    resourcePathToCachedUnit.insert(QStringLiteral("/SmartDashboard/qml/components/RightPaneLightSwitchComponent.qml"), &QmlCacheGeneratedCode::_0x5f_SmartDashboard_qml_components_RightPaneLightSwitchComponent_qml::unit);
    resourcePathToCachedUnit.insert(QStringLiteral("/SmartDashboard/qml/components/CircularProgressBar.qml"), &QmlCacheGeneratedCode::_0x5f_SmartDashboard_qml_components_CircularProgressBar_qml::unit);
    QQmlPrivate::RegisterQmlUnitCacheHook registration;
    registration.structVersion = 0;
    registration.lookupCachedQmlUnit = &lookupCachedUnit;
    QQmlPrivate::qmlregister(QQmlPrivate::QmlUnitCacheHookRegistration, &registration);
}

Registry::~Registry() {
    QQmlPrivate::qmlunregister(QQmlPrivate::QmlUnitCacheHookRegistration, quintptr(&lookupCachedUnit));
}

const QQmlPrivate::CachedQmlUnit *Registry::lookupCachedUnit(const QUrl &url) {
    if (url.scheme() != QLatin1String("qrc"))
        return nullptr;
    QString resourcePath = QDir::cleanPath(url.path());
    if (resourcePath.isEmpty())
        return nullptr;
    if (!resourcePath.startsWith(QLatin1Char('/')))
        resourcePath.prepend(QLatin1Char('/'));
    return unitRegistry()->resourcePathToCachedUnit.value(resourcePath, nullptr);
}
}
int QT_MANGLE_NAMESPACE(qInitResources_qmlcache_appSmartDashboard)() {
    ::unitRegistry();
    return 1;
}
Q_CONSTRUCTOR_FUNCTION(QT_MANGLE_NAMESPACE(qInitResources_qmlcache_appSmartDashboard))
int QT_MANGLE_NAMESPACE(qCleanupResources_qmlcache_appSmartDashboard)() {
    return 1;
}
