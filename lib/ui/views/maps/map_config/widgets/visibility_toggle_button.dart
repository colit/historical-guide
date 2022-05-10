import 'package:flutter/material.dart';
import 'package:historical_guides_commons/historical_guides_commons.dart';

class VisibilityToggleButton extends StatefulWidget {
  const VisibilityToggleButton({
    Key? key,
    this.visible = true,
    this.onChange,
  }) : super(key: key);

  final bool visible;
  final void Function(bool)? onChange;

  @override
  State<VisibilityToggleButton> createState() => _VisibilityToggleButtonState();
}

class _VisibilityToggleButtonState extends State<VisibilityToggleButton> {
  late bool visible = widget.visible;

  void _toggleVisibility() {
    setState(() {
      visible = !visible;
      widget.onChange?.call(visible);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      clipBehavior: Clip.antiAlias,
      decoration: const BoxDecoration(
        shape: BoxShape.circle,
      ),
      child: Material(
        color: visible ? kColorWhite : kColorPrimary,
        child: InkWell(
          child: Padding(
            padding: const EdgeInsets.all(UIHelper.kHorizontalSpaceMedium),
            child: Icon(
              visible ? Icons.visibility : Icons.visibility_off,
              color: visible ? kColorPrimary : kColorBackgroundLight,
              size: 24,
            ),
          ),
          onTap: _toggleVisibility,
        ),
      ),
    );
  }
}
