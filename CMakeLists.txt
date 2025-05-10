cmake_minimum_required(VERSION 3.16)

project(SmartDashboard VERSION 0.1 LANGUAGES CXX)

set(CMAKE_CXX_STANDARD_REQUIRED ON)

find_package(Qt6 6.4 REQUIRED COMPONENTS Quick QuickControls2)

qt_standard_project_setup()

qt_add_executable(appSmartDashboard
    cpp/main.cpp
)

qt_add_qml_module(appSmartDashboard
    URI SmartDashboard
    VERSION 1.0
    RESOURCES
        assets/fonts/CodecPro-Italic.ttf
        assets/fonts/CodecPro-Regular.ttf
        assets/fonts/fontawesome.otf
    QML_FILES
        qml/Main.qml
        qml/pane/LeftPane.qml

        qml/pane/HomePane.qml
        qml/components/IconLabel.qml
        qml/components/Switch.qml
        qml/components/Progressbar.qml
        qml/components/LightSwitch.qml
        qml/components/CircularProgressBar.qml
        SOURCES cpp/backend.h
        SOURCES cpp/backend.cpp
        QML_FILES qml/pane/ClimatePane.qml qml/pane/EnergyPane.qml qml/pane/MusicPane.qml
)

# Qt for iOS sets MACOSX_BUNDLE_GUI_IDENTIFIER automatically since Qt 6.1.
# If you are developing for iOS or macOS you should consider setting an
# explicit, fixed bundle identifier manually though.
set_target_properties(appSmartDashboard PROPERTIES
#    MACOSX_BUNDLE_GUI_IDENTIFIER com.example.appSmartDashboard
    MACOSX_BUNDLE_BUNDLE_VERSION ${PROJECT_VERSION}
    MACOSX_BUNDLE_SHORT_VERSION_STRING ${PROJECT_VERSION_MAJOR}.${PROJECT_VERSION_MINOR}
    MACOSX_BUNDLE TRUE
    WIN32_EXECUTABLE TRUE
)

target_link_libraries(appSmartDashboard
    PRIVATE Qt6::Quick Qt6::QuickControls2
)

include(GNUInstallDirs)
install(TARGETS appSmartDashboard
    BUNDLE DESTINATION .
    LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
    RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
