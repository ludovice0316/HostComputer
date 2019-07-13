import QtQuick 2.0
import QtQuick.Controls 2.5

Rectangle{
    id:testPage
    color: "lightblue"
    Button {
        id: button
        x: 8
        y: 8
        width: 123
        height: 60
        text: qsTr("静态零点校准")
        onClicked: {
            readSerial.calibration("0")
        }
    }

    Switch {
        id: element
        x: 137
        y: 74
        width: 123
        height: 48
        text: qsTr("")
        autoRepeat: true
        onCheckedChanged: {
            if(checked === true){
                readSerial.photocellSet("double")
            }
            else{
                readSerial.photocellSet("single")
            }
        }
    }

    Button {
        id: button1
        x: 137
        y: 8
        width: 123
        height: 60
        text: qsTr("静态200克校准")
        onClicked: {
            readSerial.calibration("200")
        }
    }

    Label {
        id: label
        x: 8
        y: 74
        width: 123
        height: 48
        text: qsTr("双光电模式")
        font.pointSize: 14
        renderType: Text.NativeRendering
        verticalAlignment: Text.AlignVCenter
        horizontalAlignment: Text.AlignHCenter
    }

    Button {
        id: button2
        x: 8
        y: 128
        text: qsTr("Button")
        onClicked: {
            readSerial.beltStart()
        }
    }

    Button {
        id: button3
        x: 78
        y: 128
        text: qsTr("Button")
        onClicked: {
            readSerial.start("com4")
            readSerial.beltStop()
        }
    }
}






/*##^## Designer {
    D{i:0;autoSize:true;height:480;width:640}
}
 ##^##*/
