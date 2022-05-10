import 'package:flutter/material.dart';
import 'package:historical_guide/core/services/map_service.dart';
import 'package:historical_guides_commons/historical_guides_commons.dart';
import 'package:provider/provider.dart';

import 'package:mapbox_gl/mapbox_gl.dart';

import 'description/description_view.dart';
import 'stations/stations_view.dart';

class TourInfoView extends StatefulWidget {
  const TourInfoView({
    Key? key,
    required this.tour,
    this.currentStationId,
  }) : super(key: key);

  final Tour tour;
  final int? currentStationId;

  @override
  State<TourInfoView> createState() => _TourInfoViewState();
}

class _TourInfoViewState extends State<TourInfoView>
    with TickerProviderStateMixin {
  late TabController tabController;
  // late ScrollController scrollController;

  final tabs = const [
    Tab(text: 'Tourbeschreibung'),
    Tab(text: 'Stationen'),
  ];

  void _onTabChange() {
    if (!tabController.indexIsChanging) {
      switch (tabController.index) {
        case 0:
          print('description');
          break;
        case 1:
          final mapService = context.read<MapService>();
          var index = mapService.currentStationIndex;
          if (index == null) {
            mapService.currentStationIndex = 0;
            index = 0;
          }
          final poi = widget.tour.pointsOfInterest[index].position;
          mapService.setZoomOn(LatLng(poi.latitude, poi.longitude));
          break;
      }
    }
  }

  @override
  void initState() {
    // scrollController = ScrollController();
    tabController = TabController(length: tabs.length, vsync: this)
      ..addListener(_onTabChange);
    super.initState();
  }

  @override
  void didUpdateWidget(covariant TourInfoView oldWidget) {
    if (widget.currentStationId != null) {
      tabController.animateTo(1);
    }
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    tabController.removeListener(_onTabChange);
    tabController.dispose();
    // scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print('build tour info wit ${widget.currentStationId}');
    return Scaffold(
      backgroundColor: kColorSecondaryLight,
      body: Column(
        children: [
          TabBar(
            controller: tabController,
            isScrollable: false,
            tabs: tabs,
          ),
          Expanded(
            child: TabBarView(
              controller: tabController,
              children: [
                DescriptionView(
                  tour: widget.tour,
                  onTourStart: () {
                    context.read<MapService>().currentStationIndex = 0;
                    tabController.animateTo(1);
                  },
                ),
                StationsView(
                  stations: widget.tour.pointsOfInterest,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
