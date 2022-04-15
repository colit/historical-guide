import 'package:historical_guide/core/models/image_entity.dart';

import '../../../../core/services/tour_service.dart';
import '../../../base/base_model.dart';

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
