import 'package:historical_guide/core/models/map_referece.dart';
import 'package:historical_guide/core/models/track.dart';
import 'package:historical_guide/core/services/map_service.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import '../../../core/models/map_point.dart';
import '../../../core/services/tour_service.dart';
import '../../base/base_model.dart';

class MapsModel extends BaseModel {
  static const String kPhotoSourceId = 'PHOTOS';
  static const String kTrackSourceId = 'TRACK';
  MapsModel({
    required MapService mapService,
    required TourService tourService,
  })  : _mapService = mapService,
        _tourService = tourService {
    _mapService.addListener(_onMapChanged);
  }
  final MapService _mapService;
  final TourService _tourService;

  late MapboxMapController _controller;

  LatLng get currentPosition => _mapService.currentPosition;
  double get currentZoom => _mapService.currentZoom;
  MapPoint? get selectedPoint => _selectedPoint;

  static const map1964 = '1964_AmtlPlan_3857';

  String? _currentLayerId;
  MapPoint? _selectedPoint;

  String get currentStyle {
    return _mapService.currentStyle;
  }

  List<String> _sources = [];
  List<String> _layers = [];

  Tour? _selectedTour;

  List<MapReference> get maps => _mapService.maps;

  bool _mapIsReady = false;

  bool isSetupVisible = false;

  void _updateCameraPosition(succes) {
    if (succes ?? false) {
      final target = _controller.cameraPosition?.target;
      final zoom = _controller.cameraPosition?.zoom;
      if (target != null && zoom != null) {
        _mapService.updateCameraPosition(target, zoom);
      }
    }
  }

  void _onMapChanged() {
    if (_mapService.mapBounds != null) {
      _controller
          .animateCamera(
            CameraUpdate.newLatLngBounds(_mapService.mapBounds!),
          )
          .then(_updateCameraPosition);
    }
    notifyListeners();
  }

  void _onCircleTapped(Circle circle) {
    if (circle.data == null) return;
    final tour = Tour.fromMap(circle.data!);

    _selectedTour = tour.id == _selectedTour?.id ? null : tour;

    if (_selectedTour != null) {
      _controller
          .animateCamera(
            CameraUpdate.newLatLngBounds(
              LatLngBounds(
                southwest: LatLng(
                  _selectedTour!.boundsSW.latitude,
                  _selectedTour!.boundsSW.longitude,
                ),
                northeast: LatLng(
                  _selectedTour!.boundsNE.latitude,
                  _selectedTour!.boundsNE.longitude,
                ),
              ),
              left: 40,
              right: 40,
              top: 40,
              bottom: 40,
            ),
          )
          .then(_updateCameraPosition);
    }

    for (final circle in _controller.circles) {
      _controller.updateCircle(
        circle,
        CircleOptions(
            circleColor: circle.data?['objectId'] == _selectedTour?.id
                ? '#018b00'
                : '#e200ff'),
      );
    }

    _removeTrack();
    if (_selectedTour != null) {
      _addTrack();
    }
  }

  void _onFeatureTapped(id, point, __) {
    _controller
        .queryRenderedFeatures(point, ["photo-points"], null)
        .then((value) {
      if (value.isNotEmpty) {
        cleanMap();
        final geojson = value.first;
        final uuid = geojson['properties']['uuid'] as int;
        final coordinates = List<double>.from(
          geojson['geometry']['coordinates'],
        );
        final position = LatLng(coordinates[1], coordinates[0]);
        _controller
            .animateCamera(CameraUpdate.newLatLng(position))
            .then(_updateCameraPosition);
        _selectedPoint = MapPoint(
          id: uuid,
        );
        notifyListeners();
      }
    });
  }

  Future<void> _addTrack() async {
    if (_selectedTour == null) return;
    final sourceId = _selectedTour!.id;
    if (!_sources.contains(sourceId)) {
      await _controller.addSource(
        sourceId,
        GeojsonSourceProperties(data: _selectedTour!.geoJSON),
      );
      _sources.add(sourceId);
    }
    await _controller.addLayer(
      sourceId,
      "track-line",
      const LineLayerProperties(
        lineColor: '#018b00',
        lineWidth: 3.0,
      ),
    );
  }

  void _removeTrack() {
    _controller.removeLayer("track-line");
  }

  void _addCircles(List<Tour> tours) {
    _controller.addCircles(
      tours.map((tour) {
        return CircleOptions(
          geometry: LatLng(
            tour.startPoint.latitude,
            tour.startPoint.longitude,
          ),
          circleRadius: 16,
          circleColor: '#e200ff',
        );
      }).toList(),
      tours.map((tour) => tour.toMap()).toList(),
    );
  }

  void _getFotos(LatLngBounds bounds) {
    const pad = 0.2;
    final neLat = bounds.northeast.latitude;
    final neLng = bounds.northeast.longitude;
    final swLat = bounds.southwest.latitude;
    final swLng = bounds.southwest.longitude;
    final padLat = (neLat - swLat) * pad;
    final padLng = (neLng - swLng) * pad;
    final parameters = {
      'neLatitude': (neLat + padLat).toString(),
      'neLongitude': (neLng + padLng).toString(),
      'swLatitude': (swLat - padLat).toString(),
      'swLongitude': (swLng - padLng).toString(),
      'yearFrom': '0',
      'yearTill': '3000',
    };
    _mapService.getPhotos(parameters).then((geoJson) {
      _controller.setGeoJsonSource(kPhotoSourceId, geoJson);
    });
  }

