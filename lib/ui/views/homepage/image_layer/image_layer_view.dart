import 'package:flutter/material.dart';
import 'package:historical_guide/core/models/map_point.dart';
import 'package:historical_guide/core/services/tour_service.dart';
import 'package:historical_guide/ui/widgets/pointer_interceptor/web.dart';
import 'package:historical_guides_commons/historical_guides_commons.dart';
import 'package:provider/provider.dart';
import 'package:url_launcher/url_launcher.dart';

import 'image_details_view.dart';
import 'image_layer_model.dart';

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
                        imageId: model.imageDetails!.id,
                      ),
                    );
            },
          ),
        ]
      ],
    );
  }
}
