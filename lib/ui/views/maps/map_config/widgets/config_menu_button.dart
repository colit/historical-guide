import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:historical_guide/ui/widgets/pointer_interceptor/web.dart';
import 'package:historical_guides_commons/historical_guides_commons.dart';

class SetupMenuButton extends StatelessWidget {
  static const double height = 44;
  const SetupMenuButton({
    Key? key,
    required this.index,
    required this.iconAsset,
    this.selected,
    this.onTap,
    this.symanticsLabel,
  }) : super(key: key);

  final int index;
  final int? selected;
  final void Function(int)? onTap;
  final String iconAsset;
  final String? symanticsLabel;

  @override
  Widget build(BuildContext context) {
    final active = index == selected;
    return Tooltip(
      message: symanticsLabel ?? '',
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        child: Material(
          color: active ? kColorBackgroundLight : kColorPrimary,
          child: PointerInterceptor(
            child: InkWell(
              onTap: active ? null : () => onTap?.call(index),
              child: SizedBox(
                height: SetupMenuButton.height,
                width: SetupMenuButton.height,
                child: Padding(
                  padding: const EdgeInsets.all(6),
                  child: Container(
                    padding: const EdgeInsets.all(8),
                    decoration: const BoxDecoration(
                      color: kColorPrimary,
                      shape: BoxShape.circle,
                    ),
                    child: SvgPicture.asset(
                      iconAsset,
                      color: kColorBackgroundLight,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
