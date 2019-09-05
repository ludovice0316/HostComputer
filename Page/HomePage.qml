import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.5
import QtQuick.Controls.Material 2.3
import QtGraphicalEffects 1.12
import QtCharts 2.3

Page{
    id: homePage
    width: 1080
    height: 600
    Rectangle{
        id:background
        anchors.fill: parent
        color: "#eff3f6"
    }

    Rectangle {
        id: control_panel

        property real sum_number: 0
        property real average_weight: 0
        property real max_weight: 0
        property real min_weight: 0
        property real passed_ratio: 100
        property real passed_number: 0
        property real failed_number: 0
        property real current_weight: 0
        property real upper_limit: 10
        property real lower_limit: 0

        //左侧动画
        Behavior on max_weight {
            PropertyAnimation{
                duration: 100
            }
        }
        Behavior on average_weight {
            PropertyAnimation{
                duration: 100
            }
        }
        Behavior on min_weight {
            PropertyAnimation{
                duration: 100
            }
        }
        Behavior on current_weight {
            PropertyAnimation{
                duration: 100
            }
        }

        //右侧动画
        Behavior on passed_ratio {
            PropertyAnimation{
                duration: 100
            }
        }
//        Behavior on passed_number {
//            PropertyAnimation{
//                duration: 100
//            }
//        }
//        Behavior on failed_number {
//            PropertyAnimation{
//                duration: 100
//            }
//        }
//        Behavior on sum_number {
//            PropertyAnimation{
//                duration: 100
//            }
//        }


        width: parent.width/4
        radius: 2
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 30
        anchors.left: parent.left
        anchors.leftMargin: 10
        anchors.top: parent.top
        anchors.topMargin: 20


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
                id: controlPanel_title
                width: implicitWidth
                height: implicitHeight
                text: qsTr("控制面板")
                anchors.left: parent.left
                anchors.leftMargin: 10
                anchors.verticalCenter: parent.verticalCenter
                lineHeight: 0.9
                font.family: noto_light.name
                font.pixelSize: 24
            }
        }

        Image {
            id: speed_panel
            width: Math.min(parent.height,parent.width)*2/5
            height: width
            anchors.top: control_title.bottom
            anchors.topMargin: 25
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
                    anchors.topMargin: 20
                    font.pixelSize: 20
                    font.family: roboto_thin.name
                    color: "#036eb8"
                }
            }
        }

        Label {
            id: max
            y: 258
            width: implicitWidth
            height: (speed_panel.height-30)/4
            color: "#515151"
            text: qsTr("上限值")
            anchors.bottom: speedSpinBox.top
            anchors.bottomMargin: 20
            anchors.horizontalCenter: speedSpinBox.horizontalCenter
            lineHeight: 0.8
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font.pointSize: 12
            font.family: noto_light.name
        }

        Label {
            id: min
            width: implicitWidth
            height: max.height
            color: "#515151"
            text: qsTr("下限值")
            anchors.horizontalCenter: speed.horizontalCenter
            anchors.top: max.top
            anchors.topMargin: 0
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pointSize: 12
            font.family: noto_light.name
        }

        Label {
            id: speed
            width: implicitWidth
            height: max.height
            color: "#515151"
            text: qsTr("电机速度")
            anchors.top: parent.top
            anchors.topMargin: 305
            anchors.left: parent.left
            anchors.leftMargin: 32
            verticalAlignment: Text.AlignVCenter
            horizontalAlignment: Text.AlignHCenter
            font.pointSize: 12
            font.family: noto_light.name

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
            x: 160
            width: 100
            height: 48
            text: qsTr("清空数据")
            anchors.right: parent.right
            anchors.rightMargin: 21
            anchors.top: parent.top
            anchors.topMargin: 480
            font.family: noto_light.name
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
                control_panel.upper_limit = 10
                control_panel.lower_limit = 0
                control_panel.current_weight = 0

                //将曲线图置零
                passed_scatter.clear()
                failed_scatter.clear()

                lower_line.clear()
                lower_line.append(axisX.min,0)
                lower_line.append(axisX.max,0)
                lowerLimit.text = "0.0"

                upper_line.clear()
                upper_line.append(axisX.min,10)
                upper_line.append(axisX.max,10)
                upperLimit.text = "10.0"

                //还原XY轴初始设置
                axisX.max = 41
                chart.pointX = 1

                axisY.max = 12.5
                axisY.min = -2.5
            }
        }

        Button {
            property bool mycheck: false
            x: 142
            width: 120
            height: 50

            id: start_button
            text: qsTr("启动")
            anchors.top: speedPort_combo.bottom
            anchors.leftMargin: 0
            anchors.right: parent.right
            anchors.rightMargin: 8
            anchors.topMargin: 0
            font.pointSize: 10
            spacing: 4
            font.family: noto_light.name
            Material.background:Material.Blue
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
                    Material.background = "#d81e06"
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
            width: 100
            text: qsTr("200克校准")
            anchors.left: parent.left
            anchors.leftMargin: 14
            anchors.top: parent.top
            anchors.topMargin: 480
            font.family: noto_light.name
            Material.background: Material.Blue
            Material.elevation: 0
            onClicked: {
                readSerial.calibration("200")
            }
        }

        Button {
            id: calibrationButton_0g
            width: 100
            text: qsTr("0克校准")
            anchors.left: parent.left
            anchors.leftMargin: 14
            anchors.top: parent.top
            anchors.topMargin: 430
            font.family: noto_light.name
            Material.background: Material.Blue
            Material.elevation: 0
            onClicked: {
                readSerial.calibration("0")
            }
        }


        FontLoader{
            id:roboto_thin
            source: "qrc:/Font/Roboto-Thin.ttf"
        }

        FontLoader{
            id:roboto_regular
            source: "qrc:/Font/Roboto-Regular.ttf"
        }


        FontLoader{
            id:noto_light
            source: "qrc:/Font/NotoSansSC-Light.otf"
        }

        FontLoader{
            id:noto_bold
            source: "qrc:/Font/NotoSansSC-Bold.otf"
        }

        ButtonGroup{
            id:photocell
        }

        ComboBox {
            id: measurePort_combo
            width: 120
            model: ListModel {
                id: measurePort_model
            }
            font.family: noto_light.name
            displayText:"测量串口"
            height: 48
            anchors.right: control_panel.right
            anchors.rightMargin: 10
            anchors.top: parent.top
            anchors.topMargin: 65
            onActivated: {
                if(readSerial.resetPortName(currentText)){
                    measurePort_combo.displayText = currentText
                }
                else{
                    measurePort_combo.displayText = "测量串口"
                }
            }
        }

        ComboBox {
            id: speedPort_combo
            font.family: noto_light.name
            model: ListModel {
                id: speedPort_model
            }
            displayText: "调速串口"
            width: 120
            height: 48
            anchors.right: control_panel.right
            anchors.rightMargin: 10
            anchors.top: measurePort_combo.bottom
            anchors.topMargin: 0
            onActivated: {
                if(writeSerial.resetPortName(currentText)){
                    speedPort_combo.displayText = currentText
                }
                else{
                    speedPort_combo.displayText = "调速串口"
                }
            }
        }

        RadioButton {
            id: single_photocell
            x: 142
            width: 100
            height: 48
            text: qsTr("单光电")
            anchors.right: parent.right
            anchors.rightMargin: 21
            anchors.top: parent.top
            anchors.topMargin: 340
            font.family: noto_light.name
            onCheckedChanged: {
                if(checked === true){
                    readSerial.photocellSet("single")
                }
            }
            ButtonGroup.group: photocell
        }

        RadioButton {
            id: double_photocell
            width: 100
            text: qsTr("双光电")
            anchors.left: parent.left
            anchors.leftMargin: 14
            anchors.top: parent.top
            anchors.topMargin: 340
            autoRepeat: false
            checked: true
            font.family: noto_light.name
            onCheckedChanged: {
                if(checked === true){
                    readSerial.photocellSet("double")
                }
            }
            ButtonGroup.group: photocell
        }

        ButtonGroup{
            id:fitting
        }

        RadioButton {
            id: newton
            x: 142
            width: 100
            height: 49
            text: qsTr("牛顿拟合")
            anchors.right: parent.right
            anchors.rightMargin: 21
            anchors.top: parent.top
            anchors.topMargin: 370
            ButtonGroup.group: fitting
            font.family: noto_light.name
            onCheckedChanged: {
                if(checked === true){
                    readSerial.linear()
                }
            }
        }

        RadioButton {
            id: twoPoint
            width: 100
            text: qsTr("两点拟合")
            anchors.left: parent.left
            anchors.leftMargin: 14
            anchors.top: parent.top
            anchors.topMargin: 370
            checked: true
            ButtonGroup.group: fitting
            font.family: noto_light.name
            onCheckedChanged: {
                if(checked === true){
                    readSerial.linear()
                }
            }
        }

        Button {
            id: dynamic_cal
            width: 100
            height: 48
            text: qsTr("动态校准")
            anchors.right: parent.right
            anchors.rightMargin: 21
            anchors.top: parent.top
            anchors.topMargin: 430
            font.family: noto_light.name
            Material.background: Material.Blue
            Material.elevation: 0
            onClicked: {
                readSerial.dynamic_cal()
            }
        }

        TextField {
            id: lowerLimit
            width: 64
            height: 50
            text: qsTr("0.0")
            topPadding: 8
            bottomPadding: 16
            anchors.bottom: min.top
            anchors.bottomMargin: 0
            anchors.horizontalCenter: min.horizontalCenter
            horizontalAlignment: Text.AlignHCenter
            font.family: noto_bold.name
            font.pixelSize: 18
            color: "#d81e06"

            Component.onCompleted: {
                var lower = Number(text).toFixed(1)
                text = String(lower)
                control_panel.lower_limit = lower
                lower_line.clear()
                lower_line.append(axisX.min,lower)
                lower_line.append(axisX.max,lower)
            }

            onAccepted: {
                var lower = Number(text).toFixed(1)
                text = String(lower)
                control_panel.lower_limit = lower
                lower_line.clear()
                lower_line.append(axisX.min,lower)
                lower_line.append(axisX.max,lower)
            }
        }

        TextField {
            id: upperLimit
            width: 64
            height: 50
            text: qsTr("10.0")
            anchors.bottom: max.top
            anchors.bottomMargin: 0
            anchors.horizontalCenter: max.horizontalCenter
            horizontalAlignment: Text.AlignHCenter
            font.family: noto_bold.name
            font.pixelSize: 18
            color: "#d81e06"

            Component.onCompleted: {
                var upper = Number(text).toFixed(1)
                text = String(upper)
                control_panel.upper_limit = upper
                upper_line.clear()
                upper_line.append(axisX.min,control_panel.upper_limit)
                upper_line.append(axisX.max,control_panel.upper_limit)
            }

            onAccepted: {
                var upper = Number(text).toFixed(1)
                text = String(upper)
                control_panel.upper_limit = upper
                upper_line.clear()
                upper_line.append(axisX.min,control_panel.upper_limit)
                upper_line.append(axisX.max,control_panel.upper_limit)
            }
        }



        Component.onCompleted:{
            readSerial.dataAvailable.connect(changeWeightValue)
        }

        function changeWeightValue(data){

            if(start_button.mycheck === false){
                return
            }

            var newSum = sum_number+1

            var newAverage = (average_weight*(newSum-1)+data)/(newSum)

            var newMax = Math.max(max_weight,data)

            var newMin
            if(min_weight == 0){
                newMin = data
            }
            else{
                newMin = Math.min(min_weight,data)
            }

            var newPassedNum = passed_number
            var newFailedNum = failed_number
            if(data<control_panel.upper_limit&&data>control_panel.lower_limit){
                newPassedNum = passed_number+1
            }
            else{
                newFailedNum = failed_number+1
            }

            var newPassedRatio
            newPassedRatio = (newPassedNum/(newSum))*100

            //给右侧显示card重新赋值
            sum_number = newSum
            passed_number = newPassedNum
            failed_number = newFailedNum
            passed_ratio = newPassedRatio
            //给左侧显示card重新赋值
            current_weight = data
            min_weight = newMin
            max_weight = newMax
            average_weight = newAverage
        }

    }

    ChartView{
        id:chart
        legend.font: noto_bold.name
        property real pointX: 1
        property real pointY: 0
        x: 288
        y: 196

        width: 784
        height: 384

        antialiasing: true


        animationOptions:ChartView.AllAnimations
        backgroundRoundness: 10


        ValueAxis{
            id: axisX
            min: 1
            max: 41
            tickCount: 6
            labelFormat: "%d"
            labelsFont: noto_bold.name
        }
        ValueAxis{
            id: axisY
            min: control_panel.lower_limit-(control_panel.upper_limit-control_panel.lower_limit)/4
            max: control_panel.upper_limit+(control_panel.upper_limit-control_panel.lower_limit)/4
            tickCount: 7
            labelsFont: noto_bold.name
        }

        ScatterSeries{
            id:passed_scatter
            name:"合格"
            useOpenGL: true
            axisX:  axisX
            axisY:  axisY
            markerSize: 8
        }

        ScatterSeries{
            id:failed_scatter
            name:"不合格"
            useOpenGL: true
            axisX:  axisX
            axisY:  axisY
            color: "#F44336"
            markerSize: 8
        }

        LineSeries{
            id:upper_line
            useOpenGL:true
            axisX:  axisX
            axisY:  axisY
            color: "#F44336"
        }

        LineSeries{
            id:lower_line
            useOpenGL:true
            axisX:  axisX
            axisY:  axisY
            color: "#F44336"
        }
    }

    Rectangle {
        id: minCard
        x: 296
        y: 106
        width: 170
        height: 80
        color: "#ffffff"
        radius: 10
        anchors.top: parent.top
        anchors.topMargin: 110
        anchors.left: parent.left
        anchors.leftMargin: 288

        Image {
            id: minIcon
            x: -287
            y: 22
            width: 40
            height: 40
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 15
            source: "qrc:/Icon/Min.png"
            fillMode: Image.PreserveAspectFit
        }

        Text {
            id: minValue
            color: "#000000"
            text: qsTr(control_panel.min_weight.toFixed(1)+"")
            anchors.horizontalCenter: minDiscribe.horizontalCenter
            anchors.bottom: minDiscribe.top
            anchors.bottomMargin: 0
            font.family: noto_bold.name
            font.pixelSize: 24
        }

        Text {
            id: minDiscribe
            text: qsTr("最小值")
            anchors.right: parent.right
            anchors.rightMargin: 40
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 15
            font.family: noto_light.name
            font.pixelSize: 16
            width:implicitWidth
            height:implicitHeight
            color: (control_panel.lower_limit<control_panel.min_weight&&control_panel.min_weight<control_panel.upper_limit)?"#1296db":"#d81e06"
        }

        Text {
            id: minUnit
            color: "#000000"
            text: qsTr("g")
            font.family: noto_bold.name
            anchors.verticalCenter: minValue.verticalCenter
            anchors.left: minValue.right
            anchors.leftMargin: 5
            font.pixelSize: 24
        }
    }

    Rectangle {
        id: averageCard
        x: 464
        y: 20
        width: 170
        height: 80
        color: "#ffffff"
        radius: 10
        Image {
            id: averageIcon
            y: 24
            width: 40
            height: 40
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 15
            source: "qrc:/Icon/Average.png"
            fillMode: Image.PreserveAspectFit
        }

        Text {
            id: averageValue
            color: "#000000"
            text: qsTr(control_panel.average_weight.toFixed(1)+"")
            anchors.bottom: averageDiscribe.top
            anchors.bottomMargin: 0
            anchors.horizontalCenter: averageDiscribe.horizontalCenter
            font.family: noto_bold.name
            font.pixelSize: 24
        }

        Text {
            id: averageDiscribe
            y: 139
            width: implicitWidth
            height: implicitHeight
            color: (control_panel.lower_limit<control_panel.average_weight&&control_panel.average_weight<control_panel.upper_limit)?"#1296db":"#d81e06"
            text: qsTr("平均值")
            anchors.right: parent.right
            anchors.rightMargin: 40
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 15
            font.family: noto_light.name
            font.pixelSize: 16
        }

        Text {
            id: averageUnit
            color: "#000000"
            text: qsTr("g")
            anchors.left: averageValue.right
            anchors.leftMargin: 5
            anchors.verticalCenter: averageValue.verticalCenter
            font.pixelSize: 24
            font.family: noto_bold.name
        }
    }

    Rectangle {
        id: maxCard
        x: 288
        y: 20
        width: 170
        height: 80
        color: "#ffffff"
        radius: 10
        Image {
            id: maxIcon
            y: 23
            width: 40
            height: 40
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            anchors.leftMargin: 15
            source: "qrc:/Icon/Max.png"
            fillMode: Image.PreserveAspectFit
        }

        Text {
            id: maxValue
            color: "#000000"
            text: qsTr(control_panel.max_weight.toFixed(1)+"")
            anchors.bottom: maxDiscribe.top
            anchors.bottomMargin: 0
            anchors.horizontalCenter: maxDiscribe.horizontalCenter
            font.family: noto_bold.name
            font.pixelSize: 24
        }

        Text {
            id: maxDiscribe
            width: implicitWidth
            height: implicitHeight
            color: (control_panel.lower_limit<control_panel.max_weight&&control_panel.max_weight<control_panel.upper_limit)?"#1296db":"#d81e06"
            text: qsTr("最大值")
            anchors.right: parent.right
            anchors.rightMargin: 40
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 15
            font.family: noto_light.name
            font.pixelSize: 16
        }

        Text {
            id: maxUnit
            y: 13
            color: "#000000"
            text: qsTr("g")
            anchors.left: maxValue.right
            anchors.leftMargin: 5
            anchors.verticalCenter: maxValue.verticalCenter
            font.pixelSize: 24
            font.family: noto_bold.name
        }
    }

    Rectangle {
        id: sumCard
        x: 899
        width: 170
        height: 80
        color: "#ffffff"
        radius: 10
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.top: passedCard.bottom
        anchors.topMargin: 10
        Image {
            id: sumIcon
            y: 19
            width: 35
            height: 35
            anchors.verticalCenterOffset: 0
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            source: "qrc:/Icon/Sum.png"
            anchors.leftMargin: 15
            fillMode: Image.PreserveAspectFit
        }

        Text {
            id: sumValue
            color: "#000000"
            text: qsTr(control_panel.sum_number.toFixed(0)+"")
            anchors.bottom: sumDiscribe.top
            anchors.bottomMargin: 0
            anchors.horizontalCenter: sumDiscribe.horizontalCenter
            font.family: noto_bold.name
            font.pixelSize: 24
        }

        Text {
            id: sumDiscribe
            x: 90
            y: 31
            width: implicitWidth
            height: implicitHeight
            color: "#1296db"
            text: qsTr("总数")
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 15
            anchors.right: parent.right
            anchors.rightMargin: 48
            font.family: noto_light.name
            font.pixelSize: 16
        }
    }

    Rectangle {
        id: failedCard
        x: 720
        width: 170
        height: 80
        color: "#ffffff"
        radius: 10
        anchors.right: sumCard.left
        anchors.rightMargin: 10
        anchors.top: ratioCard.bottom
        anchors.topMargin: 10
        Image {
            id: failedIcon
            y: 24
            width: 48
            height: 48
            anchors.left: parent.left
            anchors.leftMargin: 15
            anchors.verticalCenter: parent.verticalCenter
            source: "qrc:/Icon/Failed.png"
            fillMode: Image.PreserveAspectFit
        }

        Text {
            id: failedValue
            x: 123
            y: 8
            color: "#000000"
            text: qsTr(control_panel.failed_number.toFixed(0)+"")
            anchors.bottom: failedDiscribe.top
            anchors.bottomMargin: 0
            anchors.horizontalCenter: failedDiscribe.horizontalCenter
            font.family: noto_bold.name
            font.pixelSize: 24
        }

        Text {
            id: failedDiscribe
            x: 78
            y: 45
            width: implicitWidth
            height: implicitHeight
            color: "#d81e06"
            text: qsTr("不合格数")
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 15
            anchors.right: parent.right
            anchors.rightMargin: 30
            font.family: noto_light.name
            font.pixelSize: 16
        }
    }

    Rectangle {
        id: ratioCard
        x: 679
        width: 170
        height: 80
        color: "#ffffff"
        radius: 10
        anchors.top: parent.top
        anchors.topMargin: 20
        anchors.right: passedCard.left
        anchors.rightMargin: 10
        border.color: "#ffffff"
        Image {
            id: ratioIcon
            y: 24
            width: 48
            height: 48
            anchors.left: parent.left
            anchors.leftMargin: 15
            anchors.verticalCenter: parent.verticalCenter
            source: "qrc:/Icon/Ratio.png"
            fillMode: Image.PreserveAspectFit
        }

        Text {
            id: ratioValue
            color: "#000000"
            text: qsTr(control_panel.passed_ratio.toFixed(1)+"")
            anchors.bottom: ratioDiscribe.top
            anchors.bottomMargin: 0
            anchors.horizontalCenterOffset: 0
            font.family: noto_bold.name
            font.pixelSize: 24
            anchors.horizontalCenter: ratioDiscribe.horizontalCenter
        }

        Text {
            id: ratioDiscribe
            width: implicitWidth
            height: implicitHeight
            color: "#1296db"
            text: qsTr("合格率")
            anchors.right: parent.right
            anchors.rightMargin: 40
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 15
            font.family: noto_light.name
            font.pixelSize: 16
        }

        Text {
            id: ratioUnit
            color: "#000000"
            text: qsTr("%")
            anchors.verticalCenterOffset: 0
            anchors.left: ratioValue.right
            anchors.leftMargin: 5
            anchors.verticalCenter: ratioValue.verticalCenter
            font.pixelSize: 24
            font.family: noto_bold.name
        }
    }

    Rectangle {
        id: passedCard
        width: 170
        height: 80
        color: "#ffffff"
        radius: 10
        anchors.right: parent.right
        anchors.rightMargin: 10
        anchors.top: parent.top
        anchors.topMargin: 20
        border.color: "#ffffff"
        Image {
            id: passedIcon
            width: 48
            height: 48
            anchors.left: parent.left
            anchors.leftMargin: 15
            anchors.verticalCenter: parent.verticalCenter
            source: "qrc:/Icon/Passed.png"
            fillMode: Image.PreserveAspectFit
        }

        Text {
            id: passedValue
            color: "#000000"
            text: qsTr(control_panel.passed_number.toFixed(0)+"")
            anchors.bottom: passedDiscribe.top
            anchors.bottomMargin: 0
            anchors.horizontalCenter: passedDiscribe.horizontalCenter
            font.family: noto_bold.name
            font.pixelSize: 24
        }

        Text {
            id: passedDiscribe
            width: implicitWidth
            height: implicitHeight
            color: "#1296db"
            text: qsTr("合格数")
            anchors.right: parent.right
            anchors.rightMargin: 40
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 15
            font.family: noto_light.name
            font.pixelSize: 16
        }
    }

    Rectangle {
        id: weightCard
        width: 170
        height: 80
        color: "#ffffff"
        radius: 10
        anchors.left: parent.left
        anchors.top: parent.top
        anchors.leftMargin: 464
        anchors.topMargin: 110

        Image {
            id: weightIcon
            width: 48
            height: 48
            fillMode: Image.PreserveAspectFit
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: parent.left
            source: "qrc:/Icon/dash.png"
            anchors.leftMargin: 8
        }

        Text {
            id: weightValue
            color: "#000000"
            text: qsTr(control_panel.current_weight.toFixed(1)+"")
            anchors.bottom: weightDiscribe.top
            anchors.bottomMargin: 0
            anchors.horizontalCenterOffset: 0
            font.family: noto_bold.name
            font.pixelSize: 24
            anchors.horizontalCenter: weightDiscribe.horizontalCenter
        }

        Text {
            id: weightDiscribe
            width: implicitWidth
            height: 24
            color: (control_panel.lower_limit<Number(weightValue.text)&&Number(weightValue.text)<control_panel.upper_limit)?"#1296db":"#d81e06"
            text: qsTr("重量")
            anchors.right: parent.right
            anchors.rightMargin: 48
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 14
            font.family: noto_light.name
            font.pixelSize: 16
        }

        Text {
            id: weightUnit
            color: "#000000"
            text: qsTr("g")
            anchors.verticalCenterOffset: 0
            anchors.left: weightValue.right
            anchors.verticalCenter: weightValue.verticalCenter
            anchors.leftMargin: 5
            font.family: noto_bold.name
            font.pixelSize: 24
        }
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
        if(start_button.mycheck === false){
            return
        }

        var value = data
        chart.pointY = value
        if(chart.pointX>axisX.max){
            axisX.max += 40
            upper_line.append(axisX.max,control_panel.upper_limit)
            lower_line.append(axisX.max,control_panel.lower_limit)
        }
        if(control_panel.lower_limit<chart.pointY&&chart.pointY<control_panel.upper_limit){
            passed_scatter.append(chart.pointX,chart.pointY)
            chart.pointX++;
        }
        else if(chart.pointY>=control_panel.upper_limit){
            if(chart.pointY>axisY.max){
                axisY.max = Math.ceil(chart.pointY)
            }
            failed_scatter.append(chart.pointX,chart.pointY)
            chart.pointX++;
        }
        else if(chart.pointY<=control_panel.lower_limit){
            if(chart.pointY<axisY.min){
                axisY.min = Math.floor(chart.pointY)
            }
            failed_scatter.append(chart.pointX,chart.pointY)
            chart.pointX++;
        }
    }
}




























































































































