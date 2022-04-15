import 'package:flutter/material.dart';
import 'package:historical_guide/core/app_state.dart';
import 'package:historical_guide/core/services/tour_service.dart';
import 'package:historical_guide/ui/base/base_model.dart';
import 'package:historical_guide/ui/base/base_widget.dart';
import 'package:provider/provider.dart';

import 'widgets/tour_thumbnail.dart';
import 'tours_model.dart';

class ToursView extends StatelessWidget {
  const ToursView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BaseWidget<ToursModel>(
        model: ToursModel(
          appState: context.read<AppState>(),
          tourService: context.read<TourService>(),
        ),
        onModelReady: (model) => model.initModel(),
        builder: (context, model, child) {
          return Scaffold(
            backgroundColor: const Color.fromARGB(255, 93, 129, 94),
            body: model.state == ViewState.busy
                ? const Center(child: CircularProgressIndicator())
                : GridView.builder(
                    padding: const EdgeInsets.all(15),
                    itemCount: model.toursTotal,
                    gridDelegate:
                        const SliverGridDelegateWithMaxCrossAxisExtent(
                            maxCrossAxisExtent: 200,
                            childAspectRatio: 3 / 2,
                            crossAxisSpacing: 20,
                            mainAxisSpacing: 20),
                    itemBuilder: (context, index) {
                      return TourThumbnail(
                        id: index,
                        label: model.tours[index].name,
                        length: model.tours[index].length,
                        onTap: (id) => model.showTour(id),
                      );
                    }),
          );
        });
  }
}
