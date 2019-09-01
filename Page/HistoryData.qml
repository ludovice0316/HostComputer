import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.5

Page{
    SwipeView{
        id:swipeView
        anchors.topMargin: 0
        anchors.rightMargin: 0
        anchors.leftMargin: 0
        anchors.fill:parent
        currentIndex: tabBar.currentIndex

        Item{
            id:table
            width: swipeView.width
            height: swipeView.height
            Rectangle {
                id: title
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
                id: header
                width: parent.width*0.8
                height: 40
                color: "#2980b9"
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.top: title.bottom
                anchors.topMargin: 0

                Rectangle {
                    id: header_index
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
                    id: header_weight
                    width: parent.width/3
                    height: parent.height
                    color: "transparent"
                    anchors.left: header_index.right
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
                    id: header_date
                    width: parent.width/3
                    height: parent.height
                    color: "transparent"
                    anchors.left: header_weight.right
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
                anchors.top: header.bottom
                anchors.topMargin: 0

                ListView{
                    id:listView
                    anchors.fill: parent
                    //model: xmlModel
                    delegate:Rectangle{
                        id: record
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

                ListView{
                    id:listView_dynamic
                    anchors.fill: parent
                    //model: xmlModel_dynamic
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
