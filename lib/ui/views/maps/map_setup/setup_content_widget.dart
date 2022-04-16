import 'package:flutter/material.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

import '../../../commons/theme.dart';
import '../../../widgets/size_detector_widget.dart';

class SetupContentWidget extends StatelessWidget {
  const SetupContentWidget({
    Key? key,
    this.width,
    this.onSizeChange,
    this.onClose,
  }) : super(key: key);

  final double? width;
  final void Function(Size)? onSizeChange;
  final void Function()? onClose;

  @override
  Widget build(BuildContext context) {
    return SizeDetectorWidget(
      onChange: onSizeChange,
      child: PointerInterceptor(
        child: Stack(
          children: [
            Container(
              color: kColorWhite,
              height: 200,
              width: width,
            ),
            Positioned(
              top: 0,
              right: 0,
              child: TextButton.icon(
                onPressed: onClose?.call,
                icon: const Icon(
                  Icons.close,
                  size: 16,
                ),
                label: const Text('schließen'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
