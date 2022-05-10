import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:historical_guides_commons/historical_guides_commons.dart';
import 'package:provider/provider.dart';

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
    return Stack(
      children: [
        SingleChildScrollView(
          padding: const EdgeInsets.all(UIHelper.kHorizontalSpaceMedium),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                tour.name,
                style: Theme.of(context).textTheme.headline1,
              ),
              UIHelper.verticalSpaceSmall(),
              Text('${tour.length.toStringAsFixed(1)} km'),
              UIHelper.verticalSpaceSmall(),
              Text('${tour.stations.length} Stationen'),
              if (tour.description != null) ...[
                UIHelper.verticalSpaceSmall(),
                MarkdownBody(
                  data: tour.description!,
                  styleSheet: context.read<GlobalTheme>().markDownStyleSheet,
                ),
              ],
              UIHelper.verticalSpaceLarge(),
            ],
          ),
        ),
        Positioned(
          bottom: UIHelper.kHorizontalSpaceMedium,
          right: UIHelper.kHorizontalSpaceMedium,
          child: ElevatedButton(
            onPressed: onTourStart?.call,
            child: const Text('Tour starten'),
          ),
        ),
      ],
    );
  }
}
