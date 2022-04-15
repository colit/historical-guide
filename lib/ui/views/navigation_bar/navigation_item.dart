import 'package:flutter/material.dart';
import 'package:historical_guide/ui/commons/theme.dart';

class NavigationItem extends StatelessWidget {
  const NavigationItem({
    Key? key,
    required this.symanticLabel,
    this.selected = false,
    this.onTap,
    required this.child,
  }) : super(key: key);

  final String symanticLabel;
  final bool selected;
  final Function? onTap;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      waitDuration: const Duration(milliseconds: 500),
      margin: const EdgeInsets.only(left: 20),
      message: symanticLabel,
      child: Material(
        color: selected ? kColorWhite : kColorBackgroundLight,
        child: InkWell(
          mouseCursor: SystemMouseCursors.click,
          hoverColor: Colors.white,
          onTap: () {
            onTap?.call();
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
