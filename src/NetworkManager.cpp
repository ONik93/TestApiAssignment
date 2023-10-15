#include <QNetworkReply>
#include <QJsonDocument>
#include <QJsonObject>
#include <QJsonArray>
#include <QFile>
#include <QFileInfo>
#include <QMutex>
#include "NetworkManager.h"
#include "NetworkDefines.h"
#include "UsersModel.h"

NetworkManager::NetworkManager(QObject *parent) : QObject(parent){
	this->networkManager = new QNetworkAccessManager(this);
	this->token = "";

	// Configure the token refresh timer
	this->tokenRefreshTimer.setInterval(35 * 60 * 1000); // 35 minutes in milliseconds
	connect(&tokenRefreshTimer, &QTimer::timeout, this, &NetworkManager::getToken);
	tokenRefreshTimer.start();

	getToken();
}

NetworkManager::~NetworkManager() {
	delete this->networkManager;
}

NetworkManager &NetworkManager::instance() {
	static NetworkManager instance;
	return instance;
}

void NetworkManager::get(const QUrl &url) {
	QNetworkRequest request(url);
	QNetworkReply *reply = networkManager->get(request);
	connect(reply, &QNetworkReply::readyRead, this, &NetworkManager::onGetFinished, Qt::QueuedConnection);
}

void NetworkManager::post(const QUrl &url, const QByteArray &data) {
	QNetworkRequest request(url);
	request.setHeader(QNetworkRequest::ContentTypeHeader, "application/json");
	QNetworkReply *reply = networkManager->post(request, data);
	connect(reply, &QNetworkReply::readyRead, this, &NetworkManager::onPostFinished, Qt::QueuedConnection);
}

void NetworkManager::postUser(const QUrl &url, QHttpMultiPart *multiPart) {
	QNetworkRequest request(url);
	request.setRawHeader("Token", this->token.toUtf8());
	QNetworkReply *reply = this->networkManager->post(request, multiPart);
	connect(reply, &QNetworkReply::readyRead, this, &NetworkManager::onPostFinished, Qt::QueuedConnection);
	qDebug() << "2";
}

void NetworkManager::onGetFinished() {
	QNetworkReply *reply = qobject_cast<QNetworkReply *>(sender());
	if (reply && reply->error() == QNetworkReply::NoError) {
		auto answer = reply->readAll();
		emit getFinished(answer);
		//qDebug() << "NetworkManager::onGetFinished() Got response " << QString::fromUtf8(answer);
	}
	reply->deleteLater();
}

void NetworkManager::onPostFinished() {
	qDebug() << "q";
	QNetworkReply *reply = qobject_cast<QNetworkReply *>(sender());
	if (reply) {
		auto answer = reply->readAll();
		int responseCode = reply->attribute(QNetworkRequest::HttpStatusCodeAttribute).toInt();
		emit postFinished(responseCode, answer);
		qDebug() << "NetworkManager::onPostFinished() Got response code" << responseCode;
	} else {
		qDebug() << "An issue occurred. Reply is null.";

	}
	reply->deleteLater();
}

void NetworkManager::createUser(const QString name, const QString email, const QString phone, int positionId, const QString photoPath) {
	QMutex mutex;

	this->multiPart = new QHttpMultiPart(QHttpMultiPart::FormDataType);
	QHttpPart namePart;
	namePart.setHeader(QNetworkRequest::ContentDispositionHeader, QVariant("form-data; name=\"name\""));
	namePart.setBody(name.toUtf8());

	QHttpPart emailPart;
	emailPart.setHeader(QNetworkRequest::ContentDispositionHeader, QVariant("form-data; name=\"email\""));
	emailPart.setBody(email.toUtf8());

	QHttpPart phonePart;
	phonePart.setHeader(QNetworkRequest::ContentDispositionHeader, QVariant("form-data; name=\"phone\""));
	phonePart.setBody(phone.toUtf8());

	QHttpPart positionIdPart;
	positionIdPart.setHeader(QNetworkRequest::ContentDispositionHeader, QVariant("form-data; name=\"position_id\""));
	positionIdPart.setBody(QString::number(positionId).toUtf8());

	QHttpPart photoPart;
	photoPart.setHeader(QNetworkRequest::ContentDispositionHeader, QVariant("form-data; name=\"photo\"; filename=\"" + QFileInfo(photoPath).fileName() + "\""));
	photoPart.setHeader(QNetworkRequest::ContentTypeHeader, QVariant("image/jpeg"));

	QFile* photoFile = new QFile(photoPath);
	if (photoFile->open(QIODevice::ReadOnly)) {
		photoPart.setBodyDevice(photoFile);
		photoFile->setParent(multiPart);
	} else {
		qDebug() << "Failed to open photo file.";
		multiPart->deleteLater();
		delete photoFile;
		return;
	}

	multiPart->append(positionIdPart);
	multiPart->append(namePart);
	multiPart->append(emailPart);
	multiPart->append(phonePart);
	multiPart->append(photoPart);

	QUrl url(API_POST_USER_URI);
	this->postUser(url, multiPart);

	mutex.lock();
	connect(this, &NetworkManager::postFinished, this, [&](const int responseCode, const QByteArray& data) {
		qDebug() << "z";
		if (responseCode == 200) {
			QString response = QString::fromUtf8(data);
			QJsonDocument jsonResponse = QJsonDocument::fromJson(response.toUtf8());
			if (!jsonResponse.isNull() && jsonResponse.isObject()) {
				QJsonObject jsonObject = jsonResponse.object();
				if (jsonObject.contains("user_id")) {
					int userId = jsonObject["user_id"].toInt();
					qDebug() << "User created with ID: " << userId;
					emit createUserResponse(responseCode, "New user created");
				} else {
					qDebug() << "Failed to create user.";
				}
			} else {
				qDebug() << "Failed to parse JSON response.";
			}
		} else {
			QString response = QString::fromUtf8(data);
			QJsonDocument jsonResponse = QJsonDocument::fromJson(response.toUtf8());
			if (!jsonResponse.isNull() && jsonResponse.isObject()) {
				QJsonObject jsonObject = jsonResponse.object();
				if (jsonObject.contains("message")) {
					QString message = jsonObject["message"].toString();
					qDebug() << "HTTP" << responseCode << "Error: " << message;
					emit createUserResponse(responseCode, message);
				} else {
					qDebug() << "Failed to parse" << responseCode << "JSON response.";
				}
			} else {
				qDebug() << "Failed to parse" << responseCode << "JSON response.";
			}
		}

		multiPart->deleteLater();

	});

	mutex.unlock();
}


