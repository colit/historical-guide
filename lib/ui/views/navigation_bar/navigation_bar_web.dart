import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:historical_guides_commons/historical_guides_commons.dart';

import 'navigation_item.dart';

class NavigationBarWeb extends StatelessWidget {
  const NavigationBarWeb({
    Key? key,
    this.onTap,
    this.selectedIndex,
  }) : super(key: key);

  final Function(int)? onTap;
  final int? selectedIndex;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          NavigationItem(
            symanticLabel: 'Piligrimm App',
            child: SvgPicture.asset(
              'images/piligrim-logo.svg',
              height: 20,
              semanticsLabel: 'piligrim logo',
              color: kColorPrimaryLight,
            ),
            onTap: () => onTap?.call(0),
            selected: selectedIndex == 0,
          ),
          NavigationItem(
            child: const Text('Touren'),
            symanticLabel: 'Touren',
            onTap: () => onTap?.call(1),
            selected: selectedIndex == 1,
          ),
          NavigationItem(
            child: const Text('Das Projekt'),
            symanticLabel: 'Das Projekt',
            onTap: () => onTap?.call(2),
            selected: selectedIndex == 2,
          ),
        ],
      ),
    );
  }
}
