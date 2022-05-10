import 'package:flutter/material.dart';
import 'package:historical_guide/ui/ui_helpers.dart';

import '../../commons/theme.dart';

class PageViewButton extends StatelessWidget {
  const PageViewButton({
    Key? key,
    required this.icon,
    this.onTap,
    this.visible = true,
  }) : super(key: key);

  final void Function()? onTap;
  final bool visible;
  final Icon icon;

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: visible,
      child: Material(
        child: InkWell(
          onTap: onTap?.call,
          child: Container(
            padding: const EdgeInsets.all(UIHelper.kHorizontalSpaceSmall),
            color: kColorPrimary,
            child: icon,
          ),
        ),
      ),
    );
  }
}
