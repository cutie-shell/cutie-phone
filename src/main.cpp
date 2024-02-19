#include <QQmlApplicationEngine>
#include <QQmlContext>
#include <QtGui/QGuiApplication>
#include <QtQml/QQmlContext>
#include <QtQml/QQmlEngine>
#include <QtQuick/QQuickItem>
#include <QtQuick/QQuickView>
#include <QCommandLineParser>
#include <QTranslator>

int main(int argc, char *argv[])
{
	QGuiApplication app(argc, argv);
	QGuiApplication::setApplicationName("cutie-phone");

	QCommandLineParser parser;
	parser.setApplicationDescription("The Phone app for Cutie UI");
	parser.addHelpOption();
	parser.addPositionalArgument(
		"number", QCoreApplication::translate(
				  "main", "A phone number to predial."));
	parser.process(app);
	QStringList positionals = parser.positionalArguments();
	QString phoneNumber;
	if (!positionals.empty())
		phoneNumber = positionals[0];

	QString locale = QLocale::system().name();
	QTranslator translator;
	bool translated =
		translator.load(QString(":/i18n/cutie-phone_") + locale);
	if (translated)
		app.installTranslator(&translator);

	QQmlApplicationEngine engine;
	const QUrl url(QStringLiteral("qrc:/main.qml"));
	QObject::connect(
		&engine, &QQmlApplicationEngine::objectCreated, &app,
		[url](QObject *obj, const QUrl &objUrl) {
			if (!obj && url == objUrl)
				QCoreApplication::exit(-1);
		},
		Qt::QueuedConnection);
	engine.load(url);

	if (!phoneNumber.isEmpty())
		QMetaObject::invokeMethod(engine.rootObjects()[0], "predial",
					  Q_ARG(QVariant, phoneNumber));

	return app.exec();
}