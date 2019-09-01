#include "writeserial.h"

WriteSerial::WriteSerial(QObject *parent) : QObject(parent)
{
    serial = new QSerialPort(this);
    serial->setBaudRate(115200);//设置波特率为115200
    serial->setDataBits(QSerialPort::Data8);//设置数据位8
    serial->setParity(QSerialPort::NoParity); //校验位设置为0
    serial->setStopBits(QSerialPort::OneStop);//停止位设置为1
    serial->setFlowControl(QSerialPort::NoFlowControl);//设置为无流控制

    //启动定时器，每隔100ms发送一条启动指令，共发送三条
    startTimer = new QTimer(this);
    startTimer->setInterval(100);
    connect(startTimer,&QTimer::timeout,this,&WriteSerial::timerStart);

    //停止定时器，每隔100ms发送一条停止指令，共发送三条
    stopTimer = new QTimer(this);
    stopTimer->setInterval(100);
    connect(stopTimer,&QTimer::timeout,this,&WriteSerial::timerStop);

    //调速定时器，每隔100ms发送一条调速指令，共发送三条
    speedTimer = new QTimer(this);
    speedTimer->setInterval(350);
    connect(speedTimer,&QTimer::timeout,this,&WriteSerial::speedTimerStart);

    //初始port为空
    port = "";
}

WriteSerial::~WriteSerial(){
}

bool WriteSerial::start(){
    if(!serial->isOpen()){
        return false;
    }
    startTimer->stop();
    startCount = 0;
    startTimer->start();
    return true;
}

void WriteSerial::timerStart(){
    switch (startCount) {
    case 0:
        measuringStart();
        startCount++;
        break;

    case 1:
        feedingStart();
        startCount++;
        break;

    case 2:
        sortingStart();
        startTimer->stop();
        startCount = 0;
        break;
    }
}

void WriteSerial::measuringStart(){
    QByteArray MeasuringOn;         //计量皮带启动命令
    QByteArray MeasuringSpeed;

    //计量皮带启动命令
    MeasuringOn[0]=0x01;MeasuringOn[1]=0x06;MeasuringOn[2]=0x03;MeasuringOn[3]=0x9F;
    MeasuringOn[4]=0x00;MeasuringOn[5]=0x01;MeasuringOn[6]=0x78;MeasuringOn[7]=0x60;
    serial->write(MeasuringOn);

}
void WriteSerial::feedingStart(){
    QByteArray FeedingOn;           //送料皮带启动命令
    QByteArray FeedingSpeed;
    //送料皮带启动命令
    FeedingOn[0]=0x01;FeedingOn[1]=0x06;FeedingOn[2]=0x03;FeedingOn[3]=0x95;
    FeedingOn[4]=0x00;FeedingOn[5]=0x01;FeedingOn[6]=0x58;FeedingOn[7]=0x62;
    serial->write(FeedingOn);

}
void WriteSerial::sortingStart(){
    QByteArray SortingOn;           //分选皮带启动命令
    QByteArray SortingSpeed;
    //分选皮带启动命令
    SortingOn[0]=0x01;SortingOn[1]=0x06;SortingOn[2]=0x03;SortingOn[3]=0xA9;
    SortingOn[4]=0x00;SortingOn[5]=0x01;SortingOn[6]=0x98;SortingOn[7]=0x6E;
    serial->write(SortingOn);
}

void WriteSerial::stop(){
    if(!serial->isOpen()){
    }
    else{
        stopTimer->stop();
        stopCount = 0;
        stopTimer->start();
    }
}

void WriteSerial::timerStop(){

    switch (stopCount) {
        case 0:
        measuringStop();
        stopCount++;
        break;

        case 1:
        feedingStop();
        stopCount++;
        break;

        case 2:
        sortingStop();
        stopCount = 0;
        stopTimer->stop();
        break;

    }
}

void WriteSerial::measuringStop(){
    QByteArray MeasuringStop;       //计量皮带停止命令
    //计量皮带停止命令
    MeasuringStop[0]=0x01;MeasuringStop[1]=0x06;MeasuringStop[2]=0x03;MeasuringStop[3]=0x9F;
    MeasuringStop[4]=0x00;MeasuringStop[5]=0x00;MeasuringStop[6]=0xB9;MeasuringStop[7]=0xA0;
    serial->write(MeasuringStop);
}
void WriteSerial::feedingStop(){
     QByteArray FeedingStop;         //送料皮带停止命令
     //送料皮带停止命令
     FeedingStop[0]=0x01;FeedingStop[1]=0x06;FeedingStop[2]=0x03;FeedingStop[3]=0x95;
     FeedingStop[4]=0x00;FeedingStop[5]=0x00;FeedingStop[6]=0x99;FeedingStop[7]=0xA2;
     serial->write(FeedingStop);
}
void WriteSerial::sortingStop(){
    QByteArray SortingStop;         //分选皮带停止命令
    //分选皮带停止命令
    SortingStop[0]=0x01;SortingStop[1]=0x06;SortingStop[2]=0x03;SortingStop[3]=0xA9;
    SortingStop[4]=0x00;SortingStop[5]=0x00;SortingStop[6]=0x59;SortingStop[7]=0xAE;
    serial->write(SortingStop);
}



quint16 WriteSerial::crc16ForModbus(const QByteArray &data){
    static const quint16 crc16Table[] =
        {
            0x0000, 0xC0C1, 0xC181, 0x0140, 0xC301, 0x03C0, 0x0280, 0xC241,
            0xC601, 0x06C0, 0x0780, 0xC741, 0x0500, 0xC5C1, 0xC481, 0x0440,
            0xCC01, 0x0CC0, 0x0D80, 0xCD41, 0x0F00, 0xCFC1, 0xCE81, 0x0E40,
            0x0A00, 0xCAC1, 0xCB81, 0x0B40, 0xC901, 0x09C0, 0x0880, 0xC841,
            0xD801, 0x18C0, 0x1980, 0xD941, 0x1B00, 0xDBC1, 0xDA81, 0x1A40,
            0x1E00, 0xDEC1, 0xDF81, 0x1F40, 0xDD01, 0x1DC0, 0x1C80, 0xDC41,
            0x1400, 0xD4C1, 0xD581, 0x1540, 0xD701, 0x17C0, 0x1680, 0xD641,
            0xD201, 0x12C0, 0x1380, 0xD341, 0x1100, 0xD1C1, 0xD081, 0x1040,
            0xF001, 0x30C0, 0x3180, 0xF141, 0x3300, 0xF3C1, 0xF281, 0x3240,
            0x3600, 0xF6C1, 0xF781, 0x3740, 0xF501, 0x35C0, 0x3480, 0xF441,
            0x3C00, 0xFCC1, 0xFD81, 0x3D40, 0xFF01, 0x3FC0, 0x3E80, 0xFE41,
            0xFA01, 0x3AC0, 0x3B80, 0xFB41, 0x3900, 0xF9C1, 0xF881, 0x3840,
            0x2800, 0xE8C1, 0xE981, 0x2940, 0xEB01, 0x2BC0, 0x2A80, 0xEA41,
            0xEE01, 0x2EC0, 0x2F80, 0xEF41, 0x2D00, 0xEDC1, 0xEC81, 0x2C40,
            0xE401, 0x24C0, 0x2580, 0xE541, 0x2700, 0xE7C1, 0xE681, 0x2640,
            0x2200, 0xE2C1, 0xE381, 0x2340, 0xE101, 0x21C0, 0x2080, 0xE041,
            0xA001, 0x60C0, 0x6180, 0xA141, 0x6300, 0xA3C1, 0xA281, 0x6240,
            0x6600, 0xA6C1, 0xA781, 0x6740, 0xA501, 0x65C0, 0x6480, 0xA441,
            0x6C00, 0xACC1, 0xAD81, 0x6D40, 0xAF01, 0x6FC0, 0x6E80, 0xAE41,
            0xAA01, 0x6AC0, 0x6B80, 0xAB41, 0x6900, 0xA9C1, 0xA881, 0x6840,
            0x7800, 0xB8C1, 0xB981, 0x7940, 0xBB01, 0x7BC0, 0x7A80, 0xBA41,
            0xBE01, 0x7EC0, 0x7F80, 0xBF41, 0x7D00, 0xBDC1, 0xBC81, 0x7C40,
            0xB401, 0x74C0, 0x7580, 0xB541, 0x7700, 0xB7C1, 0xB681, 0x7640,
            0x7200, 0xB2C1, 0xB381, 0x7340, 0xB101, 0x71C0, 0x7080, 0xB041,
            0x5000, 0x90C1, 0x9181, 0x5140, 0x9301, 0x53C0, 0x5280, 0x9241,
            0x9601, 0x56C0, 0x5780, 0x9741, 0x5500, 0x95C1, 0x9481, 0x5440,
            0x9C01, 0x5CC0, 0x5D80, 0x9D41, 0x5F00, 0x9FC1, 0x9E81, 0x5E40,
            0x5A00, 0x9AC1, 0x9B81, 0x5B40, 0x9901, 0x59C0, 0x5880, 0x9841,
            0x8801, 0x48C0, 0x4980, 0x8941, 0x4B00, 0x8BC1, 0x8A81, 0x4A40,
            0x4E00, 0x8EC1, 0x8F81, 0x4F40, 0x8D01, 0x4DC0, 0x4C80, 0x8C41,
            0x4400, 0x84C1, 0x8581, 0x4540, 0x8701, 0x47C0, 0x4680, 0x8641,
            0x8201, 0x42C0, 0x4380, 0x8341, 0x4100, 0x81C1, 0x8081, 0x4040
        };
    quint8 buf;
    quint16 crc16 = 0xFFFF;

    for ( auto i = 0; i < data.size(); ++i )
    {
        buf = data.at( i ) ^ crc16;
        crc16 >>= 8;
        crc16 ^= crc16Table[ buf ];
    }

    return crc16;
}

