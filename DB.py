# DB.py

import mysql.connector

# Устанавливаем соединение с базой данных
conn = mysql.connector.connect(host='localhost', user='root', database='SalaryAccounting')

# Функция для выбора всех должностей из базы данных
def select_positions():
    try:
        cursor = conn.cursor()
        cursor.execute("SELECT id, title FROM Positions")
        positions = cursor.fetchall()
        cursor.close()
        return positions
    except mysql.connector.Error as err:
        raise err

# Функция для выбора всех операций из базы данных
def select_operations():
    try:
        cursor = conn.cursor()
        cursor.execute("SELECT id, title FROM Operations")
        operations = cursor.fetchall()
        cursor.close()
        return operations
    except mysql.connector.Error as err:
        raise err

# Функция для выбора всех страховых типов из базы данных
def select_insurance_types(position_id):
    try:
        cursor = conn.cursor()
        query = """
        SELECT it.id, it.title, it.amount 
        FROM InsuranceTypes it 
        JOIN PositionsInsurance pi ON it.id = pi.insurance_type_id 
        WHERE pi.positions_id = %s
        """
        cursor.execute(query, (position_id,))
        insurance_types = cursor.fetchall()
        cursor.close()
        return insurance_types
    except mysql.connector.Error as err:
        raise err


def calculate_write(position_id, operation_id, contribution_id):
    try:
        conn = mysql.connector.connect(host='localhost', user='root', database='SalaryAccounting')
        cursor = conn.cursor()

        # Вызов процедуры CalculateWrite
        cursor.callproc('CalculateWrite', (position_id, operation_id, contribution_id))

        conn.commit()
        cursor.close()
        conn.close()
        return True
    except mysql.connector.Error as err:
        print("Error:", err)
        return False