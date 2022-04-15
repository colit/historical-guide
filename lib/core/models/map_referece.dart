import 'package:latlong2/latlong.dart';

class MapReference {
  static const keyObjectId = 'objectId';
  static const keyName = 'name';
  static const keyYear = 'year';
  static const keyKey = 'key';
  static const keyReference100 = 'mapbox100';
  static const keyReference50 = 'mapbox50';

  MapReference({
    required this.id,
    required this.name,
    required this.year,
    required this.key,
    required this.reference100,
    required this.reference50,
    this.boundsSW,
    this.boundsNE,
  });

  final String id;
  final String name;
  final int year;
  final String key;
  final String reference100;
  final String reference50;
  final LatLng? boundsSW;
  final LatLng? boundsNE;

  // String get reference => 'histo_3857:$key';
  String get reference => key;

  factory MapReference.fromGraphQL(node) {
    final sw = node['bounds'][0]['value'];
    final ne = node['bounds'][1]['value'];
    return MapReference(
      id: node[keyObjectId],
      name: node[keyName],
      year: node[keyYear],
      key: node[keyKey],
      reference100: node[keyReference100],
      reference50: node[keyReference50],
      boundsSW: LatLng(sw['latitude'], sw['longitude']),
      boundsNE: LatLng(ne['latitude'], ne['longitude']),
    );
  }
}