void NetworkManager::getToken() {
	QMutex mutex;

	this->get(QUrl(API_TOKEN_URI));
	mutex.lock();
	connect(this, &NetworkManager::getFinished, this, [&](const QByteArray &data) {
		QString response = QString::fromUtf8(data);
		QJsonDocument jsonResponse = QJsonDocument::fromJson(response.toUtf8());
		if (!jsonResponse.isNull() && jsonResponse.isObject()) {
			QJsonObject jsonObject = jsonResponse.object();
			if (jsonObject.contains("token")) {
				this->token = jsonObject["token"].toString();
				emit tokenUpdated(this->token);
			}
		} else {
			qDebug() << "Failed to parse JSON response.";
		}
	});
	mutex.unlock();
}

void NetworkManager::getPositions() {
	QMutex mutex;

	this->get(QUrl(API_GET_POSITIONS_URI));
	mutex.lock();
	connect(this, &NetworkManager::getFinished, this, [&](const QByteArray &data) {
		QVector<QString> positions = {};
		QString response = QString::fromUtf8(data);
		QJsonDocument jsonResponse = QJsonDocument::fromJson(response.toUtf8());
		if (!jsonResponse.isNull() && jsonResponse.isObject()) {
			QJsonObject jsonObject = jsonResponse.object();
			if (jsonObject.contains("positions") && jsonObject["positions"].isArray()) {
				QJsonArray positionsArray = jsonObject["positions"].toArray();
				for (const QJsonValue& positionValue : positionsArray) {
					if (positionValue.isObject()) {
						QJsonObject positionObject = positionValue.toObject();
						QString name = positionObject["name"].toString();
						positions.append(name);
					}
				}
				emit positionsUpdated(positions);
			}
		} else {
			qDebug() << "Failed to parse JSON response.";
		}
	});
	mutex.unlock();
}

void NetworkManager::getUsers(int page) {
	QMutex mutex;

	QString formattedUrl = QString(API_GET_USERS_URI).arg(page).arg(6);
	this->get(QUrl(formattedUrl));
	mutex.lock();
	connect(this, &NetworkManager::getFinished, this, [&](const QByteArray &data) {
		QVector<User> Users = {};
		QString response = QString::fromUtf8(data);
		QJsonDocument jsonResponse = QJsonDocument::fromJson(response.toUtf8());
		if (!jsonResponse.isNull() && jsonResponse.isObject()) {
			QJsonObject jsonObject = jsonResponse.object();
			if (jsonObject.contains("total_pages")) {
				int totalPages = jsonObject["total_pages"].toInt();
				int page = jsonObject["page"].toInt();
				QJsonArray usersArray = jsonObject["users"].toArray();
				for (const QJsonValue& userValue : usersArray) {
					if (userValue.isObject()) {
						QJsonObject userObject = userValue.toObject();
						User user;
						user.name = userObject["name"].toString();
						user.email = userObject["email"].toString();
						user.phone = userObject["phone"].toString();
						user.position = userObject["position"].toString();
						user.photo = userObject["photo"].toString();
						Users.append(user);
					}
				}
				emit usersUpdated(totalPages, page, Users);
			}
		} else {
			qDebug() << "Failed to parse JSON response.";
		}
	});
	mutex.unlock();
}
