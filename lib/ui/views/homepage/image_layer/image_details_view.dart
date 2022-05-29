import 'package:flutter/material.dart';
import 'package:historical_guide/core/services/tour_service.dart';
import 'package:historical_guides_commons/historical_guides_commons.dart';
import 'package:provider/provider.dart';

class ImageDetailsView extends StatefulWidget {
  const ImageDetailsView({
    Key? key,
    required this.imageId,
  }) : super(key: key);

  final int imageId;

  @override
  State<ImageDetailsView> createState() => _ImageDetailsViewState();
}

class _ImageDetailsViewState extends State<ImageDetailsView> {
  late final ImageEntity image;
  bool dataLoaded = false;

  late final tourService = context.read<TourService>();
  @override
  void didChangeDependencies() {
    tourService.getImageInfo(widget.imageId).then((value) {
      setState(() {
        dataLoaded = true;
        image = value;
      });
    });
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints.tightFor(
        width: 1240,
        height: 920,
      ),
      child: dataLoaded
          ? LayoutBuilder(builder: (context, constrains) {
              final horizontal = constrains.maxWidth > 780;
              return Flex(
                direction: horizontal ? Axis.horizontal : Axis.vertical,
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ConditionalFlexibleWidget(
                    condition: horizontal,
                    flex: 3,
                    child: Container(
                      color: kColorSecondaryLight,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                          AspectRatio(
                            aspectRatio: 1,
                            child: NetworkImageWidget(
                              url: image.imageURL!,
                              fit: BoxFit.contain,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  ConditionalFlexibleWidget(
                    condition: horizontal,
                    flex: 1,
                    child: Stack(
                      children: [
                        Container(
                          color: Colors.white,
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              Text(
                                '${image.author}, '
                                '${image.yearPublished}',
                              ),
                              UIHelper.verticalSpaceSmall(),
                              Text(
                                image.title ?? '',
                                style: Theme.of(context)
                                    .textTheme
                                    .headline1
                                    ?.copyWith(fontSize: 24),
                              ),
                              UIHelper.verticalSpaceSmall(),
                              Text(
                                image.description ?? '',
                              ),
                              UIHelper.verticalSpaceSmall(),
                              Text(
                                image.license ?? '',
                              ),
                              UIHelper.verticalSpaceSmall(),
                              if (image.source != null &&
                                  image.sourceURL != null)
                                ElevatedButton(
                                  onPressed: () {
                                    if (image.sourceURL != null) {
                                      // try {
                                      //   ImageLayerView.launchInBrowser(
                                      //       image.sourceURL!);
                                      // } catch (e) {
                                      //   print(e);
                                      // }
                                    }
                                  },
                                  child: Text(
                                    image.source ?? '',
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              );
            })
          : const Center(
              child: CircularProgressIndicator(),
            ),
    );
  }
}

class ConditionalFlexibleWidget extends StatelessWidget {
  const ConditionalFlexibleWidget({
    Key? key,
    this.flex = 1,
    this.condition = true,
    required this.child,
  }) : super(key: key);

  final int flex;
  final bool condition;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    if (condition) {
      return Flexible(
        flex: flex,
        child: child,
      );
    }
    return Container(
      child: child,
    );
  }
}
