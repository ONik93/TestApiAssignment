import QtQuick 2.15
import QtQuick.Controls
import QtQuick.Layouts 1.15
import QtQuick.Dialogs
import App.Styles 1.0
import UsersModel 1.0
import PositionsModel 1.0

Item {
    id: addUserTab
    Layout.fillWidth: true
    Layout.fillHeight: true
    property var windowHandle: undefined

    PositionsModel {
        id: positionsModel
    }

    UsersModel {
        id: userModel
    }

    Loader {
        id: addUserTabViewLoader
        anchors.fill: parent
        sourceComponent: addUserTabComponent
    }

    function refresh() {
        addUserTabViewLoader.sourceComponent = addUserTabComponent;
        windowHandle.minimumHeight = 929;
        windowHandle.maximumHeight = 929;
        windowHandle.height = 929;
        positionsModel.getPositions();
    }

    Component {
        id: addUserTabComponent

        ColumnLayout {
            id: rootLayout
            anchors.fill: parent
            anchors.top: parent.top
            visible: true
            spacing: 0

            Text {
                Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                Layout.topMargin: 30
                text: qsTr("Add user")
                font.family: "Inter"
                font.pointSize: Style.textPointSizeCaption
            }

            ColumnLayout {
                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignTop
                Layout.topMargin: 35
                Layout.leftMargin: 120
                Layout.rightMargin: 120
                Layout.bottomMargin: 35
                spacing: 0

                Text {
                    Layout.alignment: Qt.AlignLeft
                    Layout.bottomMargin: 12
                    text: qsTr("Name")
                    font.family: "Inter"
                    font.pointSize: Style.textPointSizeRegular
                }
                TextField {
                    id: nameField
                    Layout.fillWidth: true
                    Layout.bottomMargin: nameErrorText.visible ? 1 : 50
                    font.pointSize: Style.textPointSizeRegular
                    font.family: "Inter"
                    maximumLength: 60
                    background: Rectangle {
                        radius: Style.fieldBorderRadius
                        implicitHeight: Style.fieldHeight
                        border.color: nameField.activeFocus ? Style.elementActiveClr : Style.elementDefaultClr
                        border.width: Style.fieldBorderWidth
                    }
                    placeholderText: qsTr("Name")
                }
                Text {
                    id: nameErrorText
                    Layout.alignment: Qt.AlignLeft
                    Layout.bottomMargin: 30
                    visible: false
                    text: qsTr("Username should contain 2-60 characters")
                    font.family: "Inter"
                    color: "red"
                    font.pointSize: 9
                }

                Text {
                    Layout.alignment: Qt.AlignLeft
                    Layout.bottomMargin: 12
                    text: qsTr("Email")
                    font.family: "Inter"
                    font.pointSize: Style.textPointSizeRegular
                }
                TextField {
                    id: emailField
                    Layout.fillWidth: true
                    Layout.bottomMargin: emailErrorText.visible ? 1 : 50
                    font.pointSize: Style.textPointSizeRegular
                    font.family: "Inter"
                    maximumLength: 100
                    background: Rectangle {
                        radius: Style.fieldBorderRadius
                        implicitHeight: Style.fieldHeight
                        border.color: emailField.activeFocus ? Style.elementActiveClr : Style.elementDefaultClr
                        border.width: Style.fieldBorderWidth
                    }
					validator: RegularExpressionValidator { regularExpression:/^(?:[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*|"(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21\x23-\x5b\x5d-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])*")@(?:(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?|\[(?:(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?)\.){3}(?:25[0-5]|2[0-4][0-9]|[01]?[0-9][0-9]?|[a-z0-9-]*[a-z0-9]:(?:[\x01-\x08\x0b\x0c\x0e-\x1f\x21-\x5a\x53-\x7f]|\\[\x01-\x09\x0b\x0c\x0e-\x7f])+)\])$/ }

					placeholderText: qsTr("Email")
                }
                Text {
                    id: emailErrorText
                    Layout.alignment: Qt.AlignLeft
                    Layout.bottomMargin: 30
                    visible: false
                    text: qsTr("Please enter valid email")
                    font.family: "Inter"
                    color: "red"
                    font.pointSize: 9
                }

                Text {
                    Layout.alignment: Qt.AlignLeft
                    Layout.bottomMargin: 12
                    text: qsTr("Phone")
                    font.family: "Inter"
                    font.pointSize: Style.textPointSizeRegular
                }
                TextField {
                    id: phoneField
                    Layout.fillWidth: true
                    Layout.bottomMargin: 11
                    font.pointSize: Style.textPointSizeRegular
                    font.family: "Inter"
                    background: Rectangle {
                        radius: Style.fieldBorderRadius
                        implicitHeight: Style.fieldHeight
                        border.color: phoneField.activeFocus ? Style.elementActiveClr : Style.elementDefaultClr
                        border.width: Style.fieldBorderWidth
                    }
					validator: RegularExpressionValidator { regularExpression:/^[\+]{0,1}380([0-9]{9})$/ }
                    placeholderText: qsTr("Phone")
                }
                Text {
                    id: phoneTipText
                    Layout.alignment: Qt.AlignLeft
                    Layout.bottomMargin: 32
                    text: "+38 (XXX) XXX - XX - XX"
                    font.family: "Inter"
                    font.pointSize: 9
                    color: "#6B6B6B"
                }

                Repeater {
                    id: radioBtnRepeater
                    model: positionsModel
                    delegate: RadioButton {
                        id: control
                        text: model.role
                        font.family: "Inter"
                        font.pointSize: Style.textPointSizeRegular
                        checked: index === 0
                        property int positionId : model.id

                        indicator: Rectangle {
                            implicitWidth: 18
                            implicitHeight: 18
                            x: control.leftPadding
                            y: parent.height / 2 - height / 2
                            radius: 9
                            border.color: (control.activeFocus && control.focusReason === Qt.TabFocusReason) ? Style.elementActiveClr : "#989898"
                            border.width: 2
                            Rectangle {
                                width: 10
                                height: 10
                                x: 4
                                y: 4
                                radius: 5
                                color: "#989898"
                                visible: control.checked
                            }
                        }
                        contentItem: Text {
                            text: control.text
                            font: control.font
                            opacity: enabled ? 1.0 : 0.3
                            verticalAlignment: Text.AlignVCenter
                            leftPadding: control.indicator.width + 17
                        }

                        Keys.onPressed: {
                            if (event.key === Qt.Key_Return) {
                                control.checked = true;
                            }
                        }
                    }

                    function getPositionId() {
                        for (var i = 0; i < radioBtnRepeater.count; i++) {
                            var radioButton = radioBtnRepeater.itemAt(i);
                            if (radioButton.checked) {
                                return radioButton.positionId;
                            }
                        }
                        return -1; // Return an empty string if no radio button is checked
                    }
                }

                Text {
                    Layout.alignment: Qt.AlignLeft
                    Layout.topMargin: 30
                    Layout.bottomMargin: 12
                    text: qsTr("Photo")
                    font.family: "Inter"
                    font.pointSize: Style.textPointSizeRegular
                }
                OpenFileDialog {
                    id: fileDlg
                    Layout.bottomMargin: fileDlgErrorText.visible ? 1 : 45
                }
                Text {
                    id: fileDlgErrorText
                    Layout.alignment: Qt.AlignLeft
                    Layout.bottomMargin: 30
                    visible: false
                    text: qsTr("The photo size must not be greater than 5 Mb")
                    font.family: "Inter"
                    color: "red"
                    font.pointSize: 9
                }

                Button {
                    id: addUserBtn
                    Layout.alignment: Qt.AlignHCenter
                    height: 40
                    width: 120
                    text: qsTr("Add user")

                    contentItem: Text {
                        text: addUserBtn.text
                        color: addUserBtn.down ? "black" : "white"
                        font.family: "Inter"
                        font.pointSize: 10
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        elide: Text.ElideRight
                    }

                    background: Rectangle {
                        radius: Style.fieldBorderRadius
                        implicitHeight: addUserBtn.height
                        implicitWidth: addUserBtn.width
                        color: addUserBtn.down ? "transparent" : "#989898"
                        border.color: addUserBtn.activeFocus ? Style.elementActiveClr : "#989898"
                        border.width: Style.fieldBorderWidth
                    }
                    onClicked: {
                        if ( rootLayout.checkValidInput() === true ) {
                            console.log("Try to create user: ", nameField.text, emailField.text, phoneField.text, radioBtnRepeater.getPositionId(), fileDlg.url)
                            userModel.createUser(nameField.text, emailField.text, phoneField.text, radioBtnRepeater.getPositionId(), fileDlg.url)
                        }
                    }

                    MessageDialog {
                        id: messageDialog
                    }
                }

            }

            Item {
                Layout.fillHeight: true
            }

            function checkValidInput() {
                var ret = false;
                if (nameField.length < 2) {
                    nameErrorText.visible = true;
                    ret = false;
                } else {
                    nameErrorText.visible = false;
                    ret = true;
                }

                if ( !emailField.acceptableInput ) {
                    emailErrorText.visible = true;
                    ret = false;
                } else {
                    emailErrorText.visible = false;
                    ret = true;
                }

                if ( !phoneField.acceptableInput ) {
                    phoneTipText.color = "red";
                    ret = false;
                } else {
                    phoneTipText.color = "#6B6B6B";
                    ret = true;
                }

                if ( fileDlg.url == "" ) {
                    fileDlgErrorText.visible = true;
                    ret = false;
                } else {
                    fileDlgErrorText.visible = false;
                    ret = true;
                }

                return ret;
            }

            Connections {
                target: userModel
                function onCreateUserResponse(code, message) {
                    if (code === 201) {
                        addUserTabViewLoader.sourceComponent = userAddSuccessTabComponent;
                        windowHandle.minimumHeight = 540
                        windowHandle.maximumHeight = 540
                        windowHandle.height = 540
                    } else {
                        messageDialog.title = "HTTP error code " + code;
                        messageDialog.text = message;
                        messageDialog.visible = true;
                    }
                }
            }

        }

    }

    Component {
        id: userAddSuccessTabComponent

        ColumnLayout {
            anchors.fill: parent
            anchors.top: parent.top
            visible: true
            spacing: 0

            Image {
                Layout.alignment: Qt.AlignHCenter
                Layout.topMargin: 100
                source: "qrc:/Assets/img/Success.svg"
            }

            Text {
                Layout.alignment: Qt.AlignHCenter | Qt.AlignTop
                Layout.topMargin: 30
                text: qsTr("New user successfully added")
                font.family: "Inter"
                font.pointSize: Style.textPointSizeCaption
            }

            RowLayout {
                Layout.fillHeight: true
                Layout.fillWidth: true
                Layout.alignment: Qt.AlignHCenter
                Layout.topMargin: 40
                spacing: 16

                Button {
                    id: userListBtn
                    Layout.alignment: Qt.AlignHCenter
                    height: 40
                    width: 120
                    text: qsTr("Users list")

                    contentItem: Text {
                        text: userListBtn.text
                        color: userListBtn.down ? "white" : "black"
                        font.family: "Inter"
                        font.pointSize: 10
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        elide: Text.ElideRight
                    }

                    background: Rectangle {
                        radius: Style.fieldBorderRadius
                        implicitHeight: userListBtn.height
                        implicitWidth: userListBtn.width
                        color: userListBtn.down ? "#989898" : "transparent"
                        border.color: userListBtn.activeFocus ? Style.elementActiveClr : "#989898"
                        border.width: Style.fieldBorderWidth
                    }
                    onClicked:{
                        addUserTab.refresh();
                        addUserTab.windowHandle.barHandle.setCurrentIndex(0);
                    }
                }

                Button {
                    id: addOneMoreBtn
                    Layout.alignment: Qt.AlignHCenter
                    height: 40
                    width: 120
                    text: qsTr("Add one more")

                    contentItem: Text {
                        text: addOneMoreBtn.text
                        color: addOneMoreBtn.down ? "black" : "white"
                        font.family: "Inter"
                        font.pointSize: 10
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        elide: Text.ElideRight
                    }

                    background: Rectangle {
                        radius: Style.fieldBorderRadius
                        implicitHeight: addOneMoreBtn.height
                        implicitWidth: addOneMoreBtn.width
                        color: addOneMoreBtn.down ? "transparent" : "#989898"
                        border.color: addOneMoreBtn.activeFocus ? Style.elementActiveClr : "#989898"
                        border.width: Style.fieldBorderWidth
                    }
                    onClicked: addUserTab.refresh();
                }

            }

            Item {
                Layout.fillHeight: true
            }

        }

    }
}
