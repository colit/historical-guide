import 'package:flutter/material.dart';
import 'package:historical_guides_commons/historical_guides_commons.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

import '../../../core/services/map_service.dart';

class TourStationsModel extends BaseModel {
  TourStationsModel({required MapService mapService})
      : _mapService = mapService;
  final MapService _mapService;
  final PageController _pageController = PageController(
    viewportFraction: 0.8,
  );

  PageController get pageController => _pageController;

  void pageChanged(PointOfInterest poi) {
    _mapService.setZoomOn(LatLng(
      poi.position.latitude,
      poi.position.longitude,
    ));
  }
}
