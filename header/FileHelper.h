#ifndef FILEHELPER_H
#define FILEHELPER_H

#include <QObject>
#include <QFile>
#include <QImage>

class FileHelper : public QObject
{
	Q_OBJECT

public:
	FileHelper(QObject *parent = nullptr);
	~FileHelper();

	Q_INVOKABLE qint64 getFileSize(const QString &filePath);
	Q_INVOKABLE bool isImageSizeValid(const QString &filePath, int minWidth, int minHeight, int maxSizeInMB);
};

#endif // FILEHELPER_H