  Future<void> _createSources() async {
    await _controller.addSource(
      kPhotoSourceId,
      const GeojsonSourceProperties(
        cluster: true,
        clusterMaxZoom: 14,
        clusterRadius: 50,
        clusterProperties: {
          'uuid': [
            Expressions.max,
            [Expressions.get, 'uuid']
          ],
        },
      ),
    );

    // Symbols Layer
    await _controller.addLayer(
      kPhotoSourceId,
      "photo-points",
      const SymbolLayerProperties(
        iconImage: [
          Expressions.caseExpression,
          [
            Expressions.boolean,
            [Expressions.has, 'point_count'],
            false
          ],
          'images/photo-point-cluster.png',
          'images/photo-point.png',
        ],
        iconSize: [
          Expressions.caseExpression,
          [
            Expressions.boolean,
            [Expressions.has, 'point_count'],
            false
          ],
          0.6,
          0.5,
        ],
        iconAllowOverlap: true,
        symbolSortKey: 10.0,
      ),
    );

    await _controller.addLayer(
      kPhotoSourceId,
      "photos-count",
      const SymbolLayerProperties(
        textField: [Expressions.get, 'point_count_abbreviated'],
        textFont: ['DIN Offc Pro Medium', 'Arial Unicode MS Bold'],
        textSize: 14,
        textColor: '#FFFFFF',
      ),
    );
  }

  void onMapCreated(MapboxMapController controller) {
    _controller = controller;
  }

  void onStyleLoadedCallback() {
    _sources = [];
    _selectedTour = null;

    _createSources().then((_) {
      _controller.getVisibleRegion().then((value) => _getFotos(value));
    });

    _tourService.getToursList().then((value) => _addCircles(value));

    if (_mapIsReady) return;

    _controller.onCircleTapped.add(_onCircleTapped);
    _controller.onFeatureTapped.add(_onFeatureTapped);

    _mapService.getMapReferences().then((value) {
      showMap(_mapService.currentMap);
      _mapIsReady = true;
    });
  }

  void onCameraIdle() {
    final position = _controller.cameraPosition;
    if (position != null) {
      _mapService.updateCameraPosition(position.target, position.zoom);
    }
    _controller.getVisibleRegion().then((value) => _getFotos(value));
  }

  void showMap(MapReference map) async {
    notifyListeners();
  }

  void showMapWithOpacityIndex([int value = 1]) {
    _mapService.setVisibilityIndex(value);
    notifyListeners();
  }

  void cleanMap() {
    isSetupVisible = false;
    _selectedTour = null;
    _removeTrack();
    for (final circle in _controller.circles) {
      _controller.updateCircle(
        circle,
        const CircleOptions(circleColor: '#e200ff'),
      );
    }
    notifyListeners();
  }

  void removeSelectedImage() {
    _selectedPoint = null;
    notifyListeners();
  }

  @override
  void dispose() {
    _controller.onCircleTapped.remove(_onCircleTapped);
    _mapService.removeListener(_onMapChanged);
    super.dispose();
  }
}


// Cluster Layoer
    // await _controller.addLayer(
    //   kPhotoSourceId,
    //   "photo-clusters",
    //   const CircleLayerProperties(
    //     circleColor: [
    //       Expressions.step,
    //       [Expressions.get, 'point_count'],
    //       '#51bbd6',
    //       100,
    //       '#f1f075',
    //       750,
    //       '#f28cb1',
    //     ],
    //     circleRadius: [
    //       Expressions.step,
    //       [Expressions.get, 'point_count'],
    //       20,
    //       100,
    //       30,
    //       750,
    //       40
    //     ],
    //   ),
    // );

  // WORKING:
    // change color on zoom
    // Expressions.interpolate,
    //       ["linear"],
    //       [Expressions.zoom],
    //       10.0,
    //       '#00FF00',
    //       17.0,
    //       '#FF00FF',

     // if (!_sources.contains(mapKey)) {
    //   await _controller.addSource(
    //     map.key,
    //     RasterSourceProperties(
    //         tiles: [
    //           // https://mapwarper.net/maps/tile/40952/{z}/{x}/{y}.png,
    //           // 'https://mapwarper.net/maps/tile/39780/{z}/{x}/{y}.png', // 1800, John Stockdale
    //           // https://mapwarper.net/maps/tile/41691/{z}/{x}/{y}.png Kölner Stadtplan von 1752
    //           'https://mapwarper.net/maps/tile/56436/{z}/{x}/{y}.png' //Festungsplan
    //           // 'https://www.opendem.info/geoserver/gwc/service/wmts?service=WMTS&request=GetTile&version=1.0.0&layer=histo_3857:$mapKey&style=raster&format=image/png&tilematrixset=EPSG:900913&TileMatrix=EPSG:900913:{z}&TileRow={y}&TileCol={x}'
    //         ],
    //         tileSize: 512,
    //         attribution:
    //             'Historical map by <a target="_top" rel="noopener" href="https://www.museenkoeln.de/archaeologische-zone/">Archäologische Zone Köln</a>, under <a target="_top" rel="noopener" href="http://creativecommons.org/licenses/by/3.0">CC BY 3.0</a>. Data by <a target="_top" rel="noopener" href="http://openstreetmap.org">OpenStreetMap</a>, under <a target="_top" rel="noopener" href="http://creativecommons.org/licenses/by-sa/3.0">CC BY SA</a>'),
    //   );
    //   _sources.add(mapKey);
    //   print('source added');
    // }

    // addLayerWithOpacity();
