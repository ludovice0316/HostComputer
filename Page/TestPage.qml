import QtQuick 2.12
import QtQuick.Controls 2.12


Rectangle{
    id:testPage
    color: "lightblue"
    radius: 4

    Dialog {
        id: messageDialog

        property string headerColor: "#1296db"
        property string messageTitle: "连接成功"
        property string messageDetail: "已与串口连接"
        property string messageIcon: "qrc:/Image/Setting.png"
        x: 145
        y: 88
        modal: true
        width: 350
        height: 320
        header: Rectangle{
            anchors.fill: parent
            color: "white"
            Rectangle{
                id:messageHeader
                anchors.top: parent.top
                anchors.left: parent.left
                width: messageDialog.width
                height: 150
                color: messageDialog.headerColor
                Image {
                    id: messageDialogIcon
                    width: 64
                    height: 64
                    anchors.centerIn: parent
                    source: messageDialog.messageIcon
                }
            }

            Text {
                id: title
                text: messageDialog.messageTitle
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.top: messageHeader.bottom
                anchors.topMargin: 15
                font.pixelSize: 28
            }

            Text {
                id: detail
                text: messageDialog.messageDetail
                wrapMode: Text.WrapAnywhere
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 15
                anchors.right: parent.right
                anchors.rightMargin: 15
                anchors.left: parent.left
                anchors.leftMargin: 15
                anchors.top: title.bottom
                anchors.topMargin: 20
                font.pixelSize: 16
                color: "#707070"
            }
        }
    }

    SpinBox {
        id: zeroSetting
        x: 90
        y: 116
        width: 150
        height: 48
        editable: true
        stepSize: 10
        from:0
        to: 2100
        onValueChanged: {
            readSerial.zeroSetting(String(zeroSetting.value))
        }
    }

    Text {
        id: element2
        x: 8
        y: 134
        width: 48
        height: 12
        text: qsTr("系统调零")
        fontSizeMode: Text.VerticalFit
        font.pixelSize: 12
    }

    Text {
        id: element3
        x: 246
        y: 130
        width: implicitWidth
        height: implicitHeight
        text: qsTr("mv")
        font.pixelSize: 20
    }

    Rectangle {
        id: rectangle
        x: 77
        y: 170
        width: 410
        height: 79
        color: "#00000000"
        radius: 8
        border.width: 1
        border.color: "#8a8a8a"

        Text {
            id: element4
            x: 13
            y: 19
            width: implicitWidth
            height: implicitHeight
            text: qsTr("操作流程：
1、机器静止状态下，使用4位半万用表测量传感器S+与S-两端电压值得Vs；
2、系统调零参数Vz=(Vs-1.2mv)*100
")
            anchors.verticalCenterOffset: 0
            anchors.horizontalCenterOffset: 0
            anchors.verticalCenter: parent.verticalCenter
            anchors.horizontalCenter: parent.horizontalCenter
            font.pixelSize: 12
        }
    }

    Rectangle {
        id: rectangle1
        x: 272
        y: 8
        width: 350
        height: 320
        color: "#ffffff"
        visible: false

        Rectangle {
            id: rectangle2
            x: 0
            y: 0
            width: 350
            height: 150
            color: "#1296db"
        }

        Text {
            id: element
            text: qsTr("Text")
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.top: rectangle2.bottom
            anchors.topMargin: 15
            font.pixelSize: 28
        }

        Text {
            id: element1
            text: qsTr("Text")
            wrapMode: Text.WrapAnywhere
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 15
            anchors.right: parent.right
            anchors.rightMargin: 15
            anchors.left: parent.left
            anchors.leftMargin: 15
            anchors.top: element.bottom
            anchors.topMargin: 20
            font.pixelSize: 16
        }
    }


    Component.onCompleted: {
        var list = readSerial.availablePort()
        for(var i=0;i<list.length;i++){
            //measure_model.append({text:list[i]})
            //speed_model.append({text:list[i]})
        }
    }
}























/*##^## Designer {
    D{i:0;autoSize:true;height:480;width:640}D{i:10;anchors_x:22;anchors_y:156}D{i:11;anchors_height:12;anchors_width:309;anchors_x:22;anchors_y:202}
}
 ##^##*/
