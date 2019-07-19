import QtQuick 2.12
import QtQuick.Controls 2.5
Rectangle{
    id: title_bar
    height: 58
    width:300
    Text {
        id: title_text
        width: title_bar.width/2
        height: title_bar.height
        text: qsTr("主菜单")
        anchors.left: parent.left
        anchors.leftMargin: 20
        anchors.verticalCenter: parent.verticalCenter
        horizontalAlignment: Text.AlignLeft
        verticalAlignment: Text.AlignVCenter
        font.pixelSize: 24
    }

    ToolButton {
        id: drawer_closeButton
        x: 260
        y: 13
        width: 32
        height: 32
        text: qsTr("Tool Button")
        anchors.right: parent.right
        anchors.rightMargin: 8
        anchors.verticalCenter: parent.verticalCenter
        icon.source: "qrc:/Icon/return.png"
        onClicked: {
            drawer.close()
        }
    }
}

/*##^## Designer {
    D{i:1;anchors_width:150;anchors_x:20}
}
 ##^##*/
