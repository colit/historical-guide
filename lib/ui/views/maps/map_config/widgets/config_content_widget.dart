import 'package:flutter/material.dart';
import 'package:historical_guide/ui/ui_helpers.dart';
import 'package:historical_guide/ui/widgets/pointer_interceptor/web.dart';

import '../../../../commons/theme.dart';
import '../../../../widgets/size_detector_widget.dart';
import '../../../../widgets/round_icon_button.dart';
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
                        icon: const Icon(
                          Icons.close,
                          size: 16,
                        ),
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
