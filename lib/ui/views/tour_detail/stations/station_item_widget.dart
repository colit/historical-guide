import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:historical_guides_commons/historical_guides_commons.dart';
import 'package:provider/provider.dart';

import '../../homepage/image_layer/image_details_view.dart';

class StationItemWidget extends StatelessWidget {
  const StationItemWidget({
    Key? key,
    required this.station,
  }) : super(key: key);

  final Station station;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: UIHelper.kVerticalSpaceMedium,
        ),
        decoration: const BoxDecoration(
          color: kColorWhite,
          borderRadius: BorderRadius.all(
            Radius.circular(UIHelper.kHorizontalSpaceSmall),
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: UIHelper.kHorizontalSpaceLarge,
              ),
              child: Text(
                station.titel,
                style: Theme.of(context).textTheme.headline1,
              ),
            ),
            UIHelper.verticalSpaceMedium(),
            Expanded(
              child: SingleChildScrollView(
                controller: ScrollController(),
                padding: const EdgeInsets.symmetric(
                  horizontal: UIHelper.kHorizontalSpaceLarge,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    Wrap(
                      spacing: UIHelper.kHorizontalSpaceSmall,
                      runSpacing: UIHelper.kHorizontalSpaceSmall,
                      children: [
                        for (final image in station.images)
                          if (image.imageURL != null)
                            Tooltip(
                              waitDuration: const Duration(milliseconds: 500),
                              margin: const EdgeInsets.only(left: 20),
                              message: 'photo tooltip', //image.title ?? '',
                              child: Material(
                                child: InkWell(
                                  onTap: () => context
                                      .read<ModalViewService>()
                                      .show(ImageDetailsView(
                                        imageId: image.id,
                                      )),
                                  child: SizedBox(
                                    height: 100,
                                    child: NetworkImageWidget(
                                      url: image.imageURL!,
                                      loaderWidget: Center(
                                          child: Container(
                                        width: 70,
                                        color: kColorBackgroundLight,
                                        child:
                                            const CircularProgressIndicator(),
                                      )),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                      ],
                    ),
                    UIHelper.verticalSpaceSmall(),
                    MarkdownBody(
                      data: station.description ?? '',
                      styleSheet:
                          context.read<GlobalTheme>().markDownStyleSheet,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
