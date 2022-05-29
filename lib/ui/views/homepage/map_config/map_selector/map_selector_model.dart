import 'package:flutter/material.dart';
import 'package:historical_guide/core/models/map_referece.dart';
import 'package:historical_guide/core/services/map_service.dart';
import 'package:historical_guides_commons/historical_guides_commons.dart';

class MapSelectorModel extends BaseModel {
  MapSelectorModel({required MapService mapService}) : _mapService = mapService;
  final MapService _mapService;

  List<MapReference> get maps => _mapService.maps;

  PageController? _pageController;
  int? _selectedMapIndex;
  int get selectedMapIndex =>
      _selectedMapIndex ??
      _mapService.maps
          .indexWhere((element) => element.id == _mapService.currentMap.id);

  PageController getPageController({required double width}) {
    _pageController = PageController(
      viewportFraction: 180 / width,
      initialPage: selectedMapIndex,
    );
    return _pageController!;
  }

  @override
  void dispose() {
    _pageController?.dispose();
    super.dispose();
  }

  void selectMap(int index) {
    if (index != _selectedMapIndex) {
      _selectedMapIndex = index;
      _mapService.setCurrentMapWithIndex(index);
      _pageController?.animateToPage(
        index,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
      notifyListeners();
    }
  }
}
