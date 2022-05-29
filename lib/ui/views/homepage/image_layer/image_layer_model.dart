import 'package:historical_guides_commons/historical_guides_commons.dart';

import '../../../../core/services/tour_service.dart';

class ImageLayerModel extends BaseModel {
  ImageLayerModel({required TourService tourService})
      : _tourService = tourService;
  final TourService _tourService;

  ImageEntity? imageDetails;

  void getImageInfo(int? imageId) {
    if (imageId == null) return;
    setState(ViewState.busy);
    _tourService.getImageInfo(imageId).then((value) {
      imageDetails = value;
      setState(ViewState.idle);
    });
  }
}
