import 'package:flutter/material.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

import '../../../ui_styles.dart';

class OpacityController extends StatefulWidget {
  static const divisions = 2;
  const OpacityController({
    Key? key,
    required this.onOpacityChanged,
    this.isVisible = true,
    this.visibilityIndex = OpacityController.divisions,
  }) : super(key: key);

  final void Function(int) onOpacityChanged;

  final int visibilityIndex;
  final bool isVisible;

  @override
  State<OpacityController> createState() => _OpacityControllerState();
}

class _OpacityControllerState extends State<OpacityController> {
  late double _visibilityValue;
  late double _tempOpacity;
  late bool _isMapVisible;

  int getIndex(double value) {
    return (value * OpacityController.divisions).floor();
  }

  @override
  void initState() {
    _visibilityValue = widget.visibilityIndex / OpacityController.divisions;
    _tempOpacity = _visibilityValue;
    _isMapVisible = _visibilityValue > 0;
    super.initState();
  }

  @override
  void didUpdateWidget(covariant OpacityController oldWidget) {
    if (oldWidget.visibilityIndex != widget.visibilityIndex) {
      _visibilityValue = widget.visibilityIndex / OpacityController.divisions;
      _tempOpacity = _visibilityValue;
      _isMapVisible = _visibilityValue > 0;
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return PointerInterceptor(
      intercepting: widget.isVisible,
      child: Opacity(
        opacity: widget.isVisible ? 1 : 0,
        child: Container(
          decoration: UIStyles.floatingBoxDecoration,
          height: 60,
          child: Row(
            children: [
              AspectRatio(
                aspectRatio: 1,
                child: Center(
                  child: InkWell(
                    child: Icon(_isMapVisible
                        ? Icons.visibility
                        : Icons.visibility_off),
                    onTap: () {
                      setState(() {
                        _isMapVisible = !_isMapVisible;
                        _visibilityValue = _isMapVisible
                            ? (_tempOpacity > 0 ? _tempOpacity : 1)
                            : 0;
                      });
                      widget.onOpacityChanged(
                        getIndex(_isMapVisible ? _visibilityValue : 0),
                      );
                    },
                  ),
                ),
              ),
              Slider(
                value: _visibilityValue,
                onChanged: (value) {
                  widget.onOpacityChanged(getIndex(value));
                  setState(
                    () {
                      _isMapVisible = value > 0;
                      _visibilityValue = value;
                      _tempOpacity = value;
                    },
                  );
                },
                divisions: OpacityController.divisions,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
