import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.5
import "Menu"
import "Page" as MyPage

Window {
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
        initialItem: MyPage.HomePage{
        }
    }

    Rectangle {
        id: rectangle
        x: 0
        y: 0
        width: window.width
        height: 56
        color: "#03a9f4"

        MouseArea { //为窗口添加鼠标事件
            anchors.fill: parent

            acceptedButtons: Qt.LeftButton //只处理鼠标左键
            property point clickPos: "0,0"
            onPressed: { //接收鼠标按下事件
                clickPos  = Qt.point(mouse.x,mouse.y)

            }
            onPositionChanged: { //鼠标按下后改变位置
                //鼠标偏移量
                var delta = Qt.point(mouse.x-clickPos.x, mouse.y-clickPos.y)

                //如果mainwindow继承自QWidget,用setPos
                window.setX(window.x+delta.x)
                window.setY(window.y+delta.y)
            }
        }

        ToolButton {
            id: close_button
            x: 592
            y: 8
            anchors.verticalCenter: parent.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 0

            onClicked: {
                window.close()
            }

            icon.source: "qrc:/Icon/Close.png"
        }

        ToolButton {
            id: menu_button
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 0
            icon.source: "qrc:/Icon/Menu.png"
            onClicked: {
                menu_button.icon.source = stackView.depth > 1 ? "qrc:/Icon/Menu.png" : "qrc:/Icon/return.png"
                if (stackView.depth > 1) {
                    stackView.pop()
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
