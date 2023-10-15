#include "FileHelper.h"
#include <QDebug>

FileHelper::FileHelper(QObject *parent) : QObject(parent) {}

FileHelper::~FileHelper() {}

qint64 FileHelper::getFileSize(const QString &filePath) {
	QFile file(filePath);
	if (file.exists()) {
		file.open(QIODevice::ReadOnly);
		qint64 size = file.size();
		file.close();
		return size;
	}
	return -1; // Return -1 to indicate file not found
}

bool FileHelper::isImageSizeValid(const QString &filePath, int minWidth, int minHeight, int maxSizeInMB) {
	QFile file(filePath);
	QImage image(filePath);

	if (file.exists()) {

		qint64 fileSize = file.size();

		if (image.isNull()) {
			return false;
		}

		qint64 maxSizeInBytes = maxSizeInMB * 1024 * 1024;

		if ( (image.width() >= minWidth) && (image.height() >= minHeight) && (fileSize <= maxSizeInBytes) ) {
			return true;
		} else {
			qInfo() << filePath << "not valid for uploading." << "Image width:" << image.width() << "image height:" << image.height() << "file size (bytes):" << fileSize;
		}
	}

	return false;
}
