#include "PositionsModel.h"

PositionsModel::PositionsModel(QObject* parent) : QAbstractListModel(parent) {
	this->networkManager = &NetworkManager::instance();
	connect(this->networkManager, &NetworkManager::positionsUpdated, this, &PositionsModel::setPositions, Qt::QueuedConnection);
	connect(this, &PositionsModel::getPositions, this->networkManager, &NetworkManager::getPositions, Qt::QueuedConnection);
}

int PositionsModel::rowCount(const QModelIndex& parent) const {
	if (parent.isValid())
		return 0;

	return m_positions.size();
}

QVariant PositionsModel::data(const QModelIndex& index, int role) const {
	if (!index.isValid())
		return QVariant();

	if (role == RoleRole) {
		return m_positions.at(index.row());
	} else if (role == IdRole)  {
		return index.row() + 1;
	}

	return QVariant();
}

QHash<int, QByteArray> PositionsModel::roleNames() const {
	QHash<int, QByteArray> roles;
	roles[IdRole] = "id";
	roles[RoleRole] = "role";
	return roles;
}

void PositionsModel::setPositions(const QVector<QString> positions) {
	this->m_positions.clear();
	beginResetModel();
	this->m_positions.append(positions);
	endResetModel();
}
