import 'package:historical_guide/core/services/map_service.dart';
import 'package:historical_guides_commons/historical_guides_commons.dart';

class OpacityControllerModel extends BaseModel {
  OpacityControllerModel({required MapService mapService})
      : _mapService = mapService {
    _mapService.addListener(_onMapUpdate);
  }
  final MapService _mapService;

  late int _visibilityIndex = _mapService.currentMapMode;

  int get visibilityIndex => _visibilityIndex;

  void _onMapUpdate() {
    _visibilityIndex = _mapService.currentMapMode;
    notifyListeners();
  }

  void onOpacityChanged(int index) {
    _visibilityIndex = index;
    _mapService.setVisibilityIndex(index);
    notifyListeners();
  }

  @override
  void dispose() {
    _mapService.removeListener(_onMapUpdate);
    super.dispose();
  }
}
