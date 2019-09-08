import QtQuick 2.12
import QtQuick.Controls 2.5
import "../Menu"
Rectangle{
    id: rectangle
    width: 300
    height: 480
    focus: true

    Rectangle {
        id: top_seperator
        x: 0
        width: parent.width
        height: 1
        color: "#9e9e9e"
        anchors.topMargin: 1
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
                    source:"qrc:/Page/Singing.qml"
                    content:"唱"
                }

                ListElement {
                    source:"qrc:/Page/Dancing.qml"
                    content:"跳"
                }

                ListElement {
                    source:"qrc:/Page/Rap.qml"
                    content:"Rap"
                }
                ListElement {
                    source:"qrc:/Page/HistoryData.qml"
                    content:"篮球"
                }
                ListElement {
                    source:"qrc:/Page/HistoryData.qml"
                    content:"历史数据"
                }
            }
            delegate: MenuButton{
                width: listView.width
                height: 58
                text_pixelSize: 20
                text_content: content
                icon_source: icon_source
            }
        }
    }

    ToolButton {
        id: menu_closeButton
        x: 106
        y: 427
        width: 32
        height: 32
        text: qsTr("Tool Button")
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
        anchors.horizontalCenter: parent.horizontalCenter
        icon.source: "qrc:/Icon/Close.png"
        onClicked: {
            window.close()
        }
    }
}






















