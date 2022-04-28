import 'package:historical_guide/core/models/image_entity.dart';
import 'package:historical_guide/core/services/interfaces/i_database_repository.dart';
import 'package:historical_guides_commons/historical_guides_commons.dart';

class TourService {
  TourService({required IDatabaseRepository databaseRepository})
      : _databaseRepository = databaseRepository;

  final IDatabaseRepository _databaseRepository;

  Future<List<Tour>> getToursList() async {
    final tours = _databaseRepository.getTours();
    return tours;
  }

  Future<ImageEntity> getImageInfo(int imageId) async {
    print('getImageInfo');
    final imageInfo = await _databaseRepository.getImageInfo(imageId);
    return imageInfo;
  }

  Future<Tour> getTourData(String id) async {
    final tour = await _databaseRepository.getTour(id);
    return tour;
  }
}
