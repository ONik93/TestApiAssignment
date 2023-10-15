#include "UsersModel.h"

UsersModel::UsersModel(QObject* parent) : QAbstractListModel(parent) {
	this->m_users = {};
	this->m_page = 0;
	this->m_totalPages = -1;
	this->networkManager = &NetworkManager::instance();
	connect(this->networkManager, &NetworkManager::usersUpdated, this, &UsersModel::buildUsersPage, Qt::DirectConnection);
	connect(this, &UsersModel::getUsersPage, this->networkManager, &NetworkManager::getUsers, Qt::DirectConnection);
	connect(this->networkManager, &NetworkManager::createUserResponse, this, &UsersModel::createUserResponseSlot, Qt::DirectConnection);
}

int UsersModel::rowCount(const QModelIndex& parent) const {
	if (parent.isValid())
		return 0;

	return m_users.size();
}

QVariant UsersModel::data(const QModelIndex& index, int role) const {
	if (!index.isValid())
		return QVariant();

	const User& user = m_users.at(index.row());

	switch (role) {
	case NameRole:
		return user.name;
	case EmailRole:
		return user.email;
	case PhoneRole:
		return user.phone;
	case PositionRole:
		return user.position;
	case PhotoRole:
		return user.photo;
	default:
		return QVariant();
	}
}

QHash<int, QByteArray> UsersModel::roleNames() const {
	QHash<int, QByteArray> roles;
	roles[NameRole] = "name";
	roles[EmailRole] = "email";
	roles[PhoneRole] = "phone";
	roles[PositionRole] = "position";
	roles[PhotoRole] = "photo";
	return roles;
}

void UsersModel::setCurrentPage( int page ) {
	this->m_page = page;
}

void UsersModel::getUsers() {
	++( this->m_page );
	emit this->getUsersPage( this->m_page );
}

void UsersModel::createUser(const QString name, const QString email, const QString phone, int positionId, const QString photoPath) {
	this->networkManager->createUser(name, email, phone, positionId, photoPath);
}

bool UsersModel::isLastPage() {
	if (this->m_page == this->m_totalPages) {
		return true;
	}
	return false;
}

void UsersModel::buildUsersPage(const int totalPages, const int page, const QVector<User> users) {
	clearUsersList();

	beginResetModel();
	this->m_totalPages = totalPages;
	this->m_page = page;
	this->m_users.append(users);
	endResetModel();
}

void UsersModel::createUserResponseSlot(const int code, const QString message) {
	qDebug() << "createUserResponseSlot" << code << message;
	emit createUserResponse(code, message);
}

void UsersModel::clearUsersList() {
	beginResetModel();
	this->m_users.clear();
	endResetModel();
}
