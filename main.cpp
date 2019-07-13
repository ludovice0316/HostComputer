#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QApplication>
#include<QDebug>
#include <QQmlContext>
#include<QQmlComponent>
#include<QThread>
#include<QObject>
#include"writeserial.h"
#include"readserial.h"



int main(int argc, char *argv[])
{
    QCoreApplication::setAttribute(Qt::AA_EnableHighDpiScaling);

    QApplication app(argc, argv);

    QQmlApplicationEngine engine;

    WriteSerial* writeSerial = new WriteSerial;
    ReadSerial* readSerial = new ReadSerial;

    QQmlContext* context = engine.rootContext();
    context->setContextProperty("writeSerial",writeSerial);
    context->setContextProperty("readSerial",readSerial);



    engine.load(QUrl("qrc:/HostCompute.qml"));
    if (engine.rootObjects().isEmpty())
        return -1;

    return app.exec();
}
