import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:historical_guide/core/services/interfaces/i_database_repository.dart';
import 'package:historical_guide/ui/views/maps/opacity_controller/opacity_controller.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import '../models/map_referece.dart';

class MapService extends ChangeNotifier {
  static MapReference get todayMap => MapReference(
        id: 'today',
        name: 'OpenStreetMap',
        year: 2022,
        key: 'today',
        reference100: 'cl1ntkeuh000814p61hbxkegk',
        reference50: 'cl1ntkeuh000814p61hbxkegk',
      );
  // MapService({required IDatabaseRepository databaseRepository})
  //     : _databaseRepository = databaseRepository;

  void update(IDatabaseRepository databaseRepository) {
    _databaseRepository = databaseRepository;
  }

  late IDatabaseRepository _databaseRepository;

  LatLng currentPosition = const LatLng(50.941303, 6.958138);
  double currentZoom = 16;

  List<MapReference> _maps = [];

  List<MapReference> get maps => _maps;

  MapReference? _currentMap;
  int _visibilityIndex = OpacityController.divisions;

  MapReference get currentMap => _currentMap ?? MapService.todayMap;

  String get currentStyle {
    if (_currentMap == null) {
      return ('${dotenv.env['MAPBOX_STYLES']}/cl1ntkeuh000814p61hbxkegk');
    }

    switch (_visibilityIndex) {
      case 0:
        return ('${dotenv.env['MAPBOX_STYLES']}/cl1ntkeuh000814p61hbxkegk');
      case 1:
        return ('${dotenv.env['MAPBOX_STYLES']}/${_currentMap!.reference50}');
      default:
        return ('${dotenv.env['MAPBOX_STYLES']}/${_currentMap!.reference100}');
    }
  }

  int get currentMapMode => _visibilityIndex;

  void setCurrentMapWithIndex(int index) {
    _currentMap = _maps[index];
    if (_visibilityIndex == 0) {
      _visibilityIndex = OpacityController.divisions;
    }
    notifyListeners();
  }

  Future<void> getMapReferences() async {
    _maps = await _databaseRepository.getMapReferences();
    _maps.sort((m1, m2) => m1.year.compareTo(m2.year));
    _maps.add(MapService.todayMap);
    _currentMap = maps.last;
    notifyListeners();
  }

  void setVisibilityIndex(int value) {
    _visibilityIndex = value;
  }

  Future<Map<String, dynamic>> getPhotos(Map<String, String> parameters) async {
    final geoJson = await _databaseRepository.getPhotos(parameters);
    return geoJson;
  }
}
