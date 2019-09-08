import QtQuick 2.0
import QtMultimedia 5.12

Item {
    width: 1080
    height: 640

    Audio {
        id: playMusic
        source: "qrc:/Music/BeautifulChicken.mp3"
        autoPlay: false
    }

    PropertyAnimation{
        id:play
        target: rectangle
        property: "rotation"
        from:0
        to:350
        duration:10000
        loops: Animation.Infinite
    }

    Rectangle {
        id: rectangle

        width: 500
        height: 500
        color: "#ffffff"
        clip: true
        anchors.verticalCenterOffset: -50
        anchors.horizontalCenter: parent.horizontalCenter
        anchors.verticalCenter: parent.verticalCenter

        Image {
            id: image
            clip: true
            anchors.fill: parent
            fillMode: Image.PreserveAspectFit
            source: "qrc:/Image/Record.jpg"

            Rectangle {
                id: rectangle1
                width: 200
                height: 200
                radius: 100
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                z: 1
                clip: true
                color: "blue"

                Image {
                    id: image1
                    anchors.fill: rectangle1
                    fillMode: Image.Stretch
                    source: "qrc:/Image/cxk.png"
                }
            }
        }
    }

    MouseArea {
        id: playArea
        anchors.fill: parent
        onPressed:  {
            play.start()
            playMusic.play()
        }
    }
}



















/*##^## Designer {
    D{i:5;anchors_height:100;anchors_width:100}D{i:4;anchors_height:100;anchors_width:100}
D{i:2;anchors_height:100;anchors_width:100}D{i:6;anchors_height:100;anchors_width:100}
}
 ##^##*/
