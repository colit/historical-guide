import 'package:flutter/material.dart';
import 'package:historical_guide/ui/views/maps/map_config/opacity_controller/opacity_controller_model.dart';
import 'package:historical_guides_commons/historical_guides_commons.dart';
import 'package:provider/provider.dart';

import '../../../../../core/services/map_service.dart';
import '../../map_selector_plus/widgets/map_opacity_controller_widget.dart';

class OpacityControllerView extends StatelessWidget {
  const OpacityControllerView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: kColorWhite,
        borderRadius: BorderRadius.all(Radius.circular(6)),
      ),
      clipBehavior: Clip.antiAlias,
      child: BaseWidget<OpacityControllerModel>(
          model: OpacityControllerModel(
            mapService: context.read<MapService>(),
          ),
          builder: (context, model, _) {
            return Row(
              children: [
                MapOpacityControllerButton(
                  selected: model.visibilityIndex ==
                      MapOpacityControllerWidget.indexHidden,
                  onTap: () => model
                      .onOpacityChanged(MapOpacityControllerWidget.indexHidden),
                  iconReference: 'images/icon-transparent.svg',
                  symanticLabel: 'Karte verstecken',
                ),
                MapOpacityControllerButton(
                  selected: model.visibilityIndex ==
                      MapOpacityControllerWidget.indexTansparent,
                  onTap: () => model.onOpacityChanged(
                      MapOpacityControllerWidget.indexTansparent),
                  iconReference: 'images/icon-semi-transparent.svg',
                  symanticLabel: 'Halbtransparent',
                ),
                MapOpacityControllerButton(
                  selected: model.visibilityIndex ==
                      MapOpacityControllerWidget.indexOpaque,
                  onTap: () => model
                      .onOpacityChanged(MapOpacityControllerWidget.indexOpaque),
                  iconReference: 'images/icon-opaque.svg',
                  symanticLabel: 'Komplett sichtbar',
                ),
              ],
            );
          }),
    );
  }
}
