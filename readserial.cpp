#include "readserial.h"
#include<QDebug>
#include<QThread>


ReadSerial::ReadSerial(QObject *parent) : QObject(parent)
{
    serial = new QSerialPort(this);
    serial->setPortName("com5");
    serial->setBaudRate(115200);//设置波特率为115200
    serial->setDataBits(QSerialPort::Data8);//设置数据位8
    serial->setParity(QSerialPort::NoParity); //校验位设置为0
    serial->setStopBits(QSerialPort::OneStop);//停止位设置为1
    serial->setFlowControl(QSerialPort::NoFlowControl);//设置为无流控制
    connect(serial,SIGNAL(readyRead()),this,SLOT(readData()));
    container = new QVector<int>;

    //初始port为空
    port = "";

    //打开静态数据json文件
    QFile staticFile("./staticData.json");
    QFile dynamicFile("./dynamicData.json");
    //判断是否成功打开文件
    if(!staticFile.open(QIODevice::ReadWrite))
    {
     qDebug() << "打开staticData.json失败";
     return;
    }
    if(!dynamicFile.open(QIODevice::ReadWrite)){
        qDebug() << "打开dynamicData.json失败";
        return;
    }
    //如果文件为空，向这个文件中添加一个json数组
    if(staticFile.size() == 0){
        QJsonArray initArray;
        QJsonDocument jsonDoc;
        jsonDoc.setArray(initArray);
        staticFile.write(jsonDoc.toJson());
        staticFile.seek(0);
    }
    if(dynamicFile.size() == 0){
        QJsonArray initArray;
        QJsonDocument jsonDoc;
        jsonDoc.setArray(initArray);
        dynamicFile.write(jsonDoc.toJson());
        dynamicFile.seek(0);
    }
    //读取json文件中的数据，并用其初始化JsonDocument
    QByteArray staticData = staticFile.readAll();
    QByteArray dynamicData = dynamicFile.readAll();


    staticFile.close();
    dynamicFile.close();

    QJsonParseError staticError;
    QJsonParseError dynamicError;

    staticDoc = new QJsonDocument(QJsonDocument::fromJson(staticData,&staticError));
    dynamicDoc = new QJsonDocument(QJsonDocument::fromJson(dynamicData,&dynamicError));


    if(staticError.error != QJsonParseError::NoError){
        qDebug()<<"staticJson error"<<staticError.error<<endl;
    }
    if(dynamicError.error != QJsonParseError::NoError){
        qDebug()<<"dynamicJson error"<<dynamicError.error<<endl;
    }

    staticHeadArray = new QJsonArray;
    dynamicHeadArray = new QJsonArray;

    staticBodyArray = new QJsonArray;
    dynamicBodyArray = new QJsonArray;

    staticTailArray = new QJsonArray(staticDoc->array());
    dynamicTailArray = new QJsonArray(dynamicDoc->array());

    weight = new QVector<double>;
    date = new QVector<QString>;
}

void ReadSerial::readData(){

    QByteArray buf;
    QByteArray temp;
    QList<QByteArray> list;

    int index;

    //把上次读到的数据的尾巴接到这次读取的数据流上
    buf.append(tempContainer);
    buf.append(serial->readAll());
    index = buf.size()-1;

    //把这次数据的尾巴存入临时容器中
    while (buf[index] != '\n') {
        temp.push_front(buf[index]);
        buf.chop(1);
        index--;
    }
    tempContainer.resize(0);
    tempContainer = temp;

    //把这次截断的数据流按回车换行符做分割
    list = buf.split('\n');
    list.pop_back();
    if(isStatic){
        for (int i =0;i<list.size();i++) {
            insertInStatic(list[i].toDouble());
            emit dataAvailable(list[i].toFloat());
        }
    }
    else {
        for (int i =0;i<list.size();i++) {
            insertInDynamic(list[i].toDouble());
            emit dataAvailable(list[i].toFloat());
        }
    }
}

