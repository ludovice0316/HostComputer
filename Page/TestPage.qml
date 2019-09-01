import QtQuick 2.12
import QtQuick.Controls 2.12


Rectangle{
    id:testPage
    color: "lightblue"
    radius: 4

    ComboBox {
        id: measure
        x: 90
        y: 8
        model: ListModel{
            id:measure_model
        }
        onActivated: {
            readSerial.resetPortName(currentText)
        }
    }

    ComboBox {
        id: speed
        x: 90
        y: 62
        model: ListModel{
            id:speed_model
        }
        onActivated: {
            writeSerial.resetPortName(currentText)
        }
    }

    Text {
        id: element
        x: 8
        y: 26
        text: qsTr("测量串口")
        lineHeight: 0.8
        font.pixelSize: 12
    }

    Text {
        id: element1
        x: 8
        y: 80
        text: qsTr("电机串口")
        font.pixelSize: 12
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

    Component.onCompleted: {
        var list = readSerial.availablePort()
        for(var i=0;i<list.length;i++){
            measure_model.append({text:list[i]})
            speed_model.append({text:list[i]})
        }
    }
}





/*##^## Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
 ##^##*/
