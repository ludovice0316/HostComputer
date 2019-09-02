import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.5
import QtQuick.Controls.Material 2.3
import QtCharts 2.3

Page{
    id: homePage
    width: 1080
    height: 960
    Rectangle {
        id: control_panel

        property real sum_number: 0
        property real average_weight: 0
        property real max_weight: 0
        property real min_weight: 0
        property real passed_ratio: 100
        property real passed_number: 0
        property real failed_number: 0


        width: parent.width/4
        radius: 2
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.top: parent.top
        anchors.topMargin: 20

        FontLoader{
            id:roboto_thin
            source: "qrc:/Font/Roboto-Thin.ttf"
        }

        Rectangle {
            id: control_title
            objectName:"control_title"
            width: parent.width
            height: 60

            color: "#1c97ec"
            radius: 3
            anchors.left: parent.left
            anchors.leftMargin: 0
            anchors.top: parent.top
            anchors.topMargin: 0

            Text {
                id: weight
                width: implicitWidth
                height: implicitHeight
                text: qsTr("重量")
                anchors.verticalCenter: parent.verticalCenter
                anchors.left: parent.left
                anchors.leftMargin: 10
                lineHeight: 0.9
                font.pixelSize: 24
            }

            Text {
                id: weightValue
                x: 95
                text: qsTr("0")
                anchors.horizontalCenter: parent.horizontalCenter
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 24
            }

            Text {
                id: unitName
                text: qsTr("g")
                anchors.right: parent.right
                anchors.rightMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                font.pixelSize: 24
            }
        }

        Image {
            id: speed_panel
            width: Math.min(parent.height,parent.width)*2/5
            height: width
            anchors.top: control_title.bottom
            anchors.topMargin: 10
            anchors.left: parent.left
            anchors.leftMargin: 10
            source: "qrc:/Image/SpeedSlot.png"

            Canvas{
                anchors.fill: parent
                id:canvas
                Timer{
                    id:timer
                    interval: 10
                    repeat: true
                    property real startAngle: 0
                    property real lastFrameAngle: 0
                    property real endAngle: 0
                    property int loops: 99


                    function outExpo(t,b,c,d){
                        var x = t/d
                        var y = 1-Math.pow(2,-10*x)
                        return b+c*y
                    }

                    function drawArc(){
                        canvas.requestPaint() //开始绘制
                        var ctx = canvas.getContext("2d") //获取ctx
                        ctx.clearRect(0,0,canvas.width,canvas.height)
                        if(timer.lastFrameAngle <= Math.PI ){
                            ctx.strokeStyle = "#036eb8" //设置颜色
                            speed_value.color = "#036eb8"
                            element1.color = "#036eb8"
                        }
                        else if(timer.lastFrameAngle <= Math.PI*3/2){
                            ctx.strokeStyle = "#ffd551" //设置颜色
                            speed_value.color = "#ffd551"
                            element1.color = "#ffd551"
                        }
                        else{
                            ctx.strokeStyle = "red" //设置颜色
                            speed_value.color = "red"
                            element1.color = "red"
                        }

                        ctx.lineCap = "round"
                        ctx.lineWidth = 8 //设置线宽

                        var x = canvas.width/2 //圆心x坐标
                        var y = canvas.height/2 //圆心y坐标
                        var radius = canvas.width/2-4 //半径
                        var startAngle = Math.PI/2 //开始角度

                        var t = 1000-timer.loops*10
                        var d = 1000 //动画持续时间，等于interval*loops,interval固定不变
                        var b = timer.startAngle //动画开始角度

                        var c = timer.endAngle //动画预期结束角度
                        var endAngle = Math.PI/2+outExpo(t,b,c,d) //系统坐标系，结束角度


                        ctx.beginPath() //开始路径
                        ctx.arc(x,y,radius,startAngle,endAngle,false) //绘制圆弧
                        ctx.stroke() //填充路径
                        timer.lastFrameAngle = endAngle - Math.PI/2 //该帧角度，degree角度
                        //                        console.log(timer.lastFrameAngle)
                    }

                    onTriggered: {

                        drawArc()
                        if(timer.loops--<=0){//递减计数器
                            timer.stop()
                            timer.loops = 100
                        }
                    }
                }

                Text {
                    id: speed_value
                    width: implicitWidth
                    height: implicitHeight
                    text: "0"
                    anchors.verticalCenterOffset: 10
                    renderType: Text.NativeRendering
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.verticalCenter: parent.verticalCenter
                    horizontalAlignment: Text.AlignHCenter
                    font.weight: Font.Normal
                    font.pixelSize: 32
                    font.family: roboto_thin.name
                    color: "#036eb8"

                }

                Text {
                    id: element1
                    width: implicitWidth
                    height: implicitHeight
                    text: qsTr("m/min")
                    anchors.horizontalCenterOffset: 0
                    anchors.horizontalCenter: parent.horizontalCenter
                    anchors.top: parent.top
                    anchors.topMargin: 10
                    font.pixelSize: 20
                    font.family: roboto_thin.name
                    color: "#036eb8"
                }
            }
        }

        Label {
            id: max
            width: implicitWidth
            height: (speed_panel.height-30)/4
            color: "#515151"
            text: qsTr("上限值")
            anchors.top: speed_panel.bottom
            anchors.topMargin: 40
            anchors.left: parent.left
            anchors.leftMargin: 10
            lineHeight: 0.8
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font.pointSize: 12
            font.family: roboto_thin.name
        }

        Label {
            id: min
            width: implicitWidth
            height: max.height
            color: "#515151"
            text: qsTr("下限值")
            anchors.top: max.bottom
            anchors.topMargin: 30
            anchors.left: parent.left
            anchors.leftMargin: 10
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pointSize: 12
            font.family: roboto_thin.name
        }

        Label {
            id: speed
            width: implicitWidth
            height: max.height
            color: "#515151"
            text: qsTr("电机速度")
            anchors.top: min.bottom
            anchors.topMargin: 30
            anchors.left: parent.left
            anchors.leftMargin: 10
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font.pointSize: 12
            font.family: roboto_thin.name

        }

        SpinBox {
            id: minSpinBox
            width: 120
            height: 40
            anchors.verticalCenterOffset: 0
            anchors.right: parent.right
            anchors.rightMargin: 10
            anchors.verticalCenter: min.verticalCenter
            Material.accent: Material.Blue
            Material.primary: Material.Red
            wheelEnabled: true
            editable: true
            font.family: roboto_regular.name
        }

        SpinBox {
            id: maxSpinBox
            height: 40
            width: 120
            anchors.verticalCenterOffset: 0
            anchors.verticalCenter: max.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 10
            wheelEnabled: true
            editable: true
            Material.accent: Material.Blue
            Material.primary: Material.Red
            font.family: roboto_regular.name
        }

        SpinBox {
            id: speedSpinBox
            height: 40
            width: 120
            stepSize: 10
            anchors.verticalCenter: speed.verticalCenter
            anchors.right: parent.right
            anchors.rightMargin: 10
            to: 140
            wheelEnabled: true
            editable: true
            font.family: roboto_regular.name

            onValueChanged: {
                //如果还未启动，则不需要播放动画和显示电机速度
                if(start_button.mycheck === true){
                    speed_value.text = String(speedSpinBox.value)
                    var deg = Math.PI*2*speedSpinBox.value/140
                    timer.startAngle = timer.lastFrameAngle //按键按下，从此刻重新开始动画
                    timer.loops = 100 //把时间轴置0
                    timer.startAngle = timer.lastFrameAngle //上帧度数作为新动画的开始
                    timer.endAngle = deg-timer.startAngle //顺时针旋转deg度
                    speed_value.text = String(speedSpinBox.value)
                    timer.start()
                }


                if(speedSpinBox.value != 0){
                    writeSerial.changeSpeed(String(speedSpinBox.value))
                    readSerial.beltSpeedChange(String(speedSpinBox.value))
                }
                else{
                    start_button.mycheck = false
                    start_button.text = qsTr("启动")
                    start_button.Material.background = Material.Blue
                    writeSerial.stop()
                    writeSerial.changeSpeed(String(0))
                    readSerial.beltStop()

                }
            }
        }

        Button {
            id: clear_button
            width: 100
            height: 48
            text: qsTr("清空数据")
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.top: calibrationButton_0g.bottom
            anchors.topMargin: 10
            font.family: roboto_regular.name
            Material.background: Material.Blue
            Material.elevation: 0
            onClicked: {
                //将数据绑定的变量置零
                control_panel.sum_number = 0
                control_panel.average_weight = 0
                control_panel.max_weight = 0
                control_panel.min_weight = 0
                control_panel.passed_number = 0
                control_panel.passed_ratio = 100
                control_panel.failed_number = 0

                //将数据显示置零
                moreInfo_model.setProperty(0,"data_value",String((0).toFixed(0)))
                moreInfo_model.setProperty(1,"data_value",String((0).toFixed(1)))
                moreInfo_model.setProperty(2,"data_value",String((0).toFixed(1)))
                moreInfo_model.setProperty(3,"data_value",String((0).toFixed(1)))

                //将曲线图置零
                line.clear()
                axisX.max = 10
                axisY.max = 50
                axisY.min = 0
                chart.pointX = 0
            }
        }

        Button {
            property bool mycheck: false
            width: 120
            height: 48

            id: start_button
            text: qsTr("启动")
            anchors.bottom: speed_panel.bottom
            anchors.bottomMargin: 0
            anchors.leftMargin: 0
            anchors.right: parent.right
            anchors.rightMargin: 10
            anchors.topMargin: 10
            font.pointSize: 10
            spacing: 4
            font.family: roboto_regular.name
            Material.background: Material.Blue
            Material.elevation: 0

            onClicked: {
                if(start_button.mycheck === false){

                    var deg = Math.PI*2*speedSpinBox.value/140
                    timer.startAngle = timer.lastFrameAngle //按键按下，从此刻重新开始动画
                    timer.loops = 100 //把时间轴置0
                    timer.startAngle = timer.lastFrameAngle //上帧度数作为新动画的开始
                    timer.endAngle = deg-timer.startAngle //顺时针旋转deg度
                    speed_value.text = String(speedSpinBox.value)
                    timer.start()

                    start_button.mycheck = true
                    text = qsTr("停止")
                    Material.background = Material.Red
                    writeSerial.start()
                    readSerial.beltStart()
                }
                else{
                    timer.startAngle = timer.lastFrameAngle //按键按下，从此刻重新开始动画
                    timer.loops = 100 //把时间轴置0
                    timer.startAngle = timer.lastFrameAngle //上帧度数作为新动画的开始
                    timer.endAngle = -timer.startAngle //顺时针旋转deg度
                    timer.start()

                    //如果speedSpinBox的值等于零了，就直接翻转并赋值为零
                    if(speedSpinBox.value === 0){
                        start_button.mycheck = false
                        start_button.text = qsTr("启动")
                        start_button.Material.background = Material.Blue
                        writeSerial.stop()
                        writeSerial.changeSpeed(String(0))
                        readSerial.beltStop()
                    }
                    //如果speedSpinBox的值不等于零，可以直接令其为零，触发SpinBox中的槽函数进行翻转和停止
                    else{
                        speedSpinBox.value = 0
                    }
                }
            }
        }

        Button {
            id: calibrationButton_200g
            y: 265
            width: 100
            text: qsTr("200克校准")
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.top: speedSpinBox.bottom
            anchors.topMargin: 20
            font.family: roboto_regular.name
            Material.background: Material.Blue
            Material.elevation: 0
            onClicked: {
                readSerial.calibration("200")
            }
        }

        Button {
            id: calibrationButton_0g
            width: 100
            text: qsTr("零点校准")
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.top: calibrationButton_200g.bottom
            anchors.topMargin: 10
            font.family: roboto_regular.name
            Material.background: Material.Blue
            Material.elevation: 0
            onClicked: {
                readSerial.calibration("0")
            }
        }

        FontLoader{
            id:noto_thin
            source: "qrc:/Font/NotoSansCJK-Thin.ttc"

        }

        FontLoader{
            id:roboto_regular
            source: "qrc:/Font/Roboto-Regular.ttf"
        }

        Button {
            id: dynamic_cal
            x: 128
            width: 100
            height: 48
            text: qsTr("动态校准")
            anchors.top: speedSpinBox.bottom
            anchors.topMargin: 20
            anchors.right: parent.right
            anchors.rightMargin: 10
            font.family: roboto_regular.name
            Material.background: Material.Blue
            Material.elevation: 0
            onClicked: {
                readSerial.dynamic_cal()
            }
        }

        RadioButton {
            id: single_photocell
            x: 160
            width: 100
            height: 48
            text: qsTr("单光电")
            anchors.right: parent.right
            anchors.rightMargin: 10
            anchors.top: double_photocell.bottom
            anchors.topMargin: 10
            onCheckedChanged: {
                if(checked === true){
                    readSerial.photocellSet("single")
                    console.log("single")
                }
            }
        }

        RadioButton {
            id: double_photocell
            x: 150
            width: 100
            text: qsTr("双光电")
            checked: true
            anchors.right: parent.right
            anchors.rightMargin: 10
            anchors.top: dynamic_cal.bottom
            anchors.topMargin: 10
            onCheckedChanged: {
                if(checked === true){
                    readSerial.photocellSet("double")
                    console.log("double")
                }
            }

        }

        Switch {
            id: fitting_button
            height: 48
            text: qsTr("两点拟合")
            anchors.left: start_button.left
            anchors.leftMargin: 0
            anchors.right: parent.right
            anchors.rightMargin: 10
            anchors.top: control_title.bottom
            anchors.topMargin: 10

            onCheckedChanged: {
                if(checked === true){
                    readSerial.newton()
                    fitting_button.text = "牛顿拟合"
                }
                else{
                    readSerial.linear()
                    fitting_button.text = "两点拟合"
                }
            }
        }

        RangeSlider {
            id: rangeSlider
            x: 10
            y: 537
            width: 250
            height: 48
            first.value: 0.25
            second.value: 0.75

            Rectangle {
                id: rectangle
                x: 125
                y: -102
                width: 30
                height: 30
                color: "#e56464"

                Label {
                    id: label3
                    text: qsTr("30")
                    verticalAlignment: Text.AlignVCenter
                    horizontalAlignment: Text.AlignHCenter
                    font.pointSize: 11
                    anchors.fill: parent
                }
            }

        }


        Component.onCompleted:{
            readSerial.dataAvailable.connect(changeWeightValue)
        }

        function changeWeightValue(data){
            sum_number++;
            average_weight = (average_weight*(sum_number-1)+data)/sum_number
            max_weight = Math.max(max_weight,data)
            if(min_weight == 0){
                min_weight = data
            }
            else{
                min_weight = Math.min(min_weight,data)
            }

            weightValue.text = String(data.toFixed(1))
            moreInfo_model.setProperty(0,"data_value",String(sum_number.toFixed(0)))
            moreInfo_model.setProperty(1,"data_value",String(average_weight.toFixed(1)))
            moreInfo_model.setProperty(2,"data_value",String(max_weight.toFixed(1)))
            moreInfo_model.setProperty(3,"data_value",String(min_weight.toFixed(1)))
        }

    }

    ComboBox {
        id: measurePort_combo
        model: ListModel {
            id: measurePort_model
        }
        displayText: readSerial.connectedPort()
        width: 120
        anchors.left: chart.right
        anchors.leftMargin: 70
        anchors.top: parent.top
        anchors.topMargin: 15
        onActivated: {
            if(readSerial.resetPortName(currentText)){
                measurePort_combo.displayText = currentText
            }
            else{
                measurePort_combo.displayText = ""
            }
        }
    }

    ComboBox {
        id: speedPort_combo
        model: ListModel {
            id: speedPort_model
        }
        displayText: writeSerial.connectedPort()
        width: 120
        anchors.left: chart.right
        anchors.leftMargin: 70
        anchors.verticalCenter: chart.verticalCenter
        onActivated: {
            if(writeSerial.resetPortName(currentText)){
                speedPort_combo.displayText = currentText
            }
            else{
                speedPort_combo.displayText = ""
            }
        }
    }

    SpinBox {
        id: zeroSetting
        y: 161
        width: 120
        height: 48
        anchors.left: chart.right
        anchors.leftMargin: 70
        anchors.bottom: chart.bottom
        anchors.bottomMargin: 0
        editable: true
        stepSize: 10
        from:0
        to: 2100
        onValueChanged: {
            readSerial.zeroSetting(String(zeroSetting.value))
        }

        hoverEnabled: true

        ToolTip.timeout: 8000
        ToolTip.visible: hovered
        ToolTip.text: qsTr("操作流程：
1、机器静止状态下，使用4位半万用表测量传感器S+与S-两端电压值得Vs；
2、系统调零参数Vz=(Vs-1.2mv)*100")
    }

    ChartView{
        id:chart
        legend.visible: false

        property real pointX: 0
        property real pointY: 0

        objectName: "chart"
        anchors.right: parent.right
        anchors.rightMargin: 200
        anchors.left: control_panel.right
        anchors.leftMargin: 20
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 705
        anchors.top: parent.top
        anchors.topMargin: 15
        title: qsTr("重量")

        antialiasing: true


        animationOptions:ChartView.AllAnimations
        backgroundRoundness: 10


        ValueAxis{
            id: axisX
            min: 0
            max: 10
            tickCount: 6
            labelFormat: "%d"

        }
        ValueAxis{
            id: axisY
            min: -5
            max: 15
            tickCount: 5
            labelFormat: "%d"
        }


        LineSeries{
            id:line
            useOpenGL:true
            axisX:  axisX
            axisY:  axisY
            objectName: "line"
        }
    }

    Rectangle {
        id: moreInfo
        x: 20
        y: 270
        color: "#ffffff"
        radius: 10
        anchors.top: chart.bottom
        //anchors.top: slider.bottom
        anchors.topMargin: 10
        anchors.right: parent.right
        anchors.rightMargin: 10
        z: 1
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 400
        anchors.left: control_panel.right
        anchors.leftMargin: 20
        border.color: "#8ebff1"

        Rectangle {
            id: rectangle4
            clip: true
            width: 440
            color: "white"
            anchors.right: parent.right
            anchors.rightMargin: 10
            anchors.left: parent.left
            anchors.leftMargin: 10
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 10
            anchors.top: parent.top
            anchors.topMargin: 10

            ListView {
                id: listView
                anchors.fill: parent
                delegate: Rectangle {
                    id: dataElement
                    width: parent.width
                    height: 40
                    color: background_color

                    MouseArea{
                        anchors.fill: parent
                        hoverEnabled: true
                        onEntered: {
                            dataElement.color = "#448aff"
                        }
                        onExited: {
                            dataElement.color = background_color
                        }

                    }

                    Text {
                        id: dataName
                        width: implicitWidth
                        text: data_name
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 10
                        anchors.top: parent.top
                        anchors.topMargin: 10
                        anchors.left: parent.left
                        anchors.leftMargin: 10
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCente
                        font.pixelSize: 12
                    }

                    Text {
                        id: dataValue
                        width: 88
                        height: implicitHeight
                        text: data_value
                        anchors.horizontalCenterOffset: 60
                        anchors.horizontalCenter: parent.horizontalCenter
                        anchors.verticalCenterOffset: 0
                        anchors.left: dataIcon.right
                        anchors.leftMargin: 10
                        anchors.verticalCenter: parent.verticalCenter
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        font.family: "Courier"
                        font.pixelSize: 12
                    }

                    Image {
                        id: dataIcon
                        width: 30
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 5
                        anchors.top: parent.top
                        anchors.topMargin: 5
                        anchors.left: parent.left
                        anchors.leftMargin: 90
                        fillMode: Image.PreserveAspectFit
                        source: icon_source
                    }

                    Text {
                        id: unit
                        x: 399
                        width: implicitWidth
                        height: 48
                        text: unit_name
                        anchors.bottom: parent.bottom
                        anchors.bottomMargin: 10
                        anchors.top: parent.top
                        anchors.topMargin: 10
                        anchors.right: parent.right
                        anchors.rightMargin: 10
                        verticalAlignment: Text.AlignVCenter
                        horizontalAlignment: Text.AlignHCenter
                        font.pixelSize: 12
                    }
                }

                model: ListModel{
                    id:moreInfo_model
                    ListElement{
                        background_color:"#f8f8f8"
                        data_name:"总数"
                        data_value:"0"
                        icon_source:""
                        unit_name:"个"
                    }
                    ListElement{
                        background_color:"#f1f1f1"
                        data_name:"平均值"
                        data_value:"0"
                        icon_source:""
                        unit_name:"g"
                    }
                    ListElement{
                        background_color:"#f8f8f8"
                        data_name:"最大值"
                        data_value:"0"
                        icon_source:""
                        unit_name:"g"
                    }
                    ListElement{
                        background_color:"#f1f1f1"
                        data_name:"最小值"
                        data_value:"0"
                        icon_source:""
                        unit_name:"g"
                    }
                    ListElement{
                        background_color:"#f8f8f8"
                        data_name:"合格率"
                        data_value:"100"
                        icon_source:""
                        unit_name:"%"
                    }
                    ListElement{
                        background_color:"#f1f1f1"
                        data_name:"不合格数"
                        data_value:"0"
                        icon_source:""
                        unit_name:"个"
                    }
                    ListElement{
                        background_color:"#f8f8f8"
                        data_name:"合格数"
                        data_value:"0"
                        icon_source:""
                        unit_name:"个"
                    }
                }
            }
        }
    }

    Label {
        id: label
        width:implicitWidth
        height: implicitHeight
        text: qsTr("测量串口")
        anchors.right: measurePort_combo.left
        anchors.rightMargin: 10
        anchors.verticalCenter: measurePort_combo.verticalCenter
    }

    Label {
        id: label1
        width: implicitWidth
        height: implicitHeight
        text: qsTr("调速串口")
        anchors.verticalCenter: speedPort_combo.verticalCenter
        anchors.right: speedPort_combo.left
        anchors.rightMargin: 10
    }

    Label {
        id: label2
        width: implicitWidth
        height: implicitHeight
        text: qsTr("系统调零")
        anchors.verticalCenter: zeroSetting.verticalCenter
        anchors.right: zeroSetting.left
        anchors.rightMargin: 10

    }




    Component.onCompleted:{
        readSerial.dataAvailable.connect(addData)
        var list = readSerial.availablePort()
        for(var i=0;i<list.length;i++){
            measurePort_model.append({text:list[i]})
            speedPort_model.append({text:list[i]})
        }
    }


    function addData(data){
        var value = data
        chart.pointY = value
        if(chart.pointX>axisX.max){
            axisX.max *= 2
        }
        if(chart.pointY>axisY.max){
            axisY.max = (chart.pointY/10+1)*10
        }
        if(chart.pointY<axisY.min){
            axisY.min = (chart.pointY/10-1)*10
        }

        line.append(chart.pointX,chart.pointY)
        chart.pointX++;
    }
}









































/*##^## Designer {
    D{i:24;anchors_y:367}D{i:25;anchors_y:367}D{i:26;anchors_x:150;anchors_y:483}D{i:27;anchors_width:100;anchors_x:150;anchors_y:425}
D{i:30;anchors_x:-125;anchors_y:102}D{i:28;anchors_x:627;anchors_y:0}D{i:32;anchors_x:927}
D{i:31;anchors_x:927;anchors_y:0}D{i:34;anchors_x:927}D{i:33;anchors_x:927}D{i:35;anchors_x:927}
}
 ##^##*/