void ReadSerial::start(const QString &name){
    serial->setPortName(name);
    if(serial->open(QIODevice::ReadWrite)){
    }
    else {
        qDebug()<<"Failed to open ReadSerial"<<endl;
    }
}

void ReadSerial::stop(){
    serial->close();
}

void ReadSerial::beltStart(){
    QByteArray cmd;         //皮带已启动命令
    isStatic = false;
    cmd[0]=0x01;cmd[1]=0x05;
    cmd[2]=0x00;cmd[3]=0x00;
    cmd[4]=0x01;cmd[5]=0xff;
    serial->write(cmd);
}

void ReadSerial::beltStop(){
    QByteArray cmd;         //皮带已停止命令
    isStatic = true;
    cmd[0]=0x01;cmd[1]=0x05;
    cmd[2]=0x00;cmd[3]=0x00;
    cmd[4]=0x00;cmd[5]=0xff;
    serial->write(cmd);
}

void ReadSerial::beltSpeedChange(const QString& arg){
    int rotatingSpeed;
    int speed = arg.toInt();
    rotatingSpeed = static_cast<int>(speed*29.83+98.06);
    QByteArray cmd;
    cmd[0] = 0x01;cmd[1] = 0x04;
    cmd[2] = 0x00;cmd[3] = (rotatingSpeed/256)%16+(rotatingSpeed/4096)%16*16;
    cmd[4] = rotatingSpeed%16+(rotatingSpeed/16)%16*16;cmd[5] = 0xff;
    serial->write(cmd);
}

void ReadSerial::calibration(const QString& arg){
    if(arg == "0"){
        QByteArray cmd;         //静态零点校准
        cmd[0]=0x01;cmd[1]=0x03;
        cmd[2]=0x00;cmd[3]=0x00;
        cmd[4]=0x00;cmd[5]=0xff;
        serial->write(cmd);
    }
    else if(arg == "200"){
        QByteArray cmd;         //静态200g校准
        cmd[0]=0x01;cmd[1]=0x03;
        cmd[2]=0x00;cmd[3]=0x00;
        cmd[4]=0x01;cmd[5]=0xff;
        serial->write(cmd);
    }
}

void ReadSerial::photocellSet(const QString& arg){
    if(arg == "double"){
        QByteArray cmd;         //双光电模式命令
        cmd[0]=0x01;cmd[1]=0x06;
        cmd[2]=0x00;cmd[3]=0x00;
        cmd[4]=0x00;cmd[5]=0xff;
        serial->write(cmd);
    }
    else if(arg == "single"){
        QByteArray cmd;         //单光电模式命令
        cmd[0]=0x01;cmd[1]=0x06;
        cmd[2]=0x00;cmd[3]=0x00;
        cmd[4]=0x01;cmd[5]=0xff;
        serial->write(cmd);
    }
}

QList<QString> ReadSerial::availablePort(){
    QList<QString> list;
    auto ports = QSerialPortInfo::availablePorts();
    for (QSerialPortInfo portInfo : ports) {
        list.append(portInfo.portName());
    }
    return list;
}

bool ReadSerial::resetPortName(const QString& name){
    serial->close();
    serial->setPortName(name);
    port = name;
    if(!serial->open(QIODevice::ReadWrite)){
        qDebug()<<"Failed to open ReadSerial"<<endl;
        port = "";
        return false;
    }
    else {
        return true;
    }
}

void ReadSerial::dynamic_cal(){
    QByteArray cmd;         //动态校准命令
    cmd[0]=0x01;cmd[1]=0x02;
    cmd[2]=0x00;cmd[3]=0x00;
    cmd[4]=0x01;cmd[5]=0xff;
    serial->write(cmd);
}

void ReadSerial::linear(){
    QByteArray cmd;         //线性拟合命令
    cmd[0]=0x01;cmd[1]=0x08;
    cmd[2]=0x00;cmd[3]=0x00;
    cmd[4]=0x00;cmd[5]=0xff;
    serial->write(cmd);
}

