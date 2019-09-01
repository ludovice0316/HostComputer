#ifndef READSERIAL_H
#define READSERIAL_H

#include <QObject>
#include<QVector>
#include<QSerialPort>
#include <QSerialPortInfo>
#include<QFile>

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
    //动态校准
    void dynamic_cal();

    //处理数据函数
    void readData();

    //获取可用端口
    QList<QString> availablePort();

    //获取当前连接到的端口号
    QString connectedPort();

    //重新设置com端口
    bool resetPortName(const QString& name);

    //两点拟合
    void linear();
    //牛顿拟合
    void newton();

    //系统调零
    void zeroSetting(const QString& arg);

private:
    QString port;
    QSerialPort* serial;
    QVector<int>* container;
    QByteArray tempContainer;
};

#endif // READSERIAL_H
