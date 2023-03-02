cmake_minimum_required(VERSION 3.16)
project(cutie-phone VERSION 1.0 LANGUAGES CXX)

set(CMAKE_INCLUDE_CURRENT_DIR ON)
set(QT_DEFAULT_MAJOR_VERSION 6)
set(QAPPLICATION_CLASS QApplication)

find_package(Qt6 REQUIRED COMPONENTS Core Quick Qml LinguistTools)

qt_standard_project_setup()

add_subdirectory(singleapplication)

set(cutie-phone_SOURCES 
        src/main.cpp
        src/phone.cpp
        src/phone.h
)

qt_add_resources(APP_RESOURCES 
	${CMAKE_SOURCE_DIR}/src/qml/qml.qrc
	${CMAKE_SOURCE_DIR}/icons/icons.qrc)

qt_add_executable(cutie-phone ${cutie-phone_SOURCES} ${APP_RESOURCES})

qt_add_translations(cutie-phone
    TS_FILES ${CMAKE_SOURCE_DIR}/translations/cutie-phone_fi.ts)

target_include_directories(cutie-phone PUBLIC src)

target_link_libraries(cutie-phone PUBLIC Qt::Core Qt::Quick Qt::Qml Qt::DBus SingleApplication)

install(TARGETS cutie-phone RUNTIME DESTINATION "${CMAKE_INSTALL_BINDIR}")
install(FILES cutie-phone.desktop DESTINATION "${CMAKE_INSTALL_DATADIR}/applications")
install(FILES cutie-phone-autostart.desktop DESTINATION "/etc/xdg/autostart/")
install(FILES cutie-phone.svg DESTINATION "${CMAKE_INSTALL_DATADIR}/icons/hicolor/scalable/apps")