void ReadSerial::newton(){
    QByteArray cmd;         //牛顿拟合命令
    cmd[0]=0x01;cmd[1]=0x08;
    cmd[2]=0x00;cmd[3]=0x00;
    cmd[4]=0x01;cmd[5]=0xff;
    serial->write(cmd);
}

void ReadSerial::zeroSetting(const QString& arg){
    int x = arg.toInt();
    QByteArray cmd;
    cmd[0] = 0x01;cmd[1] = 0x01;
    cmd[2] = 0x00;cmd[3] = (x/256)%16+(x/4096)%16*16;
    cmd[4] = x%16+(x/16)%16*16;cmd[5] = 0xff;
    serial->write(cmd);
}

QString ReadSerial::connectedPort(){
    return port;
}

void ReadSerial::insertInStatic(double weight){
    QJsonObject obj;
    obj.insert("weight",weight);
    obj.insert("date",QDateTime::currentDateTime().toString());
    QJsonValue value(obj);
    staticHeadArray->push_front(value);
}

void ReadSerial::insertInDynamic(double weight){
    QJsonObject obj;
    obj.insert("weight",weight);
    obj.insert("date",QDateTime::currentDateTime().toString());
    QJsonValue value(obj);
    dynamicHeadArray->push_front(value);
}


void ReadSerial::saveStaticData(){
    QFile file("./staticData.json");
    file.open(QIODevice::ReadWrite|QIODevice::Truncate);
    for (int i=0;i<staticBodyArray->size();i++) {
        staticHeadArray->append((*staticBodyArray)[i]);
    }
    for (int i=0;i<staticTailArray->size();i++) {
        staticHeadArray->append((*staticTailArray)[i]);

    }
    staticDoc->setArray(*staticHeadArray);
    file.write(staticDoc->toJson());
}


void ReadSerial::saveDynamicData(){
    QFile file("./dynamicData.json");
    file.open(QIODevice::ReadWrite|QIODevice::Truncate);
    for (int i=0;i<dynamicBodyArray->size();i++) {
        dynamicHeadArray->append((*dynamicBodyArray)[i]);
    }
    for (int i=0;i<dynamicTailArray->size();i++) {
        dynamicHeadArray->append((*dynamicTailArray)[i]);
    }
    dynamicDoc->setArray(*dynamicHeadArray);
    file.write(dynamicDoc->toJson());
}


void ReadSerial::updateNewData(bool isStatic,int maxNum){

    weight->clear();
    date->clear();

    int staticSize = staticHeadArray->size();
    int dynamicSize = dynamicHeadArray->size();

    //如果是需要更新静态数据
    if(isStatic){
        //如果tail中的静态数据大于maxNum个
        if(staticHeadArray->size()>maxNum){
            for (int i=0;i<maxNum;i++) {
                weight->push_front(staticHeadArray->last().toObject().value("weight").toDouble());
                date->push_front(staticHeadArray->last().toObject().value("date").toString());
                staticBodyArray->push_front(staticHeadArray->last());
                staticHeadArray->pop_back();
            }
        }
        //如果tail中的静态数据不足maxNum个，就取tail中所有元素
        else {
            for (int i=0;i<staticSize;i++) {
                weight->push_front(staticHeadArray->last().toObject().value("weight").toDouble());
                date->push_front(staticHeadArray->last().toObject().value("date").toString());
                staticBodyArray->push_front(staticHeadArray->last());
                staticHeadArray->pop_back();
            }
        }
    }
    //如果是需要更新动态数据
    else{
        //如果tail中的动态数据大于maxNum个
        if(dynamicHeadArray->size()>maxNum){
            for (int i=0;i<maxNum;i++) {
                weight->push_front(dynamicHeadArray->last().toObject().value("weight").toDouble());
                date->push_front(dynamicHeadArray->last().toObject().value("date").toString());
                dynamicBodyArray->push_front(dynamicHeadArray->last());
                dynamicHeadArray->pop_back();
            }
        }
        //如果tail中的动态数据不足maxNum个
        else {
            for (int i=0;i<dynamicSize;i++) {
                weight->push_front(dynamicHeadArray->last().toObject().value("weight").toDouble());
                date->push_front(dynamicHeadArray->last().toObject().value("date").toString());
                dynamicBodyArray->push_front(dynamicHeadArray->last());
                dynamicHeadArray->pop_back();
            }
        }
    }
}

