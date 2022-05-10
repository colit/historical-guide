import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:historical_guide/core/services/map_service.dart';

import 'package:historical_guides_commons/historical_guides_commons.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
// import 'package:pointer_interceptor/pointer_interceptor.dart';
import 'package:provider/provider.dart';

import '../../../core/services/tour_service.dart';
import 'maps_model.dart';
import 'widgets/tour_preview_widget.dart';

class MapsView extends StatefulWidget {
  const MapsView({Key? key}) : super(key: key);

  @override
  State<MapsView> createState() => _MapsViewState();
}

class _MapsViewState extends State<MapsView> {
  @override
  Widget build(BuildContext context) {
    print('build MapsView');
    return LayoutBuilder(builder: (context, constrains) {
      final width = constrains.maxWidth;
      return BaseWidget<MapsModel>(
        model: MapsModel(
          mapService: context.read<MapService>(),
          tourService: context.read<TourService>(),
        ),
        builder: (context, model, child) {
          print('build map view');
          return Stack(
            alignment: AlignmentDirectional.center,
            children: [
              MapboxMap(
                accessToken: dotenv.env['ACCESS_TOKEN']!,
                onMapCreated: model.onMapCreated,
                onStyleLoadedCallback: model.onStyleLoadedCallback,
                onCameraIdle: model.getPhotosInViewport,
                onMapClick: (_, __) {
                  model.cleanMap();
                },
                initialCameraPosition: CameraPosition(
                  target: model.currentPosition,
                  zoom: model.currentZoom,
                ),
                styleString: model.currentStyle,
              ),
              Positioned(
                top: 0,
                child: TourPreviewWidget(
                  selectedTour: model.selectedTour,
                ),
              ),
              Positioned(
                top: 0,
                child: BottomShadowWidget(
                  width: width,
                ),
              ),
              // Positioned(
              //     bottom: 0,
              //     child: ConfigView(
              //       width: width,
              //       visible: model.isSetupVisible,
              //       onSetup: () {
              //         model.isSetupVisible = true;
              //       },
              //     )),
              // Positioned.fill(
              //   child: ImageLayerView(
              //     image: model.selectedPoint,
              //     onDismiss: model.removeSelectedImage,
              //   ),
              // ),
            ],
          );
        },
      );
    });
  }
}

class BottomShadowWidget extends StatelessWidget {
  const BottomShadowWidget({
    Key? key,
    required this.width,
  }) : super(key: key);

  final double width;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 15,
      width: width,
      child: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [
              Colors.black12,
              Colors.black.withAlpha(0),
            ],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
      ),
    );
  }
}
