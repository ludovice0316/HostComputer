#ifndef READSERIAL_H
#define READSERIAL_H

#include<QObject>
#include<QVector>
#include<QSerialPort>
#include<QSerialPortInfo>
#include<QFile>
#include<QJsonArray>
#include<QJsonDocument>
#include<QJsonValue>
#include<QJsonObject>
#include<QDate>

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

    //向staticData中插入数据
    void insertInStatic(double weight);
    //向dynamicData中插入数据
    void insertInDynamic(double weight);
    //将数据保存到文件中
    void saveStaticData();
    void saveDynamicData();

    //读取data中的数据,最多取maxNum个
    void updateNewData(bool isStatic,int maxNum);
    void updateOldData(bool isStatic,int maxNum);

    //初始化listview至少初始化maxNum个数据，如果数据不够就全部显示
    void initListView(bool isStatic,int maxNum);

    //返回weight数据给qml
    QVector<double> getWeightData();
    //返回date数据给qml
    QVector<QString> getDateData();

    //测试
    void test(float i);

private:
    QString port;
    QSerialPort* serial;
    QVector<int>* container;
    QByteArray tempContainer;

    //Json文件对象
    QJsonDocument* staticDoc;
    QJsonDocument* dynamicDoc;

    //静态数据
    QJsonArray* staticHeadArray;
    QJsonArray* staticBodyArray;
    QJsonArray* staticTailArray;
    //动态数据
    QJsonArray* dynamicHeadArray;
    QJsonArray* dynamicBodyArray;
    QJsonArray* dynamicTailArray;
    //是否为静态标记
    bool isStatic = true;
    //weight数据集合
    QVector<double>* weight;
    //date数据集合
    QVector<QString>* date;
};

#endif // READSERIAL_H
