import 'package:flutter/material.dart';
import 'package:historical_guides_commons/historical_guides_commons.dart';

class NavigationItem extends StatelessWidget {
  const NavigationItem({
    Key? key,
    required this.symanticLabel,
    this.onTap,
    required this.child,
    required this.index,
    this.currentSelected = 0,
  }) : super(key: key);

  final String symanticLabel;
  final void Function(int)? onTap;
  final Widget child;
  final int index;
  final int? currentSelected;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      waitDuration: const Duration(milliseconds: 500),
      margin: const EdgeInsets.only(left: 20),
      message: symanticLabel,
      child: Material(
        color: index == currentSelected ? kColorWhite : kColorBackgroundLight,
        child: InkWell(
          mouseCursor: SystemMouseCursors.click,
          hoverColor: Colors.white,
          onTap: () {
            onTap?.call(index);
          },
          child: Padding(
            padding: const EdgeInsets.all(10),
            child: Center(child: child),
          ),
        ),
      ),
    );
  }
}
