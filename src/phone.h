#pragma once
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QCommandLineParser>
#include <QProcess>
#include <QTranslator>
#include <QDBusInterface>
#include <QDBusConnection>
#include <QDBusReply>
#include <QDBusMetaType>
#include <singleapplication.h>

class Phone : public SingleApplication {
	Q_OBJECT
public:
	Phone(int &argc, char *argv[]);
public slots:
    void onReceivedMessage( int instanceId, QByteArray message );
private:
	QQmlApplicationEngine engine;
	QTranslator translator;
};