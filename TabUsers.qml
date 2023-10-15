import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Styles 1.4
import QtQuick.Layouts 1.15
import App.Styles 1.0
import UsersModel 1.0

Item {
    id: usersTab
    Layout.fillWidth: true
    Layout.fillHeight: true
    property var windowHandle: undefined
    property bool lastPage: false

    UsersModel {
        id: userModel
    }

    Loader {
        id: usersTabViewLoader
        anchors.fill: parent
        sourceComponent: usersTabComponent

        onLoaded: {
           userModel.getUsers();
        }
    }

    function refresh() {
        userModel.setCurrentPage(0);
        usersTab.lastPage = false;
        userModel.getUsers();
    }

    Component {
        id: usersTabComponent

        ColumnLayout {
            anchors.fill: parent
            anchors.top: parent.top
            visible: true
            spacing: 0

            Text {
                Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                Layout.topMargin: 30
                text: qsTr("Users list")
                font.family: "Inter"
                font.pointSize: Style.textPointSizeCaption
            }

            ListView {
                Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.topMargin: 20
                Layout.leftMargin: 23
                spacing: 20
                interactive: false
                model: userModel

                delegate: Item {
                    width: usersTabComponent.width
                    height: 100

                    Column {
                        spacing: 15

                        Row {
                            spacing: 18

                            Image {
                                id: avatar
                                source: model.photo
                                width: 84
                                height: 84
                                visible: model.photo === "" ? false : true

                                onStatusChanged: {
                                    if (avatar.status === Image.Error) {
                                        avatar.source = "qrc:/Assets/img/DefaultUserImg.svg"
                                    }
                                }
                            }

                            Rectangle {
                                width: 84
                                height: 84
                                radius: 2
                                color: "#D9D9D9"
                                visible: model.photo === "" ? true : false
                            }

                            Column {
                                Text {
                                    Layout.bottomMargin: 20
                                    text: model.name
                                    font.bold: true
                                    font.family: "Inter"
                                    font.pointSize: Style.textPointSizeRegular
                                }
                                Text {
                                    Layout.bottomMargin: 20
                                    text: model.position
                                    font.family: "Inter"
                                    font.pointSize: Style.textPointSizeUserContact
                                }
                                Text {
                                    Layout.bottomMargin: 20
                                    text: model.email
                                    font.family: "Inter"
                                    font.pointSize: Style.textPointSizeUserContact
                                }
                                Text {
                                    text: model.phone
                                    font.family: "Inter"
                                    font.pointSize: Style.textPointSizeUserContact
                                }
                            }
                        }

                        Rectangle {
                            width: 592
                            height: 1
                            color: "#D9D9D9"
                        }

                    }

                }

            }

            Button {
                id: showMoreBtn
                Layout.alignment: Qt.AlignHCenter
                Layout.topMargin: 23
                visible: lastPage ? false : true
                height: 40
                width: 120
                text: qsTr("Show more")

                contentItem: Text {
                    text: showMoreBtn.text
                    color: showMoreBtn.down ? "black" : "white"
                    font.family: "Inter"
                    font.pointSize: 10
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                    elide: Text.ElideRight
                }

                background: Rectangle {
                    radius: Style.fieldBorderRadius
                    implicitHeight: showMoreBtn.height
                    implicitWidth: showMoreBtn.width
                    color: showMoreBtn.down ? "transparent" : "#989898"
                    border.color: showMoreBtn.activeFocus ? Style.elementActiveClr : "#989898"
                    border.width: Style.fieldBorderWidth
                }
                onClicked: {
                    userModel.getUsers();
                    usersTab.lastPage = userModel.isLastPage();
                }
            }

            Item {
                Layout.fillHeight: true
            }

        }

    }

}
