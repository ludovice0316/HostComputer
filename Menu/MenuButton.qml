import QtQuick 2.12
import QtQuick.Controls 2.5
Button{
    id: button
    property alias background_color:background.color
    property alias hovered_background_color:hovered_background.color
    property alias hovered_background_opacity:hovered_background.color
    property alias clicked_background_color:clicked_background.color
    property alias clicked_background_opacity:clicked_background.color
    property alias icon_source:icon.source
    property alias text_color:text.color
    property alias text_pixelSize:text.font.pixelSize
    property alias text_content:text.text


    hoverEnabled: true


    background: Rectangle{
        id: background
        color: "#ffffff"
        anchors.fill: parent
        clip: true

        Rectangle{
            id:hovered_background
            anchors.fill: parent
            color: "#8a8a8a"
            opacity: 0.3
            visible: false
        }

        Rectangle{
            id:clicked_background
            property real mouseX: 0
            property real mouseY: 0
            x: mouseX-width/2
            y: mouseY-width/2
            color: "#8a8a8a"
            opacity: 0.6
            visible: false
            height: width
            radius:width/2


            PropertyAnimation{
                id:clicked_animation
                target: clicked_background
                properties: "width"
                from:0
                to:Math.max(2.5*button.width,2.5*button.height)
                duration: 500
                onStopped: clicked_background.visible = false
            }
        }

        Image {
            id: icon
            width: height
            height: button.height-10
            anchors.left: parent.left
            anchors.leftMargin: 20
            anchors.verticalCenter: parent.verticalCenter
        }

        Text {
            id: text
            height: button.height-10
            color: "#8a8a8a"
            text: qsTr("详细信息")
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignLeft
            anchors.left: icon.right
            anchors.leftMargin: 20
            anchors.right: parent.right
            anchors.rightMargin: 20
            anchors.verticalCenter: parent.verticalCenter
            font.pixelSize: 24
        }
    }
    MouseArea{
        anchors.fill: parent
        onClicked: {
            clicked_animation.stop()
            clicked_background.visible = true
            clicked_background.mouseX = mouseX
            clicked_background.mouseY = mouseY
            clicked_animation.start()

            listView.currentIndex = index
            stackView.push(model.source)
            drawer.close()
        }
    }
    onHoveredChanged: {
        if(hovered === true){
            hovered_background.visible = true
        }
        else{
            hovered_background.visible = false
        }
    }
}
