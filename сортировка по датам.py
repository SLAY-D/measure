from qgis.core import QgsProject, QgsVectorLayer, QgsField, QgsFeature, QgsGeometry, QgsSymbol, QgsSingleSymbolRenderer
from qgis.PyQt.QtGui import QColor
from qgis.PyQt.QtCore import QVariant
from qgis.core import QgsPalLayerSettings

# Получение слоя точек
points_layer = QgsProject.instance().mapLayersByName('points')[0]

# Получение индекса поля с ID точки
points_id_index = points_layer.fields().indexFromName('id')

# Получение слоя измерений
measurements_layer = QgsProject.instance().mapLayersByName('values')[0]

# Получение уникальных значений дат
dates = measurements_layer.uniqueValues(measurements_layer.fields().indexFromName('date'))

# Преобразование объектов QDate в строки
dates = [str(date.toString('yyyy-MM-dd')) for date in dates]

# Создание нового поля для хранения параметра pm25
pm25_field = QgsField('PM25', QVariant.Double)

# Проход по каждой дате
for date in dates:
    print(date)
    # Создание уникального имени слоя на основе даты
    layer_name = f"Радиус загрязнения_{date}"

    # Создание временного слоя для хранения круговых геометрий с уникальным именем
    circle_layer = QgsVectorLayer("Polygon?crs=" + points_layer.crs().authid(), layer_name, "memory")
    QgsProject.instance().addMapLayer(circle_layer)

    # Создание нового поля для хранения радиуса
    radius_field = QgsField('Radius', QVariant.Int)
    circle_layer.addAttribute(radius_field)

    # Создание нового поля для хранения параметра pm25
    pm25_field = QgsField('PM25', QVariant.Double)
    circle_layer.addAttribute(pm25_field)

    # Получение измерений, относящихся к текущей дате
    date_filter = '"date" = \'' + date + '\''
    measurements = measurements_layer.getFeatures(date_filter)
    
    # Проход по всем объектам в слое точек
    for point_feature in points_layer.getFeatures():
        # Получение ID точки
        point_id = point_feature.attributes()[points_id_index]

        # Фильтрация измерений по ID точки        
        point_measurements = []
        for m in measurements_layer.getFeatures(QgsFeatureRequest().setFilterExpression("\"date\" = '{}' AND \"points_id\" = {}".format(date, point_id))):
            if m['pm25'] is None:  # Проверяем, равно ли значение NULL
                continue
            point_measurements.append(m)
            
        # Определение радиуса в зависимости от максимального измерения
        if point_measurements:  # Проверяем, что список point_measurements не пустой
            max_measurement = max([float(str(m['pm25'])) for m in point_measurements if m['pm25'] is not None and str(m['pm25']) != 'NULL'])
            if max_measurement < 20:
                radius = max_measurement * 5
            elif max_measurement < 30:
                radius = max_measurement * 10
            else:
                radius = max_measurement * 20
        else:
            # Если point_measurements пустой, устанавливаем радиус равным 0 или другому значению по умолчанию
            radius = 0  # Или другое значение по умолчанию

        # Создание круговой геометрии вокруг точки с учетом радиуса
        circle_geometry = point_feature.geometry().buffer(radius, 30)

        # Создание нового объекта круга с соответствующим радиусом
        circle_feature = QgsFeature()
        circle_feature.setGeometry(circle_geometry)
        circle_feature.setAttributes([radius, max_measurement if point_measurements else 0])

        # Добавление круга в слой
        circle_layer.dataProvider().addFeatures([circle_feature])

    # Обновление кэша слоя
    circle_layer.updateExtents()

    # Установка стиля кругового слоя
    symbol = QgsFillSymbol.createSimple({'color': '255,255,60,51', 'style': 'solid', 'style_border': 'solid', 'width_border': '0.2'})
    renderer = QgsSingleSymbolRenderer(symbol)
    circle_layer.setRenderer(renderer)

    # Включение взаимодействия с объектами для отображения значений pm25 при наведении на окружность
    settings = QgsPalLayerSettings()
    settings.fieldName = 'PM25'
    settings.enabled = True
    settings.placement = QgsPalLayerSettings.OverPoint
    text_format = QgsTextFormat()
    text_format.setColor(QColor("black"))
    text_format.setSize(10)
    settings.setFormat(text_format)
    circle_layer.setLabeling(QgsVectorLayerSimpleLabeling(settings))
    circle_layer.setLabelsEnabled(True)

    # Обновление отображения
    circle_layer.triggerRepaint()
