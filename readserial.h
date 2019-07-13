#ifndef READSERIAL_H
#define READSERIAL_H

#include <QObject>
#include<QVector>
#include<QSerialPort>

class ReadSerial : public QObject
{
    Q_OBJECT
public:
    explicit ReadSerial(QObject *parent = nullptr);


signals:
    void dataAvailable(float);

public slots:
    //串口启动与停止函数
    void start(const QString &name = "com4");
    void stop();

    //皮带已变速函数
    void beltSpeedChange(const QString& arg);
    //皮带已启动函数
    void beltStart();
    //皮带已停止函数
    void beltStop();
    //光电设置函数
    void photocellSet(const QString& arg);
    //校准设置函数
    void calibration(const QString& arg);

    //处理数据函数
    void readData();

private:
    QSerialPort* serial;
    QVector<int>* container;
    QByteArray tempContainer;
};

#endif // READSERIAL_H
