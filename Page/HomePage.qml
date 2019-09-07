import QtQuick 2.12
import QtQuick.Window 2.12
import QtQuick.Controls 2.5
import QtQuick.Controls.Material 2.3
import QtGraphicalEffects 1.12
import QtCharts 2.3
import QtQuick.Layouts 1.12

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

        function popMessageDialog(){
            messageDialog.messageTitle = "设置错误！"
            messageDialog.messageIcon = "qrc:/Image/Setting.png"
            messageDialog.messageDetail = "请确认测量串口是否连接..."
            messageDialog.open()
        }

        //总数
        property real sum_number: 0
        //平均质量
        property real average_weight: 0
        //最值
        property real max_weight: 0
        property real min_weight: 0
        //合格相关数据
        property real passed_ratio: 100
        property real passed_number: 0
        property real failed_number: 0
        //本次测试重量
        property real current_weight: 0
        //上限值
        property real upper_limit:Number.MAX_VALUE
        //下限值
        property real lower_limit:-Number.MAX_VALUE

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


        width: parent.width/4
        radius: 2
        anchors.bottom: parent.bottom
        anchors.bottomMargin: 20
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
                color: "#ffffff"
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
                if(speedPort_combo.displayText === "调速串口"||measurePort_combo.displayText === "测量串口"){
                    messageDialog.messageTitle = "设置失败！"
                    messageDialog.messageIcon = "qrc:/Image/Setting.png"
                    messageDialog.messageDetail = "请确认打开调速串口后再设置速度"
                    messageDialog.open()
                    value = 0
                    return
                }

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
                control_panel.current_weight = 0

                //将曲线图置零
                if(start_button.mycheck === true){
                    passed_scatter.clear()
                    failed_scatter.clear()
                }
                else{
                    static_scatter.clear()

                    lower_line.clear()
                    upper_line.clear()
                }


                //还原XY轴初始设置
                axisX.max = 41
                chart.pointX = 1
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
                    //判断速度是否已设置
                    if(speedSpinBox.value === 0){
                        messageDialog.messageTitle = "启动失败！"
                        messageDialog.messageIcon = "qrc:/Image/Setting.png"
                        messageDialog.messageDetail = "请先设置速度"
                        messageDialog.open()
                        return
                    }
                    if(speedPort_combo.displayText === "调速串口"||measurePort_combo.displayText === "测量串口"){
                        messageDialog.messageTitle = "启动失败！"
                        messageDialog.messageIcon = "qrc:/Image/Setting.png"
                        messageDialog.messageDetail = "调速串口未连接..."
                        messageDialog.open()
                        return
                    }
                    if(control_panel.upper_limit === Number.MAX_VALUE||control_panel.lower_limit === -Number.MAX_VALUE){
                        messageDialog.messageTitle = "启动失败！"
                        messageDialog.messageIcon = "qrc:/Image/Setting.png"
                        messageDialog.messageDetail = "请先设置上限值和下限值..."
                        messageDialog.open()
                        return
                    }


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

                    //进入动态数据模式，绘制上下限线,Y轴的上下限和limit以及max min绑定好了
                    var upper =  control_panel.upper_limit
                    var lower = control_panel.lower_limit

                    lower_line.clear()
                    lower_line.append(axisX.min,lower)
                    lower_line.append(axisX.max,lower)

                    upper_line.clear()
                    upper_line.append(axisX.min,upper)
                    upper_line.append(axisX.max,upper)

                    static_scatter.clear()

                    control_panel.sum_number = 0
                    control_panel.average_weight = 0
                    control_panel.max_weight = 0
                    control_panel.min_weight = 0

                    control_panel.passed_number = 0
                    control_panel.passed_ratio = 100
                    control_panel.failed_number = 0
                    control_panel.current_weight = 0

                    //还原XY轴初始设置
                    axisX.max = 41
                    chart.pointX = 1

                }
                else{
                    timer.startAngle = timer.lastFrameAngle //按键按下，从此刻重新开始动画
                    timer.loops = 100 //把时间轴置0
                    timer.startAngle = timer.lastFrameAngle //上帧度数作为新动画的开始
                    timer.endAngle = -timer.startAngle //顺时针旋转deg度
                    timer.start()

                    //进入静态模式，关闭上下限线,清空数据
                    //将数据绑定的变量置零
                    control_panel.sum_number = 0
                    control_panel.average_weight = 0
                    control_panel.max_weight = 0
                    control_panel.min_weight = 0
                    control_panel.passed_number = 0
                    control_panel.passed_ratio = 100
                    control_panel.failed_number = 0
                    control_panel.current_weight = 0

                    //将曲线图置零
                    passed_scatter.clear()
                    failed_scatter.clear()
                    lower_line.clear()
                    upper_line.clear()

                    //还原XY轴初始设置
                    axisX.max = 41
                    chart.pointX = 1

                    //使进入静态测量模式，改变button样式
                    speedSpinBox.value = 0
                    start_button.mycheck = false
                    start_button.text = qsTr("启动")
                    start_button.Material.background = Material.Blue
                    writeSerial.stop()
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
                if(measurePort_combo.displayText === "测量串口"){
                    control_panel.popMessageDialog()
                    return
                }
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
                if(measurePort_combo.displayText === "测量串口"){
                    control_panel.popMessageDialog()
                    return
                }
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

        Dialog {
            id: messageDialog

            property string headerColor: "#1296db"
            property string messageTitle: "连接成功"
            property string messageDetail: "已与串口连接"
            property string messageIcon: "qrc:/Image/Setting.png"
            x: (homePage.width - width) / 2
            y: (homePage.height - height) / 2
            modal: true
            width: 350
            height: 260

            header: Rectangle{
                anchors.fill: parent
                color: "white"
                clip: true
                Rectangle{
                    id:messageHeader
                    anchors.top: parent.top
                    anchors.left: parent.left
                    width: messageDialog.width
                    height: 150
                    color: messageDialog.headerColor
                    Image {
                        id: messageDialogIcon
                        width: 64
                        height: 64
                        anchors.centerIn: parent
                        source: messageDialog.messageIcon
                    }
                }

                Text {
                    id: title
                    text: messageDialog.messageTitle
                    anchors.left: parent.left
                    anchors.leftMargin: 10
                    anchors.top: messageHeader.bottom
                    anchors.topMargin: 15
                    font.pixelSize: 28
                    font.family: noto_bold.name
                    color: "#707070"
                }

                Text {
                    id: detail
                    text: messageDialog.messageDetail
                    wrapMode: Text.WrapAnywhere
                    anchors.bottom: parent.bottom
                    anchors.bottomMargin: 15
                    anchors.right: parent.right
                    anchors.rightMargin: 15
                    anchors.left: parent.left
                    anchors.leftMargin: 15
                    anchors.top: title.bottom
                    anchors.topMargin: 10
                    font.pixelSize: 16
                    font.family: noto_light.name
                    color: "#707070"
                }
            }
        }


        ComboBox {
            id: measurePort_combo
            width: 120
            model: ListModel {
                id: measurePort_model
                ListElement{
                    text:"关闭串口"
                }
            }
            font.family: noto_light.name
            displayText:"测量串口"
            height: 48
            anchors.right: control_panel.right
            anchors.rightMargin: 10
            anchors.top: parent.top
            anchors.topMargin: 65

            onPressedChanged: {
                if(pressed === true){
                    var list = readSerial.availablePort()

                    measurePort_model.clear()
                    speedPort_model.clear()

                    measurePort_model.append({text:"关闭串口"})
                    speedPort_model.append({text:"关闭串口"})

                    for(var i=0;i<list.length;i++){
                        measurePort_model.append({text:list[i]})
                        speedPort_model.append({text:list[i]})
                    }
                }
            }

            onActivated: {
                if(currentIndex === 0){
                    //关闭测量串口
                    readSerial.close()

                    //修改dialog中显示内容
                    messageDialog.messageTitle = "已断开连接！"
                    messageDialog.messageIcon = "qrc:/Image/Connected.png"
                    if(measurePort_combo.displayText === "测量串口"){
                        messageDialog.messageDetail = "测量串口已断开连接..."
                    }
                    else{
                        messageDialog.messageDetail = "测量串口已从: " + measurePort_combo.displayText + "端口断开连接断开..."
                    }
                    //修改combox中显示内容
                    measurePort_combo.displayText = "测量串口"
                    messageDialog.open()
                }
                else{
                    if(readSerial.resetPortName(currentText)){
                        //修改dialog中的内容
                        messageDialog.messageTitle = "已成功连接！"
                        messageDialog.messageIcon = "qrc:/Image/Connected.png"
                        if(measurePort_combo.displayText === currentText){
                            messageDialog.messageDetail = "测量串口已与:"+currentText+"端口重新连接..."
                        }
                        else{
                            messageDialog.messageDetail = "测量串口已与: " + currentText+"端口成功连接..."
                        }

                        //修改combox中的内容
                        measurePort_combo.displayText = currentText
                        messageDialog.open()
                    }
                    else{
                        messageDialog.messageIcon = "qrc:/Image/Warning.png"
                        messageDialog.messageTitle = "连接失败!"
                        messageDialog.messageDetail = "请查看"+currentText+"端口是否被占用"
                        measurePort_combo.displayText = "测量串口"
                        messageDialog.open()
                    }
                }
            }
        }

        ComboBox {
            id: speedPort_combo
            font.family: noto_light.name
            model: ListModel {
                id: speedPort_model
                ListElement{
                    text:"关闭串口"
                }
            }
            displayText: "调速串口"
            width: 120
            height: 48
            anchors.right: control_panel.right
            anchors.rightMargin: 10
            anchors.top: measurePort_combo.bottom
            anchors.topMargin: 0

            onPressedChanged: {
                if(pressed === true){
                    var list = readSerial.availablePort()

                    measurePort_model.clear()
                    speedPort_model.clear()

                    measurePort_model.append({text:"关闭串口"})
                    speedPort_model.append({text:"关闭串口"})

                    for(var i=0;i<list.length;i++){
                        measurePort_model.append({text:list[i]})
                        speedPort_model.append({text:list[i]})
                    }
                }
            }

            onActivated: {
                if(currentIndex === 0){
                    //关闭调速串口
                    writeSerial.close()

                    //修改dialog中显示内容
                    messageDialog.messageTitle = "已断开连接！"
                    messageDialog.messageIcon = "qrc:/Image/Connected.png"
                    if(speedPort_combo.displayText === "调速串口"){
                        messageDialog.messageDetail = "调速串口已断开连接..."
                    }
                    else{
                        messageDialog.messageDetail = "调速串口已从: " + speedPort_combo.displayText + "端口断开连接断开..."
                    }

                    //修改combox中的内容
                    speedPort_combo.displayText = "调速串口"
                    messageDialog.open()
                }
                else{
                    if(writeSerial.resetPortName(currentText)){
                        //修改dialog中的内容
                        messageDialog.messageTitle = "已成功连接！"
                        messageDialog.messageIcon = "qrc:/Image/Connected.png"
                        if(speedPort_combo.displayText === currentText){
                            messageDialog.messageDetail = "调速串口已与: " + currentText+"端口重新连接..."
                        }
                        else{
                            messageDialog.messageDetail = "调速串口已与: " + currentText+"端口成功连接..."
                        }

                        //修改combox中的内容
                        speedPort_combo.displayText = currentText
                        messageDialog.open()
                    }
                    else{
                        //修改dialog中的内容
                        messageDialog.messageTitle = "连接失败!"
                        messageDialog.messageIcon = "qrc:/Image/Warning.png"
                        messageDialog.messageDetail = "请查看"+currentText+"端口是否被占用"

                        //修改combox中的内容
                        speedPort_combo.displayText = "调速串口"
                        messageDialog.open()
                    }
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
            onClicked: {
                if(checked === true){
                    if(measurePort_combo.displayText === "测量串口"){
                        control_panel.popMessageDialog()
                        checked = false
                        double_photocell.checked = true
                        return
                    }
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
            onClicked: {
                if(checked === true){
                    if(measurePort_combo.displayText === "测量串口"){
                        control_panel.popMessageDialog()
                        checked = false
                        single_photocell.checked = true
                        return
                    }
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

            onClicked: {
                if(checked === true){
                    if(measurePort_combo.displayText === "测量串口"){
                        control_panel.popMessageDialog()
                        checked = false
                        twoPoint.checked = true
                        return
                    }
                    readSerial.newton()
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
            onClicked: {
                if(checked === true){
                    if(measurePort_combo.displayText === "测量串口"){
                        control_panel.popMessageDialog()
                        checked = false
                        newton.checked = true
                        return
                    }
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
                if(measurePort_combo.displayText === "测量串口"){
                    control_panel.popMessageDialog()
                    return
                }
                readSerial.dynamic_cal()
            }
        }

        TextField {
            id: lowerLimit
            width: 64
            height: 50
            text: "\\"
            topPadding: 8
            bottomPadding: 16
            anchors.bottom: min.top
            anchors.bottomMargin: 0
            anchors.horizontalCenter: min.horizontalCenter
            horizontalAlignment: Text.AlignHCenter
            font.family: noto_bold.name
            font.pixelSize: 18
            color: "#d81e06"

            onFocusChanged: {
                if(focus === true){
                    //如果是动态,不允许改变上下限值，切回静态后再改
                    if(start_button.mycheck === true){
                        messageDialog.messageTitle = "设置失败"
                        messageDialog.messageIcon = "qrc:/Image/Setting.png"
                        messageDialog.messageDetail = "请停止后再设置上限值"
                        messageDialog.open()
                        text = control_panel.lower_limit.toFixed(1)
                        focus = false
                        return
                    }
                }
            }

            onAccepted: {
                //如果下限值输入的比当前上限值还大,设置失败弹出对话框
                if(Number(lowerLimit.text)>=control_panel.upper_limit){
                    messageDialog.messageTitle = "设置失败"
                    messageDialog.messageIcon = "qrc:/Image/Setting.png"
                    messageDialog.messageDetail = "输入的下限值比当前上限值大，请重新输入"
                    messageDialog.open()
                    text = control_panel.lower_limit === -Number.MAX_VALUE?"\\":control_panel.lower_limit.toFixed(1)
                    return
                }

                text = String(Number(text).toFixed(1))
                control_panel.lower_limit = Number(text).toFixed(1)
            }
        }

        TextField {
            id: upperLimit
            width: 64
            height: 50
            text: "\\"
            anchors.bottom: max.top
            anchors.bottomMargin: 0
            anchors.horizontalCenter: max.horizontalCenter
            horizontalAlignment: Text.AlignHCenter
            font.family: noto_bold.name
            font.pixelSize: 18
            color: "#d81e06"

            onFocusChanged: {
                if(focus === true){
                    //如果是动态,不允许改变上下限值，切回静态后再改
                    if(start_button.mycheck === true){
                        messageDialog.messageTitle = "设置失败"
                        messageDialog.messageIcon = "qrc:/Image/Setting.png"
                        messageDialog.messageDetail = "请停止后再设置上限值"
                        messageDialog.open()
                        text = control_panel.upper_limit.toFixed(1)
                        focus = false
                        return
                    }
                }
            }

            onAccepted: {
                //如果设置上限值比当前下限值还小，设置失败，弹出对话框
                if(Number(upperLimit.text)<=control_panel.lower_limit){
                    messageDialog.messageTitle = "设置失败"
                    messageDialog.messageIcon = "qrc:/Image/Setting.png"
                    messageDialog.messageDetail = "输入的上限值比当前下限值小，请重新输入"
                    messageDialog.open()
                    text = control_panel.upper_limit === Number.MAX_VALUE?"\\":control_panel.upper_limit.toFixed(1)
                    return
                }
                text = String(Number(text).toFixed(1))
                control_panel.upper_limit = Number(text).toFixed(1)
            }
        }




        Component.onCompleted:{
            readSerial.dataAvailable.connect(changeWeightValue)
        }

        function changeWeightValue(data){
            var newSum = sum_number+1

            var newAverage = (average_weight*(newSum-1)+data)/(newSum)

            var newMax = Math.max(max_weight,data)

            var newMin = Math.min(min_weight,data)
            //先执行addData函数，所以第一个点已经变成了2
            if(chart.pointX === 2){
                newMax = data
                newMin = data
            }

            var newPassedNum = passed_number

            var newFailedNum = failed_number

            if(data<control_panel.upper_limit&&data>control_panel.lower_limit){
                newPassedNum = passed_number+1
            }
            else{
                newFailedNum = failed_number+1
            }

            var newPassedRatio = (newPassedNum/(newSum))*100

            if(start_button.mycheck === false){
                //如果是静态的话只要给左侧的card更新数据，由于axisY和最值绑定了，不需要手动调axisY
                current_weight = data
                min_weight = newMin
                max_weight = newMax
                average_weight = newAverage
            }
            else{
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
    }

    ChartView{
        id:chart
        legend.font: noto_bold.name
        property real pointX: 1
        property real pointY: 0

        anchors.bottom: parent.bottom
        anchors.bottomMargin: 10
        anchors.right: parent.right
        anchors.rightMargin: 0
        anchors.top: minCard.bottom
        anchors.topMargin: 0
        anchors.left: control_panel.right
        anchors.leftMargin: 0

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
            min: start_button.mycheck===false?
                 //静态时Y轴最大最小值只与最大和最小重量相关
                 ((Math.floor(control_panel.min_weight)-(Math.max(Math.ceil(control_panel.max_weight)-Math.floor(control_panel.min_weight),1))/4)).toFixed(1)
                 :Math.min(control_panel.lower_limit,control_panel.min_weight)-(Math.max(control_panel.upper_limit,control_panel.max_weight)-Math.min(control_panel.lower_limit,control_panel.min_weight))/4

            max: start_button.mycheck===false
                 //静态时Y轴最大最小值只与最大和最小重量相关，动态时还与上下限有关
                 ?((Math.ceil(control_panel.max_weight)+(Math.max(Math.ceil(control_panel.max_weight)-Math.floor(control_panel.min_weight),1))/4)).toFixed(1)
                 :Math.max(control_panel.upper_limit,control_panel.max_weight)+(Math.max(control_panel.upper_limit,control_panel.max_weight)-Math.min(control_panel.lower_limit,control_panel.min_weight))/4

            tickCount: 7
            labelsFont: noto_bold.name
        }

        ScatterSeries{
            id:static_scatter
            name:"静态质量点"
            useOpenGL: true
            axisX:  axisX
            axisY:  axisY
            markerSize: 8
            markerShape: ScatterSeries.MarkerShapeCircle
        }

        ScatterSeries{
            id:passed_scatter
            name:"动态合格点"
            useOpenGL: true
            axisX:  axisX
            axisY:  axisY
            markerSize: 8
            markerShape: ScatterSeries.MarkerShapeCircle
        }

        ScatterSeries{
            id:failed_scatter
            name:"动态不合格点"
            useOpenGL: true
            axisX:  axisX
            axisY:  axisY
            color: "#F44336"
            markerSize: 8
            markerShape: ScatterSeries.MarkerShapeCircle
        }

        LineSeries{
            id:upper_line
            useOpenGL:true
            name:"上限值"
            axisX:  axisX
            axisY:  axisY
            color: "orange"
        }

        LineSeries{
            id:lower_line
            name:"下限值"
            useOpenGL:true
            axisX:  axisX
            axisY:  axisY
            color: "orange"
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
        anchors.top: maxCard.bottom
        anchors.topMargin: 10
        anchors.left: control_panel.right
        anchors.leftMargin: 10

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
            color: (start_button.mycheck === true)
                   ?((control_panel.lower_limit<Number(weightValue.text)&&Number(weightValue.text)<control_panel.upper_limit)?"#1296db":"#d81e06")
                   :"#1296db"
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
        width: 170
        height: 80
        color: "#ffffff"
        radius: 10
        anchors.left: maxCard.right
        anchors.leftMargin: 30
        anchors.top: parent.top
        anchors.topMargin: 20
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
            color: (start_button.mycheck === true)
                   ?((control_panel.lower_limit<Number(weightValue.text)&&Number(weightValue.text)<control_panel.upper_limit)?"#1296db":"#d81e06")
                   :"#1296db"
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
        width: 170
        height: 80
        color: "#ffffff"
        radius: 10
        anchors.top: parent.top
        anchors.topMargin: 20
        anchors.left: control_panel.right
        anchors.leftMargin: 10
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
            color: (start_button.mycheck === true)
                   ?((control_panel.lower_limit<Number(weightValue.text)&&Number(weightValue.text)<control_panel.upper_limit)?"#1296db":"#d81e06")
                   :"#1296db"
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
        anchors.rightMargin: 30
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
        anchors.rightMargin: 30
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
        anchors.left: minCard.right
        anchors.top: averageCard.bottom
        anchors.leftMargin: 30
        anchors.topMargin: 10

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
            color: (start_button.mycheck === true)
                   ?((control_panel.lower_limit<Number(weightValue.text)&&Number(weightValue.text)<control_panel.upper_limit)?"#1296db":"#d81e06")
                   :"#1296db"
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
    }

    function addData(data){
        //静态时加点方法
        if(start_button.mycheck === false){
            chart.pointY = data
            static_scatter.append(chart.pointX,chart.pointY)
            chart.pointX++;
            if(chart.pointX>axisX.max){
                axisX.max+=40
            }
        }
        //动态时加点方法
        else{
            var value = data
            chart.pointY = value
            if(chart.pointX>axisX.max){
                axisX.max += 40
                if(start_button.mycheck === true){
                    upper_line.append(axisX.max,control_panel.upper_limit)
                    lower_line.append(axisX.max,control_panel.lower_limit)
                }
            }
            if(control_panel.lower_limit<chart.pointY&&chart.pointY<control_panel.upper_limit){
                passed_scatter.append(chart.pointX,chart.pointY)
                chart.pointX++;
            }
            else if(chart.pointY>=control_panel.upper_limit){
                failed_scatter.append(chart.pointX,chart.pointY)
                chart.pointX++;
            }
            else if(chart.pointY<=control_panel.lower_limit){
                failed_scatter.append(chart.pointX,chart.pointY)
                chart.pointX++;
            }
        }
    }
}














































































































































































































/*##^## Designer {
    D{i:12;anchors_y:305}D{i:14;anchors_x:160;anchors_y:157}D{i:15;anchors_x:160;anchors_y:157}
D{i:16;anchors_x:160;anchors_y:157}D{i:17;anchors_x:160;anchors_y:157}D{i:18;anchors_x:160;anchors_y:157}
D{i:19;anchors_x:8;anchors_y:482}D{i:20;anchors_x:8;anchors_y:482}D{i:22;anchors_width:119;anchors_x:927;anchors_y:0}
D{i:26;anchors_width:119;anchors_x:927;anchors_y:0}D{i:25;anchors_width:119;anchors_x:927;anchors_y:0}
D{i:28;anchors_width:119;anchors_x:927;anchors_y:0}D{i:24;anchors_width:119;anchors_x:927;anchors_y:0}
D{i:23;anchors_width:119;anchors_x:927;anchors_y:0}D{i:31;anchors_width:119;anchors_x:927;anchors_y:319}
D{i:30;anchors_x:927;anchors_y:319}D{i:29;anchors_width:119;anchors_x:927;anchors_y:0}
D{i:34;anchors_height:100;anchors_width:100;anchors_x:927;anchors_y:363}D{i:33;anchors_height:100;anchors_width:100;anchors_x:6;anchors_y:319}
D{i:32;anchors_width:119;anchors_x:927;anchors_y:319}D{i:35;anchors_height:100;anchors_width:100;anchors_x:927;anchors_y:363}
D{i:36;anchors_height:100;anchors_width:100;anchors_x:6;anchors_y:363}D{i:39;anchors_height:100;anchors_width:100;anchors_y:270}
D{i:42;anchors_height:100;anchors_width:100;anchors_y:270}D{i:44;anchors_height:100;anchors_width:100;anchors_x:105;anchors_y:270}
D{i:45;anchors_height:100;anchors_width:100;anchors_x:54;anchors_y:8}D{i:46;anchors_height:100;anchors_width:100;anchors_x:105;anchors_y:270}
D{i:47;anchors_height:100;anchors_width:100;anchors_x:21;anchors_y:270}D{i:48;anchors_height:100;anchors_width:100;anchors_x:105;anchors_y:270}
D{i:49;anchors_height:100;anchors_width:100;anchors_x:105;anchors_y:0}D{i:50;anchors_height:100;anchors_width:100;anchors_x:54;anchors_y:8}
D{i:43;anchors_height:100;anchors_width:100;anchors_x:105;anchors_y:270}D{i:52;anchors_height:100;anchors_width:100;anchors_x:21;anchors_y:139}
D{i:53;anchors_height:100;anchors_width:100;anchors_x:69;anchors_y:0}D{i:54;anchors_height:100;anchors_width:100;anchors_x:105;anchors_y:0}
D{i:55;anchors_x:464;anchors_y:20}D{i:51;anchors_height:100;anchors_width:100;anchors_x:21;anchors_y:139}
D{i:57;anchors_x:21;anchors_y:139}D{i:58;anchors_x:91;anchors_y:0}D{i:59;anchors_x:210;anchors_y:0}
D{i:60;anchors_x:288;anchors_y:20}D{i:56;anchors_x:21;anchors_y:139}D{i:62;anchors_x:21;anchors_y:139}
D{i:63;anchors_x:134;anchors_y:0}D{i:64;anchors_x:315;anchors_y:117}D{i:65;anchors_x:54;anchors_y:8}
D{i:61;anchors_x:21;anchors_y:3}D{i:67;anchors_x:21;anchors_y:139}D{i:68;anchors_x:420;anchors_y:110}
D{i:69;anchors_x:54;anchors_y:8}D{i:66;anchors_x:21;anchors_y:139}D{i:71;anchors_x:21;anchors_y:139}
D{i:72;anchors_x:525;anchors_y:20}D{i:73;anchors_height:24;anchors_x:54;anchors_y:8}
D{i:70;anchors_x:21;anchors_y:139}D{i:75;anchors_height:24;anchors_x:21;anchors_y:139}
D{i:76;anchors_height:24;anchors_x:81;anchors_y:20}D{i:77;anchors_height:24;anchors_x:8;anchors_y:20}
D{i:78;anchors_height:24;anchors_x:8;anchors_y:20}D{i:74;anchors_height:24;anchors_x:8;anchors_y:139}
D{i:80;anchors_height:24;anchors_x:105;anchors_y:0}D{i:81;anchors_height:24;anchors_x:105;anchors_y:0}
D{i:82;anchors_height:24;anchors_x:54;anchors_y:8}D{i:79;anchors_height:24;anchors_x:105;anchors_y:0}
D{i:84;anchors_height:24;anchors_x:54;anchors_y:8}D{i:85;anchors_height:24;anchors_x:8;anchors_y:20}
D{i:86;anchors_height:24;anchors_x:105;anchors_y:0}D{i:87;anchors_height:24;anchors_x:54;anchors_y:8}
D{i:83;anchors_height:24;anchors_x:105;anchors_y:0}
}
 ##^##*/
