import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:historical_guide/ui/commons/theme.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

class MapOpacityControllerWidget extends StatefulWidget {
  static const indexHidden = 0;
  static const indexTansparent = 1;
  static const indexOpaque = 2;

  const MapOpacityControllerWidget({
    Key? key,
    this.onOpacityChanged,
    this.isVisible = false,
    this.visibilityIndex = 0,
  }) : super(key: key);

  final void Function(int)? onOpacityChanged;
  final bool isVisible;
  final int visibilityIndex;

  @override
  State<MapOpacityControllerWidget> createState() =>
      _MapOpacityControllerWidgetState();
}

class _MapOpacityControllerWidgetState extends State<MapOpacityControllerWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    duration: const Duration(milliseconds: 500),
    vsync: this,
  );
  late final Animation<Offset> _offsetAnimation = Tween<Offset>(
    begin: const Offset(-1.4, 0.0),
    end: Offset.zero,
  ).animate(CurvedAnimation(
    parent: _controller,
    curve: Curves.easeOut,
  ));

  @override
  void didUpdateWidget(covariant MapOpacityControllerWidget oldWidget) {
    if (oldWidget.isVisible != widget.isVisible) {
      if (widget.isVisible) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _offsetAnimation,
      child: PointerInterceptor(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 10, 10, 10),
          child: Container(
            decoration: const BoxDecoration(
              color: kColorBackgroundLight,
              borderRadius: BorderRadius.only(
                topRight: Radius.circular(8),
                bottomRight: Radius.circular(8),
              ),
              boxShadow: [
                BoxShadow(
                  offset: Offset(0, 3),
                  blurRadius: 6,
                  color: Color(0x44000000),
                )
              ],
            ),
            clipBehavior: Clip.antiAlias,
            child: Column(
              children: [
                MapOpacityControllerButton(
                  selected: widget.visibilityIndex ==
                      MapOpacityControllerWidget.indexHidden,
                  onTap: () => widget.onOpacityChanged
                      ?.call(MapOpacityControllerWidget.indexHidden),
                  iconReference: 'images/icon-hidden.svg',
                  symanticLabel: 'Karte verstecken',
                ),
                MapOpacityControllerButton(
                  selected: widget.visibilityIndex ==
                      MapOpacityControllerWidget.indexTansparent,
                  onTap: () => widget.onOpacityChanged
                      ?.call(MapOpacityControllerWidget.indexTansparent),
                  iconReference: 'images/icon-transparent.svg',
                  symanticLabel: 'Halbtransparent',
                ),
                MapOpacityControllerButton(
                  selected: widget.visibilityIndex ==
                      MapOpacityControllerWidget.indexOpaque,
                  onTap: () => widget.onOpacityChanged
                      ?.call(MapOpacityControllerWidget.indexOpaque),
                  iconReference: 'images/icon-opaque.svg',
                  symanticLabel: 'Komplett sichtbar',
                ),
              ],
            ),
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

class MapOpacityControllerButton extends StatelessWidget {
  const MapOpacityControllerButton({
    Key? key,
    this.selected = false,
    this.onTap,
    this.symanticLabel,
    required this.iconReference,
  }) : super(key: key);

  final bool selected;
  final void Function()? onTap;
  final String iconReference;
  final String? symanticLabel;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      waitDuration: const Duration(milliseconds: 500),
      verticalOffset: 10,
      message: symanticLabel,
      child: Material(
        color: selected ? kColorBackgroundLight : kColorWhite,
        child: InkWell(
          onTap: onTap?.call,
          child: SizedBox(
            width: 30,
            height: 30,
            child: Center(
              child: SvgPicture.asset(
                iconReference,
                width: 16,
                color: kColorPrimary,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
