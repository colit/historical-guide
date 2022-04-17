import 'package:flutter/material.dart';
import 'package:historical_guide/core/models/map_referece.dart';
import 'package:historical_guide/ui/ui_helpers.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import '../../../../commons/theme.dart';
import '../../map_config/year_list_item.dart';
import '../map_selector_plus_view.dart';

class YearsSelectorWidget extends StatelessWidget {
  const YearsSelectorWidget({
    Key? key,
    required this.maps,
    this.onMapChanged,
    this.selectedMapId,
  }) : super(key: key);

  final List<MapReference> maps;
  final void Function(int)? onMapChanged;
  final String? selectedMapId;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 100),
      child: PointerInterceptor(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
          child: ConstrainedBox(
            constraints: const BoxConstraints.tightFor(
              width: MapSelectorPlusView.contentWidth,
              height: 380,
            ),
            child: Container(
              decoration: const BoxDecoration(
                color: kColorWhite,
                borderRadius: BorderRadius.only(
                  bottomRight: Radius.circular(8),
                ),
                boxShadow: [
                  BoxShadow(
                    offset: Offset(0, 3),
                    blurRadius: 6,
                    color: Color(0x44000000),
                  )
                ],
              ),
              width: MapSelectorPlusView.contentWidth,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Padding(
                    padding: const EdgeInsets.symmetric(
                      horizontal: UIHelper.kHorizontalSpaceSmall,
                    ),
                    child: Container(
                      decoration: const BoxDecoration(
                          color: kColorPrimary,
                          borderRadius: BorderRadius.only(
                            bottomLeft: Radius.circular(6),
                            bottomRight: Radius.circular(6),
                          )),
                      padding: const EdgeInsets.symmetric(
                          vertical: UIHelper.kVerticalSpaceMedium),
                      child: const Text(
                        'Historische Karten',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: kColorWhite,
                        ),
                      ),
                    ),
                  ),
                  Expanded(
                    child: ListView.separated(
                      shrinkWrap: true,
                      padding:
                          const EdgeInsets.all(UIHelper.kHorizontalSpaceSmall),
                      itemCount: maps.length,
                      scrollDirection: Axis.vertical,
                      itemBuilder: ((context, index) => YearListItem(
                            index: index,
                            onMapChanged: onMapChanged,
                            selected: selectedMapId == maps[index].id,
                            map: maps[index],
                          )),
                      separatorBuilder: (context, _) =>
                          UIHelper.verticalSpace(2),
                    ),
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
