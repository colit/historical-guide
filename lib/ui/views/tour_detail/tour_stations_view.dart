import 'package:flutter/material.dart';
import 'package:historical_guide/core/services/map_service.dart';
import 'package:historical_guide/ui/views/tour_detail/tour_stations_model.dart';
import 'package:historical_guides_commons/historical_guides_commons.dart';
import 'package:provider/provider.dart';

class TourStationsView extends StatelessWidget {
  const TourStationsView({
    Key? key,
    required this.tour,
  }) : super(key: key);

  final Tour tour;

  @override
  Widget build(BuildContext context) {
    final pointsOfInterest = tour.pointsOfInterest;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Container(
          padding: const EdgeInsets.all(UIHelper.kHorizontalSpaceMedium),
          child: Text(tour.name),
        ),
        Expanded(
          child: BaseWidget<TourStationsModel>(
            model: TourStationsModel(
              mapService: context.read<MapService>(),
            ),
            builder: (context, model, child) {
              return PageView.builder(
                controller: model.pageController,
                onPageChanged: (index) =>
                    model.pageChanged(pointsOfInterest[index]),
                itemCount: tour.pointsOfInterest.length,
                itemBuilder: (context, index) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Container(
                      decoration: const BoxDecoration(
                        color: kColorWhite,
                        borderRadius: BorderRadius.all(
                          Radius.circular(UIHelper.kHorizontalSpaceSmall),
                        ),
                      ),
                      child: Center(
                        child: Text(tour.pointsOfInterest[index].titel),
                      ),
                    ),
                  );
                },
              );
            },
          ),
        ),
        UIHelper.verticalSpaceMedium(),
      ],
    );
  }
}
