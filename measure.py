import psycopg2
import random
from datetime import datetime, timedelta

# Подключение к базе данных
conn = psycopg2.connect(
    user="postgres",
    password="admin",
    host="localhost",
    port="5432",
    database="testGeo",
    client_encoding="utf8"
)
cursor = conn.cursor()

# Удаляем таблицу, если она существует
cursor.execute("DROP TABLE IF EXISTS values CASCADE;")

# Создаем таблицу, если она не существует
cursor.execute("""
    CREATE TABLE IF NOT EXISTS values (
        id SERIAL PRIMARY KEY,
        points_id INTEGER,
        sensor VARCHAR(255),
        pm25 VARCHAR(255),
        pm10 VARCHAR(255),
        temperature VARCHAR(255),
        pressure VARCHAR(255),
        CO2 VARCHAR(255),
        date DATE
    )
""")

# Получаем уникальные названия датчиков
cursor.execute("SELECT DISTINCT S.manufacturer FROM sensor_type AS S, measurement AS M WHERE S.ID=M.SENSOR_TYPE_ID")
sensors = cursor.fetchall()

# Определяем коэффициенты для каждого датчика
coefficients = {
    'Thermokon': {'pm25': 1.5, 'pm10': 0.5, 'temperature': 2.0, 'pressure': 1.0, 'co2': 1.2},
    'Pure Air': {'pm25': 2.0, 'pm10': 1.3, 'temperature': 1.8, 'pressure': 1.5, 'co2': 1.6},
    'Атмосфера': {'pm25': 1.8, 'pm10': 1.7, 'temperature': 1.6, 'pressure': 1.3, 'co2': 1.4}
}

# Проходимся по каждому датчику и получаем значения
for sensor in sensors:
    sensor_name = sensor[0]
    cursor.execute("""
        SELECT M.pm25, M.pm10, M.temperature, M.pressure, M.co2, M.points_id, S.manufacturer, M.date
        FROM measurement AS M
        JOIN sensor_type AS S ON M.sensor_type_id = S.id
        WHERE S.manufacturer = %s
    """, (sensor_name,))

    measures = cursor.fetchall()
    print(measures)
    # Применяем коэффициенты и округляем значения
    for measure_row in measures:
        final_measurements = []
        for measure, column in zip(measure_row[:-2], ['pm25', 'pm10', 'temperature', 'pressure', 'co2']):
            coefficient = coefficients[sensor_name][column]
            signed_measure = round(float(measure) * abs(coefficient), 2) if measure is not None else None
            if column == 'temperature':
                if signed_measure is None:
                    signed_temperature = None
                elif signed_measure == 0:
                    signed_temperature = '0'
                elif signed_measure > 0:
                    signed_temperature = f"+{signed_measure}"
                else:
                    signed_temperature = f"{signed_measure}"
                signed_measure = signed_temperature
            final_measurements.append(signed_measure)
        final_measurements.extend(measure_row[-3:])  # Добавляем дату и point_id
        print(final_measurements)
        # Вставляем обновленные значения обратно в базу данных
        cursor.execute("""
            INSERT INTO values ("pm25", "pm10", temperature, pressure, co2, points_id, sensor, date)
            VALUES (%s, %s, %s, %s, %s, %s, %s, %s)
        """, tuple(final_measurements))

conn.commit()
conn.close()