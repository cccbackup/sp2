#include "MainWindow.hpp"
#include <QWidget>
#include <QLineEdit>
#include <QFormLayout>


MainWindow::MainWindow()
{
    QWidget *central = new QWidget;

    QLineEdit *firstName = new QLineEdit;
    QLineEdit *secondName = new QLineEdit;
    QLineEdit *age = new QLineEdit;

    QFormLayout *layout = new QFormLayout;
    layout->addRow("FirstName", firstName);
    layout->addRow("SecondName", secondName);
    layout->addRow("Age", age);

    central->setLayout(layout);

    setCentralWidget(central);
}

MainWindow::~MainWindow()
{
}
