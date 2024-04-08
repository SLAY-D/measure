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

# Генерация и вставка рандомных данных
for _ in range(100):  # Произвольное количество строк, которые вы хотите добавить
    points_id = random.randint(1, 25)
    sensor_characteristic_id = 1
    sensor_type_id = random.randint(1, 3)
    date = datetime.now() - timedelta(days=random.randint(0, 365))
    pm25 = random.uniform(10, 35)
    pm10 = random.uniform(25, 100)
    temperature = random.uniform(-40, 40)
    pressure = random.uniform(730, 780)
    co2 = random.uniform(500, 2000)

    cursor.execute("""
        INSERT INTO measurement (points_id, sensor_characteristic_id, sensor_type_id, date, pm25, pm10, temperature, pressure, co2)
        VALUES (%s, %s, %s, %s, %s, %s, %s, %s, %s)
    """, (points_id, sensor_characteristic_id, sensor_type_id, date, pm25, pm10, temperature, pressure, co2))

conn.commit()
conn.close()