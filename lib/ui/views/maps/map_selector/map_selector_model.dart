import 'package:historical_guide/core/models/map_referece.dart';
import '../../../../core/services/map_service.dart';
import '../../../base/base_model.dart';

class MapSelectorModel extends BaseModel {
  MapSelectorModel({required MapService mapService}) : _mapService = mapService;

  final MapService _mapService;

  List<MapReference> get maps => _mapService.maps;
  MapReference get currentMap => _mapService.currentMap;

  bool isSelected(int index) {
    return currentMap.key == maps[index].key;
  }

  void setCurrentMap(int index) {
    _mapService.setCurrentMapWithIndex(index);
  }
}
