QT += quick quickcontrols2 websockets network qml core gui

# You can make your code fail to compile if it uses deprecated APIs.
# Uncomment the next line to disable deprecated APIs before Qt 6.0.0
# DEFINES += QT_DISABLE_DEPRECATED_BEFORE=0x060000

# For Raspberry Pi optimization
CONFIG += c++11 qtquickcompiler

TARGET = SmartDashboard
TEMPLATE = app

# Source files
SOURCES += \
    cpp/main.cpp \
    cpp/backend.cpp

# Header files
HEADERS += \
    cpp/backend.h

# Resources
RESOURCES += qml.qrc
QTQUICK_COMPILER_SKIPPED_RESOURCES += qml.qrc

# Default rules for deployment
qnx: target.path = /tmp/$${TARGET}/bin
else: unix:!android: target.path = /opt/$${TARGET}/bin
!isEmpty(target.path): INSTALLS += target

# Raspberry Pi specific configurations
linux-rasp-pi* {
    message("Configuring for Raspberry Pi")
    
    # Enable OpenGL ES 2.0
    DEFINES += USE_OPENGLES
    QT += gui-private
    
    # OpenGL ES 2.0 dependencies for Raspberry Pi
    LIBS += -lGLESv2 -lEGL
    
    # For best performance on Raspberry Pi
    QMAKE_CXXFLAGS += -march=armv7-a -mfpu=neon-vfpv4 -mfloat-abi=hard
}

# Additional optimization for release mode
CONFIG(release, debug|release) {
    DEFINES += QT_NO_DEBUG_OUTPUT
    QMAKE_CXXFLAGS_RELEASE -= -O2
    QMAKE_CXXFLAGS_RELEASE += -O3
}