/*##^## Designer {
    D{i:12;anchors_y:305}D{i:14;anchors_x:160;anchors_y:157}D{i:15;anchors_x:160;anchors_y:157}
D{i:16;anchors_x:160;anchors_y:157}D{i:17;anchors_x:160;anchors_y:157}D{i:18;anchors_x:160;anchors_y:157}
D{i:19;anchors_x:8;anchors_y:482}D{i:20;anchors_x:8;anchors_y:482}D{i:22;anchors_width:119;anchors_x:927;anchors_y:0}
D{i:24;anchors_width:119;anchors_x:927;anchors_y:0}D{i:23;anchors_width:119;anchors_x:927;anchors_y:0}
D{i:26;anchors_width:119;anchors_x:927;anchors_y:0}D{i:25;anchors_width:119;anchors_x:927;anchors_y:0}
D{i:27;anchors_x:927;anchors_y:319}D{i:28;anchors_x:927;anchors_y:319}D{i:29;anchors_x:927;anchors_y:319}
D{i:30;anchors_x:6;anchors_y:319}D{i:31;anchors_y:363}D{i:32;anchors_height:100;anchors_width:100;anchors_y:363}
D{i:33;anchors_y:363}D{i:34;anchors_height:100;anchors_width:100;anchors_y:270}D{i:36;anchors_height:100;anchors_width:100;anchors_y:270}
D{i:37;anchors_height:100;anchors_width:100;anchors_y:270}D{i:38;anchors_height:100;anchors_width:100;anchors_y:270}
D{i:39;anchors_height:100;anchors_width:100}D{i:40;anchors_y:270}D{i:41;anchors_x:105;anchors_y:270}
D{i:35;anchors_height:100;anchors_width:100;anchors_y:270}D{i:43;anchors_x:105;anchors_y:270}
D{i:44;anchors_x:105;anchors_y:270}D{i:45;anchors_x:105;anchors_y:0}D{i:46;anchors_x:54;anchors_y:8}
D{i:42;anchors_x:105;anchors_y:270}D{i:48;anchors_x:21;anchors_y:139}D{i:49;anchors_x:69;anchors_y:0}
D{i:50;anchors_x:105;anchors_y:0}D{i:51;anchors_x:8;anchors_y:8}D{i:47;anchors_x:21;anchors_y:139}
D{i:53;anchors_x:21;anchors_y:139}D{i:54;anchors_x:91;anchors_y:0}D{i:55;anchors_x:210;anchors_y:0}
D{i:56;anchors_x:8;anchors_y:8}D{i:52;anchors_x:21;anchors_y:139}D{i:58;anchors_x:21;anchors_y:139}
D{i:59;anchors_x:134;anchors_y:0}D{i:60;anchors_x:315;anchors_y:117}D{i:57;anchors_x:21;anchors_y:3}
D{i:62;anchors_x:21;anchors_y:139}D{i:63;anchors_x:21;anchors_y:139}D{i:64;anchors_x:420;anchors_y:110}
D{i:61;anchors_x:54;anchors_y:8}D{i:66;anchors_x:21;anchors_y:139}D{i:67;anchors_x:21;anchors_y:139}
D{i:68;anchors_x:525;anchors_y:20}D{i:69;anchors_x:54;anchors_y:8}D{i:65;anchors_x:54;anchors_y:8}
D{i:71;anchors_x:21;anchors_y:139}D{i:72;anchors_x:81;anchors_y:20}D{i:73;anchors_x:8;anchors_y:20}
D{i:70;anchors_x:8;anchors_y:139}D{i:75;anchors_x:105;anchors_y:0}D{i:76;anchors_height:24;anchors_x:105;anchors_y:0}
D{i:77;anchors_height:24;anchors_x:105;anchors_y:0}D{i:78;anchors_height:24;anchors_x:54;anchors_y:8}
D{i:74;anchors_x:8;anchors_y:20}
}
 ##^##*/