void WriteSerial::changeSpeed(const QString& s){
    if(!serial->isOpen()){

    }
    else{
        speed = s;
        speedTimer->stop();
        speedCount = 0;
        speedTimer->start();
    }
}

void WriteSerial::speedTimerStart(){

    switch (speedCount) {
        case 0:
        measuringSpeed(speed);
        speedCount++;
        break;

        case 1:
        feedingSpeed(speed);
        speedCount++;
        break;

        case 2:
        sortingSpeed(speed);
        speedTimer->stop();
        speedCount = 0;
        break;
    }
}
void WriteSerial::measuringSpeed(const QString& speed){
    QString str;
    str=speed;//得到转速
    if(str.isEmpty()) return;

    //把转速转成两个数
    int temp;
    quint16 crc16;
    bool ok;
    temp=str.toInt(&ok,10);
    temp = temp*29.83+98.06;
    temp = static_cast<int>(temp);



    //发送调速命令
    QByteArray MeasuringChange;
    //计量皮带调速
    MeasuringChange[0]=0x01;MeasuringChange[1]=0x06;MeasuringChange[2]=0x03;MeasuringChange[3]=0x9E;
    //5，6处的参数为转速分解出的两个十六进制数
    MeasuringChange[4]=(temp/256)%16+(temp/4096)%16*16;MeasuringChange[5]=temp%16+(temp/16)%16*16;
    //7，8处的参数为CRC校验值
    crc16=crc16ForModbus(MeasuringChange);
    MeasuringChange[6]=crc16%16+(crc16/16)%16*16;MeasuringChange[7]=(crc16/256)%16+(crc16/4096)%16*16;

    if(serial!=nullptr){
    serial->write(MeasuringChange);
    }
}

void WriteSerial::feedingSpeed(const QString& speed){
    QString str;
    str=speed;//得到转速
    if(str.isEmpty()) return;

    //把转速转成两个数
    int temp;
    quint16 crc16;
    bool ok;
    temp=str.toInt(&ok,10);
    temp = temp*29.83+98.06;
    temp = static_cast<int>(temp);


    //发送调速命令
    QByteArray FeedingChange;
    //送料皮带调速
    FeedingChange[0]=0x01;FeedingChange[1]=0x06;FeedingChange[2]=0x03;FeedingChange[3]=0x94;

    //5，6处的参数为转速分解出的两个十六进制数
    FeedingChange[4]=(temp/256)%16+(temp/4096)%16*16;FeedingChange[5]=temp%16+(temp/16)%16*16;

    //7，8处的参数为CRC校验值
    crc16=crc16ForModbus(FeedingChange);
    FeedingChange[6]=crc16%16+(crc16/16)%16*16;FeedingChange[7]=(crc16/256)%16+(crc16/4096)%16*16;
    if(serial!=nullptr){
    serial->write(FeedingChange);
    }
}

void WriteSerial::sortingSpeed(const QString& speed){
    QString str;
    str=speed;//得到转速
    if(str.isEmpty()) return;

    //把转速转成两个数
    int temp;
    quint16 crc16;
    bool ok;
    temp=str.toInt(&ok,10);
    temp = temp*29.83+98.06;
    temp = static_cast<int>(temp);


    //发送调速命令
    QByteArray SortingChange;
    //分选皮带调速
    SortingChange[0]=0x01;SortingChange[1]=0x06;SortingChange[2]=0x03;SortingChange[3]=0xA8;

    //5，6处的参数为转速分解出的两个十六进制数
    SortingChange[4]=(temp/256)%16+(temp/4096)%16*16;SortingChange[5]=temp%16+(temp/16)%16*16;

    //7，8处的参数为CRC校验值
    crc16=crc16ForModbus(SortingChange);
    SortingChange[6]=crc16%16+(crc16/16)%16*16;SortingChange[7]=(crc16/256)%16+(crc16/4096)%16*16;
    if(serial!=nullptr){
    serial->write(SortingChange);
    }
}

bool WriteSerial::resetPortName(const QString& name){
    serial->close();
    serial->setPortName(name);
    port = name;
    if(!serial->open(QIODevice::ReadWrite)){
        qDebug()<<"Failed to open WriteSerial"<<endl;
        port = "";
        return false;
    }
    else {
        return true;
    }
}

QString WriteSerial::connectedPort(){
    return port;
}
