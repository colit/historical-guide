import 'package:historical_guide/core/services/tour_service.dart';
import 'package:historical_guides_commons/historical_guides_commons.dart';

class ImageDetailsModel extends BaseModel {
  ImageDetailsModel({required TourService tourService})
      : _tourService = tourService;
  final TourService _tourService;

  ImageEntity? imageDetails;
  void initModel(int imageId) {
    setState(ViewState.busy);
    _tourService.getImageInfo(imageId).then((value) {
      imageDetails = value;
      setState(ViewState.idle);
    });
  }
}
