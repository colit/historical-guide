import 'package:flutter/material.dart';
import 'package:historical_guide/core/services/map_service.dart';
import 'package:provider/provider.dart';

import '../../../../../core/models/map_referece.dart';
import '../../../../commons/theme.dart';
import '../../../../ui_helpers.dart';
import '../../map_selector_plus/widgets/map_opacity_controller_widget.dart';
import '../opacity_controller/opacity_controller_view.dart';

class YearListItem extends StatelessWidget {
  const YearListItem({
    Key? key,
    required this.map,
    required this.index,
    this.onMapChanged,
    this.selected = false,
  }) : super(key: key);

  final void Function(int)? onMapChanged;
  final bool selected;
  final MapReference map;
  final int index;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 2),
      child: Container(
        height: 180,
        clipBehavior: Clip.antiAlias,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.all(Radius.circular(6)),
        ),
        child: Material(
          color: selected ? kColorPrimary : kColorWhite,
          child: InkWell(
            onTap: () => onMapChanged?.call(index),
            child: Padding(
              padding: const EdgeInsets.all(UIHelper.kHorizontalSpaceSmall),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                // crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    map.year.toString(),
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: selected ? kColorWhite : kColorPrimary,
                    ),
                  ),
                  UIHelper.verticalSpace(2),
                  Text(
                    map.name,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 14,
                      color: selected ? kColorWhite : kColorPrimary,
                    ),
                  ),
                  Expanded(child: Container()),
                  if (selected && map.id != 'today')
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.end,
                      children: [
                        Expanded(child: Container()),
                        const OpacityControllerView(),
                        UIHelper.horizontalSpace(4),
                        Container(
                          clipBehavior: Clip.antiAlias,
                          decoration: const BoxDecoration(
                              borderRadius:
                                  BorderRadius.all(Radius.circular(6))),
                          child: MapOpacityControllerButton(
                            onTap: () =>
                                context.read<MapService>().zoomOnCurrentMap(),
                            iconReference: 'images/icon-zoom.svg',
                            symanticLabel: 'Karte zoomen',
                          ),
                        ),
                        Expanded(child: Container()),
                      ],
                    ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
