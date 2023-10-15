#ifndef NETWORKMANAGER_H
#define NETWORKMANAGER_H

#include <QObject>
#include <QTimer>
#include <QNetworkAccessManager>
#include <QNetworkRequest>
#include <QHttpPart>
#include "DataStructures.h"

class NetworkManager : public QObject{
	Q_OBJECT

public:
	NetworkManager(QObject *parent = nullptr);
	~NetworkManager();
	static NetworkManager& instance();

public slots:
	void get(const QUrl &url);
	void post(const QUrl &url, const QByteArray &data);
	void postUser(const QUrl &url, QHttpMultiPart *multiPart);
	void getToken();
	void getPositions();
	void getUsers(int page);
	void createUser(const QString name, const QString email, const QString phone, int positionId, const QString photoPath);

signals:
	void getFinished(const QByteArray &data);
	void postFinished(const int responseCode, const QByteArray &data);

	void tokenUpdated(const QString &token);
	void positionsUpdated(const QVector<QString> positions);
	void usersUpdated(const int totalPages, const int page, const QVector<User> users);

	void createUserResponse(const int code, const QString message);

private slots:
	void onGetFinished();
	void onPostFinished();

private:
	QNetworkAccessManager *networkManager;
	QHttpMultiPart *multiPart;
	QString token;
	QTimer tokenRefreshTimer;
};

#endif // NETWORKMANAGER_H
