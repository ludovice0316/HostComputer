import QtQuick 2.0
import QtQuick.Controls 2.5
import "../Menu"
Rectangle{
    id: rectangle
    width: 300
    height: 480
    focus: true

    Rectangle {
        id: top_seperator
        width: parent.width
        height: 1
        color: "#9e9e9e"
        anchors.top: title.bottom
    }

    Rectangle {
        id: bottom_seperator
        width: parent.width
        height: 1
        color: "#9e9e9e"
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 58
    }

    MenuTitle{
        id:title
        x: 0
        y: 0
        width: parent.width
        height: 48
    }

    Rectangle{
        anchors.top: top_seperator.bottom
        anchors.bottom: bottom_seperator.top
        anchors.left: parent.left
        anchors.right: parent.right
        clip:true
        ListView {
            id: listView
            anchors.fill: parent
            model: ListModel {
                id:model
                ListElement {
                    icon_source:"qrc:/Icon/Menu.png"
                    source:"qrc:/Page/TestPage.qml"
                }

                ListElement {
                    icon_source:"qrc:/Icon/Menu.png"
                    source:"qrc:/Page/TestPage.qml"
                }

                ListElement {
                    icon_source:"qrc:/Icon/Menu.png"
                    source:"qrc:/Page/TestPage.qml"
                }

                ListElement {
                    icon_source:"qrc:/Icon/Menu.png"
                    source:"qrc:/Page/TestPage.qml"
                }
            }
            delegate: MenuButton{
                width: listView.width
                height: 58
                text_pixelSize: 20
                icon_source: icon_source
            }
        }
    }

    MenuRoundButton {
        id: menuRoundButton
        anchors.horizontalCenterOffset: 0
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 6
        anchors.horizontalCenter: parent.horizontalCenter
        icon_source: "qrc:/Icon/Menu.png"
        onClicked: {
            window.close()
        }
    }
}






















