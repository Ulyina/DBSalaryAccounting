# main.py

from PyQt6.QtWidgets import QApplication, QWidget, QMessageBox, QVBoxLayout, QRadioButton, QCheckBox
import mysql.connector

from formSalary import Ui_Form
from DB import calculate_write, select_positions, select_operations, select_insurance_types

class MainWindow(QWidget):
    def __init__(self):
        super().__init__()

        # Инициализация UI
        self.ui = Ui_Form()
        self.ui.setupUi(self)

        # Установка заголовка окна
        self.setWindowTitle("Salary Accounting")

        # Настройка интерфейса
        self.setupUi()

        # Выбор и добавление должностей
        self.select_position()

        # Выбор и добавление операций
        self.select_operation()

        # Выбор и добавление страховых типов
        self.select_insurance_types()

        # Связывание сигнала изменения выбора combobox с функцией обновления страховых типов
        self.ui.comboBox.currentIndexChanged.connect(self.update_insurance_types)

        # Связывание кнопки "Рассчитать" с функцией calculate_earnings
        self.ui.pushButton.clicked.connect(self.calculate_earnings)

        # Связывание кнопки "Записать" с функцией write_to_database
        self.ui.pushButton_2.clicked.connect(self.write_to_database)

    def write_to_database(self):
        position_id = self.ui.comboBox.currentData()  # Получаем id выбранной должности
        operation_id = self.get_selected_operation_id()  # Получаем id выбранной операции
        contribution_id = self.get_selected_contribution_id()  # Получаем id выбранного взноса

        # Вызываем функцию из модуля DB для записи в базу данных
        success = calculate_write(position_id, operation_id, contribution_id)

        if success:
            QMessageBox.information(None, "Запись в базу данных", "Данные успешно записаны в базу данных!")
        else:
            QMessageBox.critical(None, "Ошибка", "Не удалось записать данные в базу данных.")

    # Настройка интерфейса
    def setupUi(self):
        self.operation_layout = QVBoxLayout(self.ui.groupBox)
        self.insurance_layout = QVBoxLayout(self.ui.groupBox_2)

    # Выбор и добавление должностей
    def select_position(self):
        try:
            positions = select_positions()
            for position_id, position_title in positions:
                self.ui.comboBox.addItem(position_title, position_id)
        except mysql.connector.Error as err:
            QMessageBox.critical(self, "Ошибка", str(err))

    # Выбор и добавление операций
    def select_operation(self):
        try:
            operations = select_operations()
            for operation_id, operation_title in operations:
                radio_button = QRadioButton(operation_title)
                radio_button.setProperty("id", operation_id)  # Устанавливаем свойство с идентификатором операции
                self.operation_layout.addWidget(radio_button)
        except mysql.connector.Error as err:
            QMessageBox.critical(self, "Ошибка", str(err))

    # Обновление страховых типов при изменении выбора должности
    def update_insurance_types(self):
        position_id = self.ui.comboBox.currentData()  # Получаем id выбранной должности
        self.select_insurance_types(position_id)

    # Выбор и добавление страховых типов
    def select_insurance_types(self, position_id=None):
        try:
            if position_id is None:
                position_id = self.ui.comboBox.currentData()  # Получаем id выбранной должности, если не передан position_id

            insurance_types = select_insurance_types(position_id)
            self.clear_insurance_types_layout()  # Очищаем предыдущие чекбоксы

            if insurance_types:
                for insurance_type_id, title, amount in insurance_types:
                    checkbox = QCheckBox(f"{title} ({amount}%)")
                    checkbox.setProperty("id", insurance_type_id)  # Устанавливаем свойство с идентификатором страхового типа
                    self.ui.groupBox_2.layout().addWidget(checkbox)
            else:
                QMessageBox.warning(self, "Внимание", "Таблица InsuranceTypes пуста")
        except mysql.connector.Error as err:
            QMessageBox.critical(self, "Ошибка", str(err))

    # Очищение layout для страховых типов
    def clear_insurance_types_layout(self):
        for i in reversed(range(self.ui.groupBox_2.layout().count())):
            widget = self.ui.groupBox_2.layout().itemAt(i).widget()
            if widget is not None:
                widget.deleteLater()

    # Функция для обработки нажатия кнопки "Рассчитать"
    def calculate_earnings(self):
        position_id = self.ui.comboBox.currentData()  # Получаем id выбранной должности
        operation_id = self.get_selected_operation_id()  # Получаем id выбранной операции
        contribution_id = self.get_selected_contribution_id()  # Получаем id выбранного взноса
        calculate_earnings(position_id, operation_id, contribution_id)

    # Метод для получения выбранного ID операции
    def get_selected_operation_id(self):
        for button in self.ui.groupBox.findChildren(QRadioButton):
            if button.isChecked():
                return button.property("id")
        return None

    # Метод для получения выбранного ID взноса
    def get_selected_contribution_id(self):
        for checkbox in self.ui.groupBox_2.findChildren(QCheckBox):
            if checkbox.isChecked():
                return checkbox.property("id")
        return None

# Функция для вызова процедуры CalculateEarnings и вывода результата на форму
def calculate_earnings(position_id, operation_id, contribution_id):
    try:
        print(f"position_id: {position_id}, operation_id: {operation_id}, contribution_id: {contribution_id}")  # Отладочный вывод

        conn = mysql.connector.connect(host='localhost', user='root', database='SalaryAccounting')
        cursor = conn.cursor()

        # Вызов процедуры CalculateEarnings
        cursor.callproc('CalculateEarnings4', (position_id, operation_id, contribution_id))

        # Получение результатов
        for result in cursor.stored_results():
            for row in result.fetchall():
                position_title, total_amount = row
                QMessageBox.information(None, "Результат расчета", f"Должность: {position_title}, Сумма рассчета: {total_amount}")

        cursor.close()
        conn.close()
    except mysql.connector.Error as err:
        QMessageBox.critical(None, "Ошибка", str(err))


if __name__ == "__main__":
    import sys

    # Инициализация приложения и отображение главного окна
    app = QApplication(sys.argv)
    window = MainWindow()
    window.show()
    sys.exit(app.exec())
