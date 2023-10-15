import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15
import QtQuick.Dialogs 1.0
import App.Styles 1.0
import FileHelper 1.0

RowLayout {
    id: root
    Layout.fillWidth: true
    property string url: ""
    spacing: 0

    FileHelper {
        id: fileHelper
    }

    TextField {
        id: fileUrlField
        Layout.fillWidth: true
        height: Style.fieldHeight
        font.pointSize: Style.textPointSizeRegular
        font.family: "Inter"
        readOnly: true
        background: Rectangle {
            radius: Style.fieldBorderRadius
            implicitHeight: fileUrlField.height
            border.color: fileUrlField.activeFocus ? Style.elementActiveClr : Style.elementDefaultClr
            border.width: Style.fieldBorderWidth
        }
        placeholderText: qsTr("Upload photo")

        FileDialog {
            id: fileDialog
            title: "Please choose a file"
            folder: shortcuts.home
            nameFilters: ["Image files (*.jpg *.jpeg)"]
            onAccepted: {
                var selectedFileUrl = fileDialog.fileUrls[0].substring(8);
                var valid = fileHelper.isImageSizeValid(selectedFileUrl, 70, 70, 5);

                if (valid === true) {
                    fileUrlField.text = selectedFileUrl;
                    root.url = selectedFileUrl;
                }

//                var file = Qt.input(fileDialog.fileUrls);
//                var fileSizeMB =  file.size / (1024 * 1024);
//                console.log(fileSizeMB);
//                if ( fileSizeMB <= 5 ) {
//                    console.log( "You chose: " + selectedFileUrl );
//                    var uri = fileDialog.fileUrls[0];
//                    fileUrlField.text = uri.substring(8);
//                    root.url = fileUrlField.text;
//                } else {
//                    console.log( "File " + fileDialog.fileUrls + " greater than 5Mb" );
//                }
            }


        }




    }

    Button {
        id: fileUrlButton
        height: fileUrlField.height
        implicitWidth: 86
        text: qsTr("Upload")

        contentItem: Text {
            text: fileUrlButton.text
            color: fileUrlButton.down ? "white" : "black"
            font.family: "Inter"
            font.pointSize: Style.textPointSizeRegular
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            elide: Text.ElideRight
        }

        background: Rectangle {
            radius: Style.fieldBorderRadius
            implicitHeight: fileUrlField.height
            implicitWidth: fileUrlField.width
            color: fileUrlButton.down ? "#989898" : "transparent"
            border.color: fileUrlField.activeFocus ? Style.elementActiveClr : "#989898"
            border.width: Style.fieldBorderWidth
        }
        onClicked: fileDialog.open()
    }

    Keys.onPressed: {
        if (event.key === Qt.Key_Return) {
            fileUrlButton.clicked();
        }
    }

}
