#ifndef POSITIONSMODEL_H
#define POSITIONSMODEL_H

#include <QAbstractListModel>
#include <QVector>
#include "NetworkManager.h"

class PositionsModel : public QAbstractListModel {
	Q_OBJECT

public:
	enum PositionRoles {
		IdRole = Qt::UserRole + 1,
		RoleRole,
	};

	PositionsModel(QObject* parent = nullptr);

	int rowCount(const QModelIndex& parent = QModelIndex()) const override;
	QVariant data(const QModelIndex& index, int role = Qt::DisplayRole) const override;
	QHash<int, QByteArray> roleNames() const override;

	void setPositions(const QVector<QString> positions);

signals:
	void getPositions();

private:
	QVector<QString> m_positions;
	NetworkManager* networkManager;
};

#endif // POSITIONSMODEL_H
