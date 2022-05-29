import 'package:flutter/material.dart';
import 'package:historical_guides_commons/historical_guides_commons.dart';
import 'package:provider/provider.dart';

import '../../../../../core/services/map_service.dart';
import '../widgets/year_list_item.dart';
import 'map_selector_model.dart';

class MapSelectorWidget extends StatelessWidget {
  const MapSelectorWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: ((context, constraints) => BaseWidget<MapSelectorModel>(
          model: MapSelectorModel(
            mapService: context.read<MapService>(),
          ),
          builder: (context, model, _) {
            final maps = model.maps;
            return PageView.builder(
              controller: model.getPageController(width: constraints.maxWidth),
              itemCount: maps.length,
              itemBuilder: (context, index) {
                return YearListItem(
                  map: maps[index],
                  index: index,
                  selected: index == model.selectedMapIndex,
                  onMapChanged: (index) => model.selectMap(index),
                );
              },
            );
          })),
    );
  }
}
