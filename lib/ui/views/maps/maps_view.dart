import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:historical_guide/core/services/map_service.dart';
import 'package:historical_guide/ui/base/base_widget.dart';
import 'package:historical_guide/ui/views/maps/map_selector_plus/map_selector_plus_view.dart';
import 'package:historical_guide/ui/views/maps/map_setup/map_setup_view.dart';
import 'package:mapbox_gl/mapbox_gl.dart';
import 'package:provider/provider.dart';

import '../../../core/services/tour_service.dart';
import 'image_layer/image_layer_view.dart';
import 'maps_model.dart';

class MapsView extends StatefulWidget {
  const MapsView({Key? key}) : super(key: key);

  @override
  State<MapsView> createState() => _MapsViewState();
}

class _MapsViewState extends State<MapsView> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constrains) {
      final width = constrains.maxWidth;
      return BaseWidget<MapsModel>(
        model: MapsModel(
          mapService: context.read<MapService>(),
          tourService: context.read<TourService>(),
        ),
        builder: (context, model, child) {
          return Stack(
            alignment: AlignmentDirectional.center,
            children: [
              MapboxMap(
                accessToken: dotenv.env['ACCESS_TOKEN']!,
                onMapCreated: model.onMapCreated,
                onStyleLoadedCallback: model.onStyleLoadedCallback,
                onCameraIdle: model.onCameraIdle,
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
                child: BottomShadowWidget(width: width),
              ),
              Positioned(
                left: 0,
                child: MapSelectorPlusView(
                  visible: model.maps.isNotEmpty,
                  onOpacityChanged: model.showMapWithOpacityIndex,
                ),
              ),
              Positioned(
                  bottom: 0,
                  child: MapSetupView(
                    width: width,
                    visible: model.isSetupVisible,
                    onSetup: () {
                      model.isSetupVisible = true;
                    },
                  )),
              Positioned.fill(
                child: ImageLayerView(
                  image: model.selectedPoint,
                  onDismiss: model.removeSelectedImage,
                ),
              ),
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
