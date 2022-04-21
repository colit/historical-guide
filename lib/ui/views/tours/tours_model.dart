import 'package:historical_guide/core/app_state.dart';
import 'package:historical_guide/core/exeptions/general_exeption.dart';
import 'package:historical_guide/core/services/tour_service.dart';
import 'package:historical_guide/ui/base/base_model.dart';

import '../../../core/models/tour.dart';

class ToursModel extends BaseModel {
  ToursModel({
    required AppState appState,
    required TourService tourService,
  })  : _appState = appState,
        _tourService = tourService;

  final AppState _appState;
  final TourService _tourService;

  List<Tour> _tours = [];
  List<Tour> get tours => _tours;
  int get toursTotal => _tours.length;

  void initModel() {
    setState(ViewState.busy);
    _tourService.getToursList().then((value) {
      _tours = value;
      setState(ViewState.idle);
    }).onError((error, stackTrace) {
      print((error as GeneralExeption).message);
    });
  }

  void showTour(String id) {
    _appState.selectedPageId = id;
    _appState.pushPage(
      name: 'tour_details',
      arguments: TourDetailArguments(id),
    );
  }
}
