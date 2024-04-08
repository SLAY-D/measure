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

# Создаем таблицу, если она не существует
cursor.execute("""
    CREATE TABLE IF NOT EXISTS values (
        id SERIAL PRIMARY KEY,
        sensor VARCHAR(255),
        measure VARCHAR(255),
        type VARCHAR(10)
    )
""")

# Получаем текущее максимальное значение id в таблице
cursor.execute("SELECT COALESCE(MAX(id), 0) FROM values")
max_id = cursor.fetchone()[0]

# Определяем коэффициенты для каждого датчика и типа
coefficients = {
    'Thermokon': {'pm2.5': 1.5, 'pm10': 0.5},
    'Pure Air': {'pm2.5': 2.0, 'pm10': 1.3},
    'Атмосфера': {'pm2.5': 1.8, 'pm10': 1.7}
}

# Получаем уникальные названия датчиков
cursor.execute("SELECT DISTINCT S.manufacturer FROM sensor_type AS S, measurement AS M WHERE S.ID=M.SENSOR_TYPE_ID")
sensors = cursor.fetchall()

# Проходимся по каждому датчику и типу и получаем значения measure
for sensor in sensors:
    sensor_name = sensor[0]
    for measure_type in ['pm2.5', 'pm10']:
        cursor.execute("""
            SELECT M.measurement
            FROM measurement AS M
            JOIN sensor_type AS S ON M.sensor_type_id = S.id
            WHERE S.manufacturer = %s AND S.type = %s
        """, (sensor_name, measure_type))
        measures = cursor.fetchall()
        # Применяем коэффициент и округляем значения
        coefficient = coefficients.get(sensor_name, {}).get(measure_type, 1.0)
        final_measurements = [(sensor_name, str(round(float(measure[0]) * coefficient, 2))) for measure in measures]
        # Вставляем обновленные значения обратно в базу данных
        for i, (sensor, measure) in enumerate(final_measurements):
            cursor.execute("INSERT INTO values (sensor, measure, type) VALUES (%s, %s, %s)",
                           (sensor, measure, measure_type))

conn.commit()
conn.close()