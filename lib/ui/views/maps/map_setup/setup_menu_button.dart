import 'package:flutter/material.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

import '../../../commons/theme.dart';

class SetupMenuButton extends StatelessWidget {
  static const double height = 50;
  const SetupMenuButton({
    Key? key,
    required this.index,
    this.selected,
    this.onTap,
  }) : super(key: key);

  final int index;
  final int? selected;
  final void Function(int)? onTap;

  @override
  Widget build(BuildContext context) {
    final active = index == selected;
    return PointerInterceptor(
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: const BoxDecoration(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(10),
            topRight: Radius.circular(10),
          ),
        ),
        child: Material(
          color: active ? kColorWhite : kColorPrimary,
          child: InkWell(
            onTap: active ? null : () => onTap?.call(index),
            child: const SizedBox(
              height: SetupMenuButton.height,
              width: SetupMenuButton.height,
            ),
          ),
        ),
      ),
    );
  }
}
