import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:historical_guide/core/app_state.dart';
import 'package:historical_guide/core/services/map_service.dart';
import 'package:historical_guide/core/services/tour_service.dart';
import 'package:historical_guide/ui/widgets/pointer_interceptor/web.dart';
import 'package:historical_guides_commons/historical_guides_commons.dart';
import 'package:provider/provider.dart';

import 'package:mapbox_gl/mapbox_gl.dart';

import 'tour_detail_model.dart';
import 'tour_info_view.dart';

class TourDetailView extends StatelessWidget {
  const TourDetailView({Key? key, required this.id}) : super(key: key);
  final String id;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey,
      body: BaseWidget<TourDetailModel>(
          model: TourDetailModel(
            mapService: context.read<MapService>(),
            tourService: context.read<TourService>(),
          ),
          onModelReady: (model) {
            model.initModel(id);
            // model.onStyleLoadedCallback();
          },
          builder: (context, model, child) {
            return model.state == ViewState.busy
                ? Container()
                : Row(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Flexible(
                        flex: 5,
                        child: Stack(
                          children: [
                            Container(
                              color: kColorSecondaryLight,
                              child: MapboxMap(
                                accessToken: dotenv.env['ACCESS_TOKEN']!,
                                onMapCreated: (controller) =>
                                    model.onMapCreated(controller, id),
                                onStyleLoadedCallback:
                                    model.onStyleLoadedCallback,
                                initialCameraPosition: CameraPosition(
                                  target: model.currentPosition,
                                  zoom: model.currentZoom,
                                ),
                                styleString: model.currentStyle,
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.all(
                                  UIHelper.kHorizontalSpaceSmall),
                              child: PointerInterceptor(
                                child: RoundIconButton(
                                  icon: const Icon(
                                    Icons.arrow_back,
                                    size: 24,
                                  ),
                                  onTap: () {
                                    final appState = context.read<AppState>();
                                    appState.selectedPageId = null;
                                    appState.popPage();
                                  },
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      Flexible(
                        flex: 3,
                        child: Container(
                          color: kColorSecondaryLight,
                          child: TourInfoView(
                            tour: model.tour,
                            currentStationId: model.currentStationId,
                          ),
                        ),
                      ),
                    ],
                  );
          }),
    );
  }
}
