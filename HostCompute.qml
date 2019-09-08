import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.5
import QtGraphicalEffects 1.12
import "Menu"
import "Page" as MyPage

Window {
    id:window
    visible: true
    width: 1080
    height: 640
    title: qsTr("Hello World")
    flags: Qt.FramelessWindowHint||Qt.Window

    //添加字体
    FontLoader{
        id:roboto_thin
        source: "qrc:/Font/Roboto-Thin.ttf"
    }
    FontLoader{
        id:noto_light
        source: "qrc:/Font/NotoSansSC-Light.otf"
    }
    FontLoader{
        id:roboto_regular
        source: "qrc:/Font/Roboto-Regular.ttf"
    }

    StackView {
        id: stackView
        width: parent.width
        height: parent.height-rectangle.height
        anchors.top: rectangle.bottom
        anchors.topMargin: 0
        anchors.horizontalCenter: parent.horizontalCenter
        initialItem: MyPage.HomePage{
        }
    }

    Rectangle {
        id: rectangle
        x: 0
        y: 0
        width: window.width
        height: 40
        color: "#2196f3"

        LinearGradient {
            anchors.fill: parent
            start: Qt.point(0, 0)
            end: Qt.point(window.width, 150)
            gradient: Gradient {
                GradientStop { position: 0.0; color: "#3498db" }
                GradientStop { position: 1.0; color: "#8e44ad" }
            }
        }

        MouseArea { //为窗口添加鼠标事件
            anchors.fill: parent

            acceptedButtons: Qt.LeftButton //只处理鼠标左键
            property point clickPos: "0,0"
            height: 32
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
                readSerial.saveStaticData()
                readSerial.saveDynamicData()
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
                if(stackView.depth > 1){
                    menu_button.icon.source = "qrc:/Icon/Menu.png"
                }

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

