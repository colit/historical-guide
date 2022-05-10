import 'package:flutter/material.dart';
import 'package:historical_guide/core/models/image_entity.dart';
import 'package:historical_guide/core/models/map_point.dart';
import 'package:historical_guide/core/services/tour_service.dart';
import 'package:historical_guide/ui/base/base_widget.dart';
import 'package:historical_guide/ui/commons/theme.dart';
import 'package:historical_guide/ui/ui_helpers.dart';
import 'package:historical_guide/ui/views/maps/image_layer/image_layer_model.dart';
import 'package:historical_guide/ui/widgets/network_image_widget.dart';
import 'package:historical_guide/ui/widgets/pointer_interceptor/web.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

class ImageLayerView extends StatelessWidget {
  static Future<void> launchInBrowser(String url) async {
    if (await canLaunch(url)) {
      await launch(
        url,
        forceSafariVC: false,
        forceWebView: false,
        headers: <String, String>{'origin': 'Piligrim App'},
      );
    } else {
      throw 'Could not launch $url';
    }
  }

  const ImageLayerView({
    Key? key,
    required this.onDismiss,
    this.image,
  })  : visible = image != null,
        super(key: key);

  final bool visible;
  final Function() onDismiss;
  final MapPoint? image;

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.center,
      children: [
        PointerInterceptor(
          intercepting: visible, //visible,
          child: Container(),
        ),
        if (visible) ...[
          ModalBarrier(
            color: const Color(0x66000000),
            onDismiss: onDismiss,
          ),
          BaseWidget<ImageLayerModel>(
            model: ImageLayerModel(tourService: context.read<TourService>()),
            onModelReady: (model) => model.getImageInfo(image!.id),
            builder: (context, model, _) {
              final imageURL = model.imageDetails?.imageURL;
              return (imageURL == null)
                  ? Container()
                  : Padding(
                      padding: const EdgeInsets.all(15.0),
                      child: ImageDetailsView(
                        image: model.imageDetails!,
                        onDismiss: onDismiss,
                      ),
                    );
            },
          ),
        ]
      ],
    );
  }
}

class ImageDetailsView extends StatelessWidget {
  const ImageDetailsView({
    Key? key,
    required this.image,
    this.onDismiss,
  }) : super(key: key);

  final ImageEntity image;
  final Function()? onDismiss;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints.tightFor(
        width: 1240,
        height: 920,
      ),
      child: LayoutBuilder(builder: (context, constrains) {
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
                    if (!horizontal)
                      Positioned(
                        top: 0,
                        right: 0,
                        child: InkWell(
                          onTap: onDismiss?.call,
                          child: const Padding(
                            padding: EdgeInsets.only(
                                bottom: UIHelper.kVerticalSpaceSmall),
                            child: Icon(
                              Icons.close,
                              color: Colors.white,
                              size: 24,
                            ),
                          ),
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
                        if (image.source != null && image.sourceURL != null)
                          ElevatedButton(
                            onPressed: () {
                              if (image.sourceURL != null) {
                                try {
                                  ImageLayerView.launchInBrowser(
                                      image.sourceURL!);
                                } catch (e) {
                                  print(e);
                                }
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
                  if (horizontal)
                    Positioned(
                      top: 0,
                      right: 0,
                      child: InkWell(
                        onTap: onDismiss?.call,
                        child: const Padding(
                          padding: EdgeInsets.only(
                              bottom: UIHelper.kVerticalSpaceSmall),
                          child: Icon(
                            Icons.close,
                            color: Colors.black,
                            size: 24,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            )
          ],
        );
      }),
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
