#ifndef SERIAL_H
#define SERIAL_H

#include <QObject>
#include <QSerialPort>
#include<QDebug>
#include <QTimer>
#include<QFile>
#include<QVector>
#include<QUrl>
#include<QByteArray>
#include<QList>
#include<QThread>



class WriteSerial : public QObject
{
    Q_OBJECT
public:
    explicit WriteSerial(QObject *parent = nullptr);
    ~WriteSerial();
signals:
    void readData(QSerialPort* Serial);

public slots:
    //启动相关
    void start();
    void timerStart();
    void measuringStart();
    void feedingStart();
    void sortingStart();

    //停止相关
    void stop();
    void timerStop();
    void measuringStop();
    void feedingStop();
    void sortingStop();

    //调速相关
    void changeSpeed(const QString& s);
    void speedTimerStart();
    void measuringSpeed(const QString& speed);
    void feedingSpeed(const QString& speed);
    void sortingSpeed(const QString& speed);

    //循环冗余校验
    quint16 crc16ForModbus(const QByteArray &data);

    //测试槽函数
    void test();


private:
    QSerialPort* serial;
    QTimer* startTimer;
    QTimer* stopTimer;
    QTimer* speedTimer;
    QString speed = "1000";
    int speedCount =0;
    int startCount = 0;
    int stopCount = 0;


};

#endif // SERIAL_H