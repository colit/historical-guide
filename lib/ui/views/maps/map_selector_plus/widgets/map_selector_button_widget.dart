import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';
import '../../../../commons/theme.dart';
import '../../../../ui_helpers.dart';

class MapSelectorButtonWidget extends StatelessWidget {
  const MapSelectorButtonWidget({
    Key? key,
    this.active = false,
    // TODO: sey dynamic value
    this.year = 2022,
    this.onTap,
  }) : super(key: key);

  final bool active;
  final Function? onTap;
  final int year;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => onTap?.call(),
      child: PointerInterceptor(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
          child: Container(
            decoration: BoxDecoration(
              color: active ? kColorWhite : kColorPrimary,
              borderRadius: const BorderRadius.only(
                topRight: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
              boxShadow: const [
                BoxShadow(
                  offset: Offset(0, 3),
                  blurRadius: 6,
                  color: Color(0x44000000),
                )
              ],
            ),
            padding: const EdgeInsets.all(UIHelper.kHorizontalSpaceSmall),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Container(
                  width: 34,
                  height: 34,
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: active ? kColorPrimary : kColorWhite,
                    shape: BoxShape.circle,
                  ),
                  child: SvgPicture.asset(
                    'images/icon-map.svg',
                    color: active ? kColorWhite : kColorPrimary,
                  ),
                ),
                UIHelper.verticalSpace(4),
                Text(
                  year.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: active ? kColorPrimary : kColorWhite,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
