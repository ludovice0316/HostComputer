import QtQuick 2.0
import QtQuick.Controls 2.5
import QtMultimedia 5.8

Item {
    Video {
          id: video
          width : 800
          height : 600
          anchors.centerIn: parent
          source: "qrc:/Video/doctorRap.avi"

          Label{
              id:label
              text: "点击屏幕欣赏RAP"
              visible: true
              anchors.centerIn: parent
              font.pixelSize: 25
          }

          MouseArea {
              anchors.fill: parent
              onClicked: {
                  label.visible = false
                  video.play()
              }
          }

          focus: true
          Keys.onSpacePressed: video.playbackState == MediaPlayer.PlayingState ? video.pause() : video.play()
          Keys.onLeftPressed: video.seek(video.position - 1000)
          Keys.onRightPressed: video.seek(video.position + 1000)
      }
}
