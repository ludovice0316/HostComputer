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
    for (int i =0;i<list.size();i++) {
        emit dataAvailable(list[i].toFloat());
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

    cmd[0]=0x01;cmd[1]=0x05;
    cmd[2]=0x00;cmd[3]=0x00;
    cmd[4]=0x01;cmd[5]=0xff;
    serial->write(cmd);
}

void ReadSerial::beltStop(){
    QByteArray cmd;         //皮带已停止命令

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

