import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts 1.15

ApplicationWindow {
    id: window
    visible: true
    width: 640
    height: 929
    minimumWidth: 640
    maximumWidth: 640
    minimumHeight: 929
    maximumHeight: 929
    property var barHandle: bar

    StackLayout {
        id: mainStackLayout
        anchors.fill: parent
        currentIndex: bar.currentIndex

        TabUsers {
            id: usersTab
        }
        TabAddUser {
            id: addUserTab
            windowHandle: window
        }

        onCurrentIndexChanged: {
            addUserTab.refresh();
            if (mainStackLayout.currentIndex == 0) {
                usersTab.refresh();
            }
        }
    }

    header: TabBar {
        id: bar
        Layout.fillWidth: true
        contentHeight: 54

        TabButton {
            id: usersBtn
            text: qsTr("Users")

            contentItem: Text {
                text: usersBtn.text
                color: "black"
                font.family: "Inter"
                font.pointSize: 14
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
            }
            background: Rectangle {
                color: usersBtn.checked ? "transparent" : "#F0F0F0"
            }
        }
        TabButton {
            id: addUserBtn
            text: qsTr("Add user")

            contentItem: Text {
                text: addUserBtn.text
                color: "black"
                font.family: "Inter"
                font.pointSize: 14
                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
                elide: Text.ElideRight
            }
            background: Rectangle {
                color: addUserBtn.checked ? "transparent" : "#F0F0F0"
            }
            onClicked: addUserTab.refresh();
        }

    }
}
