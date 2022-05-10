import 'package:flutter/material.dart';
import 'package:historical_guides_commons/historical_guides_commons.dart';
import 'package:provider/provider.dart';

import '../../../../core/services/map_service.dart';
import '../page_button.dart';
import 'stations_model.dart';

class StationsView extends StatefulWidget {
  const StationsView({
    Key? key,
    required this.stations,
  }) : super(key: key);

  final List<Station> stations;

  @override
  State<StationsView> createState() => _StationsViewState();
}

class _StationsViewState extends State<StationsView>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Padding(
      padding:
          const EdgeInsets.symmetric(vertical: UIHelper.kVerticalSpaceMedium),
      child: BaseWidget<StationsModel>(
        model: StationsModel(
          mapService: context.read<MapService>(),
        ),
        onModelReady: (model) => model.initModel(widget.stations),
        builder: (context, model, child) {
          return Stack(
            alignment: Alignment.center,
            children: [
              PageView.builder(
                controller: model.pageController,
                itemCount: model.pointsCount,
                physics: const NeverScrollableScrollPhysics(),
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
                        child: Text(widget.stations[index].titel),
                      ),
                    ),
                  );
                },
              ),
              if (model.currentPageIndex != null)
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    PageViewButton(
                      icon: const Icon(
                        Icons.arrow_back_ios_new,
                        color: kColorWhite,
                      ),
                      visible: model.currentPageIndex! > 0,
                      onTap: model.showPreviousStation,
                    ),
                    PageViewButton(
                      icon: const Icon(
                        Icons.arrow_forward_ios,
                        color: kColorWhite,
                      ),
                      visible: model.currentPageIndex! < model.pointsCount - 1,
                      onTap: model.showNextStation,
                    ),
                  ],
                ),
            ],
          );
        },
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
