import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.5
import "Menu"
import"Page"

ApplicationWindow {
    id:window
    visible: true
    width: 1080
    height: 640
    title: qsTr("Hello World")
    flags: Qt.FramelessWindowHint


    //添加字体
    FontLoader{
        id:roboto_thin
        source: "qrc:/Font/Roboto-Thin.ttf"
    }
    FontLoader{
        id:noto_thin
        source: "qrc:/Font/NotoSansCJK-Thin.ttc"

    }
    FontLoader{
        id:roboto_regular
        source: "qrc:/Font/Roboto-Regular.ttf"
    }

    StackView {
        id: stackView
        anchors.right: rectangle.right
        anchors.top: rectangle.bottom
        width: parent.width
        height: parent.height-rectangle.height
        initialItem: HomePage{

        }
    }

    Rectangle {
        id: rectangle
        x: 0
        y: 0
        width: window.width
        height: 56
        color: "#03a9f4"

        ToolButton {
            id: roundButton
            x: 592
            y: 8

            onClicked: {
                window.close()
            }
        }

        ToolButton {
            id: roundButton1
            icon.source: "qrc:/Icon/Menu.png"
            onClicked: {
                if (stackView.depth > 1) {
                    stackView.pop()
                    //stackView.currentIndex = -1
                } else {
                    drawer.open()
                }
            }
        }

        Drawer {
            id: drawer
            width: 0.33 * window.width
            height: window.height
            MyMenu{
                anchors.fill: parent
          }
       }
    }
}
