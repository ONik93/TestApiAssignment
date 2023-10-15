#ifndef USERSMODEL_H
#define USERSMODEL_H

#include <QAbstractListModel>
#include <QVector>
#include "NetworkManager.h"
#include "DataStructures.h"

class UsersModel : public QAbstractListModel {
	Q_OBJECT

public:
	enum UserRoles {
		NameRole = Qt::UserRole + 1,
		EmailRole,
		PhoneRole,
		PositionRole,
		PhotoRole,
	};

	UsersModel(QObject* parent = nullptr);

	int rowCount(const QModelIndex& parent = QModelIndex()) const override;
	QVariant data(const QModelIndex& index, int role = Qt::DisplayRole) const override;
	QHash<int, QByteArray> roleNames() const override;

	Q_INVOKABLE void setCurrentPage( int page );
	Q_INVOKABLE void getUsers();
	Q_INVOKABLE void createUser(const QString name, const QString email, const QString phone, int positionId, const QString photoPath);
	Q_INVOKABLE bool isLastPage();
	void clearUsersList();

signals:
	void getUsersPage( const int page );
	void createUserResponse(const int code, const QString message);

public slots:
	void buildUsersPage(const int totalPages, const int page, const QVector<User> users);
	void createUserResponseSlot(const int code, const QString message);

private:
	QVector<User> m_users;
	int m_page;
	int m_totalPages;
	NetworkManager* networkManager;
};

#endif // USERSMODEL_H
