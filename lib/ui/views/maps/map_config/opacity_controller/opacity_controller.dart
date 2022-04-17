import 'package:flutter/material.dart';
import 'package:historical_guide/ui/base/base_widget.dart';
import 'package:historical_guide/ui/views/maps/map_config/opacity_controller/opacity_controller_model.dart';

import '../../../../commons/theme.dart';
import '../../map_selector_plus/widgets/map_opacity_controller_widget.dart';

class OpacityControllerWidget extends StatelessWidget {
  const OpacityControllerWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: kColorWhite,
        borderRadius: BorderRadius.all(Radius.circular(6)),
      ),
      clipBehavior: Clip.antiAlias,
      child: BaseWidget<OpacityControllerModel>(
          model: OpacityControllerModel(),
          builder: (context, model, _) {
            return Row(
              children: [
                MapOpacityControllerButton(
                  selected: model.visibilityIndex ==
                      MapOpacityControllerWidget.indexHidden,
                  onTap: () => model
                      .onOpacityChanged(MapOpacityControllerWidget.indexHidden),
                  iconReference: 'images/icon-hidden.svg',
                  symanticLabel: 'Karte verstecken',
                ),
                MapOpacityControllerButton(
                  selected: model.visibilityIndex ==
                      MapOpacityControllerWidget.indexTansparent,
                  onTap: () => model.onOpacityChanged(
                      MapOpacityControllerWidget.indexTansparent),
                  iconReference: 'images/icon-transparent.svg',
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
