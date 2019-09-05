import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.5

Page{
    id:historyData
    SwipeView{
        id:swipeView
        anchors.fill:parent
        currentIndex: tabBar.currentIndex

        Item{
            id:table_static
            width: swipeView.width
            height: swipeView.height
            Rectangle {
                id: title_static
                x: 0
                width: parent.width*0.8
                height: parent.height*0.2
                color: "transparent"
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 0
                Text {
                    id: title_text
                    text: qsTr("静态重量记录")
                    font.letterSpacing: 5
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    anchors.fill: parent
                    font.wordSpacing: 0
                    font.family: "Verdana"
                    font.pointSize: 24
                }
            }

            Rectangle {
                id: header_static
                width: parent.width*0.8
                height: 40
                color: "#2980b9"
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: title_static.bottom
                anchors.topMargin: 0

                Rectangle {
                    id: header_index_static
                    width: parent.width/3
                    height: parent.height
                    color: "transparent"
                    anchors.left: parent.left
                    anchors.leftMargin: 0
                    anchors.top: parent.top
                    anchors.topMargin: 0

                    Text {
                        id: header_index_text
                        text: qsTr("序号")
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        anchors.fill: parent
                        font.pixelSize: 18
                    }
                }

                Rectangle {
                    id: header_weight_static
                    width: parent.width/3
                    height: parent.height
                    color: "transparent"
                    anchors.left: header_index_static.right
                    anchors.leftMargin: 0
                    anchors.top: parent.top
                    anchors.topMargin: 0

                    Text {
                        id: header_weight_text
                        text: qsTr("重量")
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        anchors.fill: parent
                        font.pixelSize: 18
                    }
                }


                Rectangle {
                    id: header_date_static
                    width: parent.width/3
                    height: parent.height
                    color: "transparent"
                    anchors.left: header_weight_static.right
                    anchors.leftMargin: 0
                    anchors.top: parent.top
                    anchors.topMargin: 0

                    Text {
                        id: header_date_text
                        text: qsTr("日期")
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        anchors.fill: parent
                        font.pixelSize: 18
                    }
                }

            }

            Rectangle{
                width: parent.width*0.8
                anchors.horizontalCenter: parent.horizontalCenter
                clip: true
                border.width: 0
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 0
                anchors.top: header_static.bottom
                anchors.topMargin: 0

                ListModel{
                    id:staticModel
                }

                ListView{
                    id:listView_static

                    anchors.fill: parent
                    model:staticModel
                    delegate:Rectangle{
                        id: record_static
                        width: parent.width
                        height: 40
                        anchors.left: parent.left
                        anchors.leftMargin: 0
                        color: model.index%2 === 0?"#e9e9e9":"#f6f6f6"
                        Rectangle{
                            id:index
                            width: parent.width/3
                            height: parent.height
                            anchors.left: parent.left
                            anchors.leftMargin: 0
                            anchors.top: parent.top
                            anchors.topMargin: 0
                            color: "transparent"

                            Text {
                                id: index_text
                                text: model.index+1
                                font.family: "Verdana"
                                anchors.fill: parent
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignHCenter
                                font.pixelSize: 12
                            }
                        }

                        Rectangle {
                            id: weight
                            width: parent.width/3
                            height: parent.height
                            anchors.left: index.right
                            anchors.leftMargin: 0
                            anchors.top: parent.top
                            anchors.topMargin: 0
                            color: "transparent"

                            Text {
                                id: weight_text
                                text: model.weight+"g"
                                font.family: "Verdana"
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignHCenter
                                anchors.fill: parent
                                font.pixelSize: 12
                            }
                        }

                        Rectangle {
                            id: date
                            x: 3
                            width: parent.width/3
                            height: parent.height
                            anchors.top: parent.top
                            anchors.topMargin: 0
                            anchors.left: weight.right
                            anchors.leftMargin: 0
                            color: "transparent"

                            Text {
                                id: date_text
                                text: model.date
                                font.family: "Verdana"
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignHCenter
                                anchors.fill: parent
                                font.pixelSize: 12
                            }
                        }
                    }

                    Component.onCompleted: {
                        readSerial.initListView(true,20)
                        var staticWeight = readSerial.getWeightData();
                        var staticDate = readSerial.getDateData();
                        for(var i=0;i<staticWeight.length;i++){
                            staticModel.append({"weight":staticWeight[i],"date":staticDate[i]})
                        }
                    }

                    onDragEnded: {
                        if(contentY<0){
                            readSerial.updateNewData(true,20);
                            var newWeight = readSerial.getWeightData();
                            var newDate = readSerial.getDateData();
                            for(var i=0;i<newWeight.length;i++){
                                staticModel.insert(i,{"weight":newWeight[i],"date":newDate[i]})
                            }
                        }
                        else if(contentY>this.count*40-listView_static.height){

                            readSerial.updateOldData(true,20);
                            var oldWeight = readSerial.getWeightData();
                            var oldDate = readSerial.getDateData();
                            for(var j=0;j<oldWeight.length;j++){
                                staticModel.append({"weight":oldWeight[j],"date":oldDate[j]})
                            }
                        }
                    }
                }
            }
        }

        Item{
            id:table_dynamic
            width: swipeView.width
            height: swipeView.height

            Rectangle {
                id: title_dynamic
                width: parent.width*0.8
                height: parent.height*0.2
                color: "transparent"
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: parent.top
                anchors.topMargin: 0
                Text {
                    id: title_text_dynamic
                    text: qsTr("动态重量记录")
                    font.letterSpacing: 5
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    anchors.fill: parent
                    font.wordSpacing: 0
                    font.family: "Verdana"
                    font.pointSize: 24
                }
            }

            Rectangle {
                id: header_dynamic
                width: parent.width*0.8
                height: 40
                color: "#2980b9"
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: title_dynamic.bottom
                anchors.topMargin: 0

                Rectangle {
                    id: header_index_dynamic
                    width: parent.width/3
                    height: parent.height
                    color: "transparent"
                    anchors.left: parent.left
                    anchors.leftMargin: 0
                    anchors.top: parent.top
                    anchors.topMargin: 0

                    Text {
                        id: header_index_text_dynamic
                        text: qsTr("序号")
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        anchors.fill: parent
                        font.pixelSize: 18
                    }
                }

                Rectangle {
                    id: header_weight_dynamic
                    width: parent.width/3
                    height: parent.height
                    color: "transparent"
                    anchors.left: header_index_dynamic.right
                    anchors.leftMargin: 0
                    anchors.top: parent.top
                    anchors.topMargin: 0

                    Text {
                        id: header_weight_text_dynamic
                        text: qsTr("重量")
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        anchors.fill: parent
                        font.pixelSize: 18
                    }
                }

                Rectangle {
                    id: header_date_dynamic
                    width: parent.width/3
                    height: parent.height
                    color: "transparent"
                    anchors.left: header_weight_dynamic.right
                    anchors.leftMargin: 0
                    anchors.top: parent.top
                    anchors.topMargin: 0

                    Text {
                        id: header_date_text_dynamic
                        text: qsTr("日期")
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        anchors.fill: parent
                        font.pixelSize: 18
                    }
                }

            }

            Rectangle{
                width: parent.width*0.8
                anchors.horizontalCenter: parent.horizontalCenter
                clip: true
                border.width: 0
                anchors.bottom: parent.bottom
                anchors.bottomMargin: 0
                anchors.top: header_dynamic.bottom
                anchors.topMargin: 0

                ListModel{
                    id:dynamicModel
                }

                ListView{
                    id:listView_dynamic
                    anchors.fill: parent
                    model: dynamicModel
                    delegate:Rectangle{
                        id: record_dynamic
                        width: parent.width
                        height: 40
                        anchors.left: parent.left
                        anchors.leftMargin: 0
                        color: model.index%2 === 0?"#e9e9e9":"#f6f6f6"
                        Rectangle{
                            id:index_dynamic
                            width: parent.width/3
                            height: parent.height
                            anchors.left: parent.left
                            anchors.leftMargin: 0
                            anchors.top: parent.top
                            anchors.topMargin: 0
                            color: "transparent"

                            Text {
                                id: index_text_dynamic
                                text: model.index+1
                                font.family: "Verdana"
                                anchors.fill: parent
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignHCenter
                                font.pixelSize: 12
                            }
                        }

                        Rectangle {
                            id: weight_dynamic
                            width: parent.width/3
                            height: parent.height
                            anchors.left: index_dynamic.right
                            anchors.leftMargin: 0
                            anchors.top: parent.top
                            anchors.topMargin: 0
                            color: "transparent"

                            Text {
                                id: weight_text_dynamic
                                text: model.weight+"g"
                                font.family: "Verdana"
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignHCenter
                                anchors.fill: parent
                                font.pixelSize: 12
                            }
                        }

                        Rectangle {
                            id: date_dynamic
                            x: 3
                            width: parent.width/3
                            height: parent.height
                            anchors.top: parent.top
                            anchors.topMargin: 0
                            anchors.left: weight_dynamic.right
                            anchors.leftMargin: 0
                            color: "transparent"

                            Text {
                                id: date_text_dynamic
                                text: model.date
                                font.family: "Verdana"
                                verticalAlignment: Text.AlignVCenter
                                horizontalAlignment: Text.AlignHCenter
                                anchors.fill: parent
                                font.pixelSize: 12
                            }
                        }
                    }

                    Component.onCompleted: {
                        readSerial.initListView(false,20)
                        var dynamicWeight = readSerial.getWeightData();
                        var dynamicDate = readSerial.getDateData();
                        for(var j=0;j<dynamicWeight.length;j++){
                            dynamicModel.append({"weight":dynamicWeight[j],"date":dynamicDate[j]})
                        }
                    }

                    onDragEnded: {
                        if(contentY<0){
                            readSerial.updateNewData(false,20);
                            var newWeight = readSerial.getWeightData();
                            var newDate = readSerial.getDateData();
                            for(var i=0;i<newWeight.length;i++){
                                dynamicModel.insert(i,{"weight":newWeight[i],"date":newDate[i]})
                            }
                        }
                        else if(contentY>this.count*40-listView_static.height){
                            readSerial.updateOldData(false,20);
                            var oldWeight = readSerial.getWeightData();
                            var oldDate = readSerial.getDateData();
                            for(var j=0;j<oldWeight.length;j++){
                                dynamicModel.append({"weight":oldWeight[j],"date":oldDate[j]})
                            }
                        }
                    }
                }
            }
        }
    }

    footer: TabBar{
        id:tabBar
        currentIndex: swipeView.currentIndex

        TabButton{
            text: "静态"
        }
        TabButton{
            text: "动态"
        }
    }
}
