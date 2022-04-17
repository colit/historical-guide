import 'package:flutter/material.dart';
import 'package:historical_guide/ui/ui_helpers.dart';
import 'package:historical_guide/ui/views/maps/map_config/map_selector/map_selector_view.dart';
import 'package:historical_guide/ui/views/maps/map_config/photo_selector/photo_selector_view.dart';
import 'package:historical_guide/ui/views/maps/map_config/tour_selector/tour_selector_view.dart';

import 'widgets/config_content_widget.dart';
import 'widgets/config_menu_button.dart';

class MapSetupView extends StatefulWidget {
  static final content = [
    ConfigItem(
      label: 'Historische Karten',
      child: const MapSelectorWidget(),
    ),
    ConfigItem(
      label: 'Bilder',
      child: const PhotoSelectorView(),
    ),
    ConfigItem(
      label: 'Touren',
      child: const TourSelectorView(),
    ),
  ];

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

  late Animation<Offset> _offsetAnimation = Tween<Offset>(
    begin: Offset.zero,
    end: const Offset(0, 0),
  ).animate(CurvedAnimation(
    parent: _controller,
    curve: Curves.easeInOut,
  ));

  late bool visible = widget.visible;
  int? currentSelected;
  double? contentHeight;
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
      contentHeight = size.height;
      sizeDefined = true;
      if (contentHeight != null) {
        _offsetAnimation = Tween<Offset>(
          begin: Offset.zero,
          end: Offset(
              0, -contentHeight! / (contentHeight! + SetupMenuButton.height)),
        ).animate(CurvedAnimation(
          parent: _controller,
          curve: Curves.easeInOut,
        ));
      }
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
    if (!widget.visible) {
      _onClose();
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: contentHeight == null ? 0 : 1,
      child: SlideTransition(
        position: _offsetAnimation,
        child: Transform.translate(
          offset: Offset(0, contentHeight ?? 0),
          child: Column(
            children: [
              SizedBox(
                width: widget.width,
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    Positioned.fill(
                      child: Container(
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            colors: [
                              Colors.black12,
                              Colors.black.withAlpha(0),
                            ],
                            begin: Alignment.bottomCenter,
                            end: Alignment.center,
                          ),
                        ),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SetupMenuButton(
                          index: 0,
                          iconAsset: 'images/icon-map.svg',
                          selected: currentSelected,
                          onTap: _onMenuTap,
                          symanticsLabel: MapSetupView.content[0].label,
                        ),
                        UIHelper.horizontalSpace(4),
                        SetupMenuButton(
                          index: 1,
                          iconAsset: 'images/icon-photo.svg',
                          selected: currentSelected,
                          onTap: _onMenuTap,
                          symanticsLabel: MapSetupView.content[1].label,
                        ),
                        UIHelper.horizontalSpace(4),
                        SetupMenuButton(
                          index: 2,
                          iconAsset: 'images/icon-tour.svg',
                          selected: currentSelected,
                          onTap: _onMenuTap,
                          symanticsLabel: MapSetupView.content[2].label,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              ConfigContentWidget(
                width: widget.width,
                onSizeChange: _onSetContentSize,
                onClose: _onClose,
                selected: currentSelected,
                content: currentSelected == null
                    ? null
                    : MapSetupView.content[currentSelected!],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}

class ConfigItem {
  final String label;
  final Widget child;

  ConfigItem({
    required this.label,
    required this.child,
  });
}
