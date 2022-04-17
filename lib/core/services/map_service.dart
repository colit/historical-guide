import 'package:flutter/foundation.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:historical_guide/core/services/interfaces/i_database_repository.dart';
// import 'package:latlong2/latlong.dart' as latlng;
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

  bool _photosVisibility = true;
  bool _toursVisibility = true;

  bool get photosVisibility => _photosVisibility;
  set photosVisibility(bool visibility) {
    _photosVisibility = visibility;
    notifyListeners();
  }

  bool get toursVisibility => _toursVisibility;
  set toursVisibility(bool visibility) {
    _toursVisibility = visibility;
    notifyListeners();
  }

  // MapService({required IDatabaseRepository databaseRepository})
  //     : _databaseRepository = databaseRepository;

  void update(IDatabaseRepository databaseRepository) {
    _databaseRepository = databaseRepository;
  }

  late IDatabaseRepository _databaseRepository;

  LatLngBounds? _mapBounds;

  List<MapReference> _maps = [];

  MapReference? _currentMap;
  int _visibilityIndex = 2;
  LatLng _currentPosition = const LatLng(50.941303, 6.958138);
  double _currentZoom = 16;

  MapReference get currentMap => _currentMap ?? MapService.todayMap;
  List<MapReference> get maps => _maps;
  LatLngBounds? get mapBounds => _mapBounds;
  LatLng get currentPosition => _currentPosition;
  double get currentZoom => _currentZoom;

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
    _visibilityIndex = 2;
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
    notifyListeners();
  }

  Future<Map<String, dynamic>> getPhotos(Map<String, String> parameters) async {
    final geoJson = await _databaseRepository.getPhotos(parameters);
    return geoJson;
  }

  void zoomOnCurrentMap() {
    if (_currentMap != null) {
      final boundsSW = _currentMap!.boundsSW;
      final boundsNE = _currentMap!.boundsNE;
      if (boundsSW != null && boundsNE != null) {
        _mapBounds = LatLngBounds(
          southwest: LatLng(
            boundsSW.latitude,
            boundsSW.longitude,
          ),
          northeast: LatLng(
            boundsNE.latitude,
            boundsNE.longitude,
          ),
        );
      }
      _visibilityIndex = 2;
      notifyListeners();
    }
  }

  void updateCameraPosition(LatLng camera, double zoom) {
    _currentPosition = camera;
    _currentZoom = zoom;
    _mapBounds = null;
  }
}
