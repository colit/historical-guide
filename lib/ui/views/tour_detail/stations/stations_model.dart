import 'package:flutter/material.dart';
import 'package:historical_guides_commons/historical_guides_commons.dart';
import 'package:mapbox_gl/mapbox_gl.dart';

import '../../../../core/services/map_service.dart';

class StationsModel extends BaseModel {
  StationsModel({required MapService mapService}) : _mapService = mapService {
    _mapService.addListener(_onMapChanged);
  }
  final MapService _mapService;
  final PageController _pageController = PageController(
    viewportFraction: 0.9,
  );

  PageController get pageController => _pageController;

  List<Station> _stations = [];
  int? _currentPageIndex;
  int get currentPageIndex => _currentPageIndex ?? 0;

  int get pointsCount => _stations.length;

  void _onMapChanged() {
    print('map changed with ${_mapService.currentStationIndex}');
    if (_mapService.currentStationIndex != _currentPageIndex) {
      _currentPageIndex = _mapService.currentStationIndex;
      if (_currentPageIndex != null) {
        _pageController.animateToPage(
          _currentPageIndex!,
          duration: const Duration(milliseconds: 500),
          curve: Curves.easeOut,
        );
        notifyListeners();
      }
    }
  }

  void _animateToPage(int index) {
    _mapService.currentStationIndex = index;
    // animate pages
    _pageController.animateToPage(
      index,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
    // animate map
    final poi = _stations[index];
    _mapService.setZoomOn(LatLng(
      poi.position.latitude,
      poi.position.longitude,
    ));
    notifyListeners();
  }

  void showPreviousStation() {
    if (_currentPageIndex != null) {
      _currentPageIndex = _currentPageIndex! - 1;
      if (_currentPageIndex! >= 0) {
        _animateToPage(_currentPageIndex!);
      }
    }
  }

  void showNextStation() {
    if (_currentPageIndex != null) {
      _currentPageIndex = _currentPageIndex! + 1;
      if (_currentPageIndex! < _stations.length) {
        _animateToPage(_currentPageIndex!);
      }
    }
  }

  void initModel(List<Station> stations) {
    _stations = stations;
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }
}
