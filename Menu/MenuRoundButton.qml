import QtQuick 2.0
import QtQuick.Controls 2.5

Button{
    id:round_button
    property alias icon_source: icon.source

    property real r: 24
    property string colorUp: "#F44336"
    property string colorDown: "#8A8A8A"

    width: r*2
    height: round_button.width
    transformOrigin: Item.Center
    hoverEnabled: true

    background: Rectangle{
        id:roundbutton_background
        anchors.fill: parent
        radius: width/2
        clip: true
        border.width: 1

        Image {
            id: icon
            anchors.fill: parent
        }
    }

    PropertyAnimation {
        id:colorUp_animation
        target: roundbutton_background
        property: "border.color"
        to: colorUp
        duration: 500
    }

    PropertyAnimation {
        id:colorDown_animation
        target: roundbutton_background
        property: "border.color"
        to: colorDown
        duration: 500
    }

    PropertyAnimation {
        id:sizeUp_animation
        target: round_button
        property: "scale"
        to:1.1
        duration: 500
        onStopped: {
            scale = 1.1
        }
    }
    PropertyAnimation {
        id:sizeDown_animation
        target: round_button
        property: "scale"
        to:1.0
        duration: 500
        onStopped: {
            scale = 1.0
        }
    }


    onHoveredChanged: {
        if(hovered === true){
            colorUp_animation.start()
            sizeUp_animation.start()
        }
        else{
            colorDown_animation.start()
            sizeDown_animation.start()
        }
    }
}

