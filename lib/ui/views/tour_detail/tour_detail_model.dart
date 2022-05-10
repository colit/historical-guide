import 'package:historical_guides_commons/historical_guides_commons.dart';

import '../../../core/services/map_service.dart';
import '../../../core/services/tour_service.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

class TourDetailModel extends BaseModel {
  TourDetailModel({
    required MapService mapService,
    required TourService tourService,
  })  : _mapService = mapService,
        _tourService = tourService {
    _mapService.addListener(_onMapChanged);
  }
  final MapService _mapService;
  final TourService _tourService;

  late Tour _tour;
  String? _tourId;
  MapboxMapController? _controller;

  int? _currentStationId;
  int? get currentStationId => _currentStationId;

  bool _tourLoaded = false;
  bool get tourLoaded => _tourLoaded;

  Tour get tour => _tour;

  void _onFeatureTipped(id, _, __) {
    _currentStationId = id;
    final point = _tour.stations[id].position;
    _mapService.setZoomOn(LatLng(point.latitude, point.longitude));
    _mapService.currentStationIndex = id;
    notifyListeners();
  }

  void onMapCreated(MapboxMapController controller, String tourId) {
    _controller = controller;
  }

  void onStyleLoadedCallback() {
    _controller?.onFeatureTapped.add(_onFeatureTipped);
    if (_tourId != null) {
      // zoom to current tour
      _controller?.animateCamera(
        CameraUpdate.newLatLngBounds(
          LatLngBounds(
            northeast: LatLng(tour.boundsNE.latitude, tour.boundsNE.longitude),
            southwest: LatLng(tour.boundsSW.latitude, tour.boundsSW.longitude),
          ),
          left: 50,
          right: 50,
          top: 50,
          bottom: 50,
        ),
      );
      // show vector is exists
      if (tour.vectorAssets != null) {
        _controller
            ?.addSource(
          'sourceVector',
          GeojsonSourceProperties(data: tour.vectorAssets),
        )
            .then(
          (value) {
            _controller?.addLayer(
              'sourceVector',
              'poygon-layer',
              const FillLayerProperties(
                fillColor: '#867950',
                fillOpacity: 0.5,
              ),
            );
          },
        );
      }
      // show track
      _controller
          ?.addSource(
        'sourceTrack',
        GeojsonSourceProperties(
          data: tour.geoJSON,
        ),
      )
          .then((value) {
        _controller?.addLayer(
          'sourceTrack',
          'track-layer-background',
          const LineLayerProperties(
            lineColor: '#ffffff',
            lineWidth: 10.0,
          ),
        );
        _controller?.addLayer(
          'sourceTrack',
          'track-layer',
          const LineLayerProperties(
            lineColor: '#018b00',
            lineWidth: 4.0,
          ),
        );
      });
      // show Points of Interest
      _controller
          ?.addSource(
        'sourcePoints',
        GeojsonSourceProperties(
          data: tour.stationsAsGeoJson,
        ),
      )
          .then((_) {
        _controller?.addLayer(
          'sourcePoints',
          'points-layer',
          const CircleLayerProperties(circleColor: '#018b00', circleRadius: 10),
        );
      });
    }
  }

  void _onMapChanged() {
    _controller?.animateCamera(
      CameraUpdate.newCameraPosition(
        CameraPosition(
          target: _mapService.currentPosition,
          zoom: _mapService.currentZoom,
        ),
      ),
    );
  }

  // void getTourData(String id) {
  //   setState(ViewState.busy);
  //   _tourService.getTourData(id).then((tour) {
  //     _tour = tour;
  //     setState(ViewState.idle);
  //   });
  // }

  get currentPosition => _mapService.currentPosition;

  get currentZoom => _mapService.currentZoom;

  get currentStyle => _mapService.currentStyle;

  @override
  void dispose() {
    _mapService.cleanCurrentStationIndex();
    _mapService.removeListener(_onMapChanged);
    super.dispose();
  }

  void initModel(String id) {
    _tourId = id;
    setState(ViewState.busy);
    _tourService.getTourData(_tourId!).then((tour) {
      _tour = tour;
      _tourLoaded = true;
      // HtmlElementViewController().reset();
      setState(ViewState.idle);
    });
  }
}