void ReadSerial::updateOldData(bool isStatic,int maxNum){

    weight->clear();
    date->clear();

    int staticSize = staticTailArray->size();
    int dynamicSize = dynamicTailArray->size();

    //如果是需要更新静态数据
    if(isStatic){
        //如果tail中的静态数据大于maxNum个
        if(staticTailArray->size()>maxNum){
            for (int i=0;i<maxNum;i++) {
                weight->push_back((*staticTailArray)[0].toObject().value("weight").toDouble());
                date->push_back((*staticTailArray)[0].toObject().value("date").toString());
                staticBodyArray->push_back((*staticTailArray)[0]);
                staticTailArray->pop_front();
            }
        }
        //如果tail中的静态数据不足maxNum个，就取tail中所有元素
        else {
            for (int i=0;i<staticSize;i++) {
                weight->push_back((*staticTailArray)[0].toObject().value("weight").toDouble());
                date->push_back((*staticTailArray)[0].toObject().value("date").toString());
                staticBodyArray->push_back((*staticTailArray)[0]);
                staticTailArray->pop_front();
            }
        }
    }

    //如果是需要更新动态数据
    else {
        //如果tail中的动态数据大于maxNum个
        if(dynamicTailArray->size()>maxNum){
            for (int i=0;i<maxNum;i++) {
                weight->push_back((*dynamicTailArray)[0].toObject().value("weight").toDouble());
                date->push_back((*dynamicTailArray)[0].toObject().value("date").toString());
                dynamicBodyArray->push_back((*dynamicTailArray)[0]);
                dynamicTailArray->pop_front();
            }
        }
        //如果tail中的动态数据不足maxNum个
        else {
            for (int i=0;i<dynamicSize;i++) {
                weight->push_back((*dynamicTailArray)[0].toObject().value("weight").toDouble());
                date->push_back((*dynamicTailArray)[0].toObject().value("date").toString());
                dynamicBodyArray->push_back((*dynamicTailArray)[0]);
                dynamicTailArray->pop_front();
            }
        }
    }
}


void ReadSerial::initListView(bool isStatic,int maxNum){
    weight->clear();
    date->clear();

    int staticSize = staticBodyArray->size();
    int dynamicSize = dynamicBodyArray->size();

    if(isStatic){
        if(staticBodyArray->size() == 0){
            if(staticTailArray->size() ==0){
                updateNewData(true,maxNum);
            }
            else{
                updateOldData(true,maxNum);
            }
        }
        else {
            for (int i=0;i<staticSize;i++) {
                weight->push_back((*staticBodyArray)[i].toObject().value("weight").toDouble());
                date->push_back((*staticBodyArray)[i].toObject().value("date").toString());
            }
        }
    }
    else {
        if(dynamicBodyArray->size() == 0){
            if(dynamicTailArray->size() ==0){
                updateNewData(false,maxNum);
            }
            else{
                updateOldData(false,maxNum);
            }
        }
        else {
            for (int i=0;i<dynamicSize;i++) {
                weight->push_back((*dynamicBodyArray)[i].toObject().value("weight").toDouble());
                date->push_back((*dynamicBodyArray)[i].toObject().value("date").toString());
            }
        }
    }
}

QVector<double> ReadSerial::getWeightData(){
    return *weight;
}

QVector<QString> ReadSerial::getDateData(){
    return *date;
}

//测试
void ReadSerial::test(float i){
    emit dataAvailable(i);
}
