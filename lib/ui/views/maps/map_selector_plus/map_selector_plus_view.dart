import 'package:flutter/material.dart';
import 'package:historical_guide/core/services/map_service.dart';
import 'package:historical_guide/ui/base/base_widget.dart';
import 'package:historical_guide/ui/views/maps/map_selector_plus/map_selector_plus_model.dart';
import 'package:provider/provider.dart';

import 'widgets/map_opacity_controller_widget.dart';
import 'widgets/map_selector_button_widget.dart';
import 'widgets/years_selector_widget.dart';

class MapSelectorPlusView extends StatefulWidget {
  const MapSelectorPlusView({
    Key? key,
    this.visible = true,
    this.onOpacityChanged,
  }) : super(key: key);

  static const contentWidth = 200.0;

  final bool visible;
  final void Function(int)? onOpacityChanged;

  @override
  State<MapSelectorPlusView> createState() => _MapSelectorPlusViewState();
}

class _MapSelectorPlusViewState extends State<MapSelectorPlusView>
    with TickerProviderStateMixin {
  var visible = false;

  late final AnimationController _animationController = AnimationController(
      vsync: this, duration: const Duration(milliseconds: 250))
    ..addListener(() => setState(() {}));

  late Animation<double> animation = Tween(
    begin: -MapSelectorPlusView.contentWidth,
    end: 0.0,
  ).animate(_animationController);

  @override
  Widget build(BuildContext context) {
    if (visible) {
      _animationController.forward();
    } else {
      _animationController.reverse();
    }
    return Transform.translate(
      offset: Offset(animation.value, 0),
      child: BaseWidget<MapsSelectorPlusModel>(
        model: MapsSelectorPlusModel(mapService: context.read<MapService>()),
        builder: (_, model, __) {
          return Stack(
            children: [
              Positioned(
                top: 84,
                left: MapSelectorPlusView.contentWidth,
                child: MapOpacityControllerWidget(
                  onOpacityChanged: widget.onOpacityChanged,
                  isVisible: (model.currentMapKey != 'today'),
                  visibilityIndex: model.currentMapMode,
                ),
              ),
              YearsSelectorWidget(
                maps: model.maps,
                selectedMapId: model.currentMap.id,
                onMapChanged: model.setCurrentMap,
              ),
              Positioned(
                top: 0,
                left: MapSelectorPlusView.contentWidth,
                child: MapSelectorButtonWidget(
                  active: visible,
                  year: model.currentMap.year,
                  onTap: () {
                    setState(() {
                      visible = !visible;
                    });
                  },
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}
