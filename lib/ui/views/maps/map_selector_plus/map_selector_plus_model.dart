import 'package:historical_guide/ui/base/base_model.dart';

import '../../../../core/models/map_referece.dart';
import '../../../../core/services/map_service.dart';

class MapsSelectorPlusModel extends BaseModel {
  MapsSelectorPlusModel({required MapService mapService})
      : _mapService = mapService {
    _mapService.addListener(_onMapsUpdate);
  }

  final MapService _mapService;

  void _onMapsUpdate() {
    notifyListeners();
  }

  List<MapReference> get maps => _mapService.maps;
  MapReference get currentMap => _mapService.currentMap;
  String get currentMapKey => _mapService.currentMap.key;
  int get currentMapMode => _mapService.currentMapMode;

  bool isSelected(int index) {
    return currentMap.key == maps[index].key;
  }

  void setCurrentMap(int index) {
    _mapService.setCurrentMapWithIndex(index);
  }

  @override
  void dispose() {
    _mapService.removeListener(_onMapsUpdate);
    super.dispose();
  }
}
