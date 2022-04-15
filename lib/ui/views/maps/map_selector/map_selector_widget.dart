import 'package:flutter/material.dart';
import 'package:historical_guide/core/models/map_referece.dart';
import 'package:historical_guide/core/services/map_service.dart';
import 'package:historical_guide/ui/base/base_model.dart';
import 'package:historical_guide/ui/base/base_widget.dart';
import 'package:historical_guide/ui/views/maps/map_selector/map_selector_model.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:provider/provider.dart';

import '../../../ui_styles.dart';

class MyCustomScrollBehavior extends MaterialScrollBehavior {
  // Override behavior methods like buildOverscrollIndicator and buildScrollbar
}

class MapSelectorWidget extends StatelessWidget {
  const MapSelectorWidget({
    Key? key,
    required this.onMapChaged,
    this.isVisible = false,
  }) : super(key: key);

  final Function(MapReference) onMapChaged;
  final bool isVisible;

  @override
  Widget build(BuildContext context) {
    final controller = ScrollController();
    return SizedBox(
      width: 350,
      height: 60,
      child: Stack(
        alignment: Alignment.center,
        children: [
          PointerInterceptor(
            intercepting: isVisible,
            child: Container(),
          ),
          if (isVisible)
            BaseWidget<MapSelectorModel>(
              model: MapSelectorModel(mapService: context.read<MapService>()),
              builder: (context, model, child) {
                return model.state == ViewState.busy
                    ? Container()
                    : Container(
                        clipBehavior: Clip.antiAlias,
                        decoration: UIStyles.floatingBoxDecoration,
                        child: ScrollConfiguration(
                          behavior: ScrollConfiguration.of(context)
                              .copyWith(scrollbars: true),
                          child: ListView.builder(
                              controller: controller,
                              scrollDirection: Axis.horizontal,
                              itemBuilder: ((context, index) {
                                return Material(
                                  color: model.isSelected(index)
                                      ? Colors.amber
                                      : Colors.white,
                                  child: InkWell(
                                    onTap: () {
                                      model.setCurrentMap(index);
                                      onMapChaged.call(model.currentMap);
                                    },
                                    child: SizedBox(
                                      width: 70,
                                      child: Center(
                                        child: Text(
                                          model.maps[index].year.toString(),
                                        ),
                                      ),
                                    ),
                                  ),
                                );
                              }),
                              itemCount: model.maps.length),
                        ),
                      );
              },
            ),
        ],
      ),
    );
  }
}
