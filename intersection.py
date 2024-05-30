from qgis.core import QgsVectorLayer, QgsField, QgsFeature, QgsGeometry, QgsSymbol, QgsSingleSymbolRenderer
from qgis.PyQt.QtCore import QVariant

layer = iface.activeLayer()

layer_name = layer.name()

# Создаем имя нового слоя (Intersection + имя предыдущего слоя)
intersection_layer_name = f"Intersection_{layer_name}"

# Создаем временный слой для пересечений
intersection_layer = QgsVectorLayer("Polygon?crs=" + layer.crs().authid(), intersection_layer_name, "memory")
QgsProject.instance().addMapLayer(intersection_layer)

# Создаем поле для идентификатора пересечений
intersection_layer.addAttribute(QgsField('id', QVariant.Int))

# Перебираем полигоны текущего слоя и проверяем их пересечения с другими полигонами
feats = []
for i, feat1 in enumerate(layer.getFeatures()):
    geom1 = feat1.geometry()
    for feat2 in layer.getFeatures():
        geom2 = feat2.geometry()
        if feat1.id() != feat2.id() and geom1.intersects(geom2):
            intersection = geom1.intersection(geom2)
            if intersection:
                new_feat = QgsFeature()
                new_feat.setGeometry(intersection)
                new_feat.setAttributes([i])
                feats.append(new_feat)

# Добавляем полученные пересечения в слой
intersection_layer.dataProvider().addFeatures(feats)

# Обновляем кэш слоя
intersection_layer.updateExtents()

# Устанавливаем стиль для нового слоя
symbol = QgsFillSymbol.createSimple({'color': '255,0,0,127', 'style': 'solid'})
renderer = QgsSingleSymbolRenderer(symbol)
intersection_layer.setRenderer(renderer)

# Переместим новый слой наверх, чтобы он отобразился поверх исходного слоя
intersection_layer.setOpacity(0.5)  # Прозрачность
intersection_layer.triggerRepaint()
