import 'package:flutter/material.dart';
import 'package:historical_guide/ui/ui_helpers.dart';
import 'package:pointer_interceptor/pointer_interceptor.dart';

import '../../../../commons/theme.dart';
import '../../../../widgets/size_detector_widget.dart';
import '../config_view.dart';

class ConfigContentWidget extends StatelessWidget {
  const ConfigContentWidget({
    Key? key,
    required this.content,
    this.width,
    this.onSizeChange,
    this.onClose,
    int? selected,
  }) : super(key: key);

  final double? width;
  final void Function(Size)? onSizeChange;
  final void Function()? onClose;
  final ConfigItem? content;

  @override
  Widget build(BuildContext context) {
    return SizeDetectorWidget(
      onChange: onSizeChange,
      child: PointerInterceptor(
        child: Container(
          height: 160,
          width: width,
          color: kColorBackgroundLight,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              if (content != null) ...[
                Stack(
                  alignment: Alignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.symmetric(
                        vertical: UIHelper.kHorizontalSpaceSmall,
                      ),
                      child: Text(
                        content!.label,
                        textAlign: TextAlign.center,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    Positioned(
                      right: 0,
                      child: RoundIconButton(
                        onTap: onClose,
                      ),
                    ),
                  ],
                ),
                Expanded(child: content!.child),
              ],
              UIHelper.verticalSpaceSmall(),
            ],
          ),
        ),
      ),
    );
  }
}

class RoundIconButton extends StatelessWidget {
  const RoundIconButton({
    Key? key,
    required this.onTap,
  }) : super(key: key);

  final void Function()? onTap;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(4),
      child: Container(
        clipBehavior: Clip.antiAlias,
        decoration: const BoxDecoration(
          shape: BoxShape.circle,
        ),
        child: Material(
          child: InkWell(
            onTap: onTap?.call,
            child: const Padding(
              padding: EdgeInsets.all(4),
              child: Icon(
                Icons.close,
                size: 16,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
