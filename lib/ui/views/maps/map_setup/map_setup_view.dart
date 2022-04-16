import 'package:flutter/material.dart';
import 'package:historical_guide/ui/ui_helpers.dart';

import 'setup_content_widget.dart';
import 'setup_menu_button.dart';

class MapSetupView extends StatefulWidget {
  const MapSetupView({
    Key? key,
    this.width,
    this.visible = false,
    this.onSetup,
  }) : super(key: key);

  final double? width;
  final bool visible;
  final void Function()? onSetup;

  @override
  State<MapSetupView> createState() => _MapSetupViewState();
}

class _MapSetupViewState extends State<MapSetupView>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 300),
    vsync: this,
  );

  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    begin: Offset.zero,
    end: const Offset(0, -0.8),
  ).animate(CurvedAnimation(
    parent: _controller,
    curve: Curves.easeInOut,
  ));

  late bool visible = widget.visible;
  int? currentSelected;
  double? widgetHeight;
  bool sizeDefined = false;

  void _onMenuTap(int index) {
    if (index != currentSelected) {
      setState(() {
        currentSelected = index;
        sizeDefined = false;
        if (!visible) {
          visible = true;
          _controller.forward();
          widget.onSetup?.call();
        }
      });
    }
  }

  void _onSetContentSize(Size size) {
    setState(() {
      widgetHeight = size.height;
      sizeDefined = true;
    });
  }

  void _onClose() {
    setState(() {
      visible = false;
      currentSelected = null;
    });
    _controller.reverse();
  }

  @override
  void didUpdateWidget(covariant MapSetupView oldWidget) {
    print('didUpdateWidget');
    if (!widget.visible) {
      _onClose();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: widgetHeight == null ? 0 : 1,
      child: SlideTransition(
        position: _offsetAnimation,
        child: Transform.translate(
          offset: Offset(0, widgetHeight ?? 0),
          child: Column(
            children: [
              Row(
                children: [
                  SetupMenuButton(
                    index: 0,
                    selected: currentSelected,
                    onTap: _onMenuTap,
                  ),
                  UIHelper.horizontalSpace(4),
                  SetupMenuButton(
                    index: 1,
                    selected: currentSelected,
                    onTap: _onMenuTap,
                  ),
                  UIHelper.horizontalSpace(4),
                  SetupMenuButton(
                    index: 2,
                    selected: currentSelected,
                    onTap: _onMenuTap,
                  ),
                ],
              ),
              SetupContentWidget(
                width: widget.width,
                onSizeChange: _onSetContentSize,
                onClose: _onClose,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
