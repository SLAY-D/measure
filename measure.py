import psycopg2

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

# # Создаем таблицу, если она не существует
# cursor.execute("""
#     CREATE TABLE IF NOT EXISTS values (
#         id SERIAL PRIMARY KEY,
#         sensor VARCHAR(255),
#         pm2.5 VARCHAR(255),
#         pm10 VARCHAR(255),
#         temperature VARCHAR(255),
#         pressure VARCHAR(255),
#         CO2 VARCHAR(255)
#     )
# """)

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
        SELECT M.pm25, M.pm10, M.temperature, M.pressure, M.co2
        FROM measurement AS M
        JOIN sensor_type AS S ON M.sensor_type_id = S.id
        WHERE S.manufacturer = %s
    """, (sensor_name,))
    measures = cursor.fetchall()
    # Применяем коэффициенты и округляем значения
    for measure_row in measures:
        final_measurements = [round(float(measure) * coefficients[sensor_name][column], 2) if measure is not None else None for measure, column in zip(measure_row, ['pm25', 'pm10', 'temperature', 'pressure', 'co2'])]
        # Вставляем обновленные значения обратно в базу данных
        cursor.execute("""
            INSERT INTO values (id, sensor, pm25, pm10, temperature, pressure, co2)
            VALUES (DEFAULT, %s, %s, %s, %s, %s, %s)
        """, (sensor_name,) + tuple(final_measurements))

conn.commit()
conn.close()