#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>
#include "NetworkManager.h"
#include "UsersModel.h"
#include "PositionsModel.h"
#include "FileHelper.h"

#ifdef Q_OS_ANDROID
    #include <QJniObject>
#endif

class CustomApplication : public QGuiApplication {
public:
	CustomApplication(int &argc, char **argv) : QGuiApplication(argc, argv) {}

	bool notify(QObject *receiver, QEvent *event) override {
		try {
			return QGuiApplication::notify(receiver, event);
		} catch (const std::exception &e) {
			qWarning() << "Exception caught: " << e.what();
			return false;
		}
	}
};
int main(int argc, char *argv[]) {

#if QT_VERSION < QT_VERSION_CHECK(6, 0, 0)
	QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);
#endif

	CustomApplication app(argc, argv);
	app.setOrganizationName("abz.agency");
	app.setOrganizationDomain("www.abz.agency");
	app.setApplicationName("TestApiAssignment");

	QQmlApplicationEngine engine;

	qmlRegisterSingletonType(QUrl("qrc:/Styles/Default.qml"), "App.Styles", 1, 0, "Style");
	qmlRegisterType<FileHelper>("FileHelper", 1, 0, "FileHelper");
	qmlRegisterType<UsersModel>("UsersModel", 1, 0, "UsersModel");
	qmlRegisterType<PositionsModel>("PositionsModel", 1, 0, "PositionsModel");

	const QUrl url(QStringLiteral("qrc:/main.qml"));

	QObject::connect(&engine, &QQmlApplicationEngine::objectCreated,
					 &app, [url](QObject *obj, const QUrl &objUrl) {
		if (!obj && url == objUrl)
			QCoreApplication::exit(-1);
	}, Qt::QueuedConnection);

	engine.load(url);

#ifdef Q_OS_ANDROID
    QNativeInterface::QAndroidApplication::runOnAndroidMainThread([]() {
        QJniObject activity = QNativeInterface::QAndroidApplication::context();
        // Hide system ui elements or go full screen
        QJniObject jni_window = activity.callObjectMethod("getWindow", "()Landroid/view/Window;");
        jni_window.callMethod<void>("addFlags", "(I)V", 0x80000000);              // FLAG_DRAWS_SYSTEM_BAR_BACKGROUNDS
        jni_window.callMethod<void>("clearFlags", "(I)V", 0x04000000);            // FLAG_TRANSLUCENT_STATUS
        jni_window.callMethod<void>("setStatusBarColor", "(I)V", 0xff0d1a25);     // Desired statusbar color ARGB
        jni_window.callMethod<void>("setNavigationBarColor", "(I)V", 0xff0d1a25); // Desired navigationbar color ARGB
    }).waitForFinished();
#endif

	return app.exec();
}
