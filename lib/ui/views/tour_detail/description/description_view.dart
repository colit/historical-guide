import 'package:flutter/material.dart';
import 'package:historical_guides_commons/historical_guides_commons.dart';

class DescriptionView extends StatelessWidget {
  const DescriptionView({
    Key? key,
    required this.tour,
    this.onTourStart,
  }) : super(key: key);

  final Tour tour;
  final void Function()? onTourStart;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(UIHelper.kVerticalSpaceMedium),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(tour.name),
          UIHelper.verticalSpaceSmall(),
          if (tour.description != null) ...[
            Text(tour.description!),
            UIHelper.verticalSpaceSmall(),
          ],
          Text('${tour.length.toStringAsFixed(1)} km'),
          UIHelper.verticalSpaceSmall(),
          Text('${tour.pointsOfInterest.length} Stationen'),
          UIHelper.verticalSpaceSmall(),
          ElevatedButton(
            onPressed: onTourStart?.call,
            child: const Text('Tour starten'),
          ),
        ],
      ),
    );
  }
}
