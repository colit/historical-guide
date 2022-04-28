import 'package:historical_guide/core/models/image_entity.dart';
import 'package:historical_guides_commons/historical_guides_commons.dart';

import '../../models/map_entity.dart';
import '../../models/map_referece.dart';

abstract class IDatabaseRepository {
  Future<List<MapEntity>> getMaps();
  Future<List<MapReference>> getMapReferences();

  Future<String?> getMapURLForId(String id);

  Future<List<Tour>> getTours();

  Future<ImageEntity> getImageInfo(int imageId);

  Future<Map<String, dynamic>> getPhotos(Map<String, String> parameters);

  Future<Tour> getTour(String id);
}
