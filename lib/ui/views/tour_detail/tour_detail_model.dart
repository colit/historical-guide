import '../../../core/models/tour.dart';
import '../../../core/services/map_service.dart';
import '../../../core/services/tour_service.dart';
import '../../base/base_model.dart';
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

  Tour? _tour;
  String? _tourId;
  MapboxMapController? _controller;

  void onMapCreated(MapboxMapController controller, String tourId) {
    _controller = controller;
    _tourId = tourId;
  }

  void onStyleLoadedCallback() {
    if (_tourId != null) {
      _tourService.getTourData(_tourId!).then((tour) {
        _tour = tour;
        // zoom to current tour
        _controller?.animateCamera(
          CameraUpdate.newLatLngBounds(
            LatLngBounds(
              northeast:
                  LatLng(tour.boundsNE.latitude, tour.boundsNE.longitude),
              southwest:
                  LatLng(tour.boundsSW.latitude, tour.boundsSW.longitude),
            ),
          ),
        );
        // show vector is exists
        if (tour.vectorAssets != null) {
          print(tour.vectorAssets);
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
                // const LineLayerProperties(
                //   lineColor: '#018b00',
                //   lineWidth: 3.0,
                // ),
              );
              // notifyListeners();
            },
          );
        }
      });
    }
  }

  void _onMapChanged() {}

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
    _mapService.removeListener(_onMapChanged);
    super.dispose();
  }
}
