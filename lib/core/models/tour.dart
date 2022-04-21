import 'package:latlong2/latlong.dart';
// import 'package:parse_server_sdk/parse_server_sdk.dart';

class Tour {
  Tour._(
    this.id,
    this.name,
    this.geoJSON,
    this.startPoint,
    this.length,
    this.boundsSW,
    this.boundsNE,
    this.vectorAssets,
  );
  final String id;
  final String name;
  final String? geoJSON;
  final LatLng startPoint;
  final double length;
  final LatLng boundsSW;
  final LatLng boundsNE;
  final String? vectorAssets;

  // factory Tour.fromParseObject(ParseObject obj) {
  //   final startPointObj = obj.get('start') as ParseGeoPoint;
  //   final trackObj = obj.get('geojson') as ParseWebFile;
  //   final bounds = obj.get('bounds') as List<dynamic>;

  //   return Tour._(
  //     obj.get('objectId'),
  //     obj.get('name'),
  //     trackObj.url,
  //     LatLng(startPointObj.latitude, startPointObj.longitude),
  //     obj.get('length'),
  //     LatLng(bounds[0].latitude, bounds[0].longitude),
  //     LatLng(bounds[1].latitude, bounds[1].longitude),
  //   );
  // }

  factory Tour.fromMap(Map<dynamic, dynamic> map) {
    return Tour._(
      map['objectId'],
      map['name'],
      map['geoJSON'],
      map['start'],
      map['length'],
      map['bounds']['southwest'],
      map['bounds']['northeast'],
      map['vectorAssets'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'objectId': id,
      'name': name,
      'geoJSON': geoJSON,
      'length': length,
      'start': startPoint,
      'bounds': {
        'southwest': boundsSW,
        'northeast': boundsNE,
      }
    };
  }

  factory Tour.fromGraphQL(dynamic node) {
    return Tour._(
      node['objectId'],
      node['name'],
      node['geojson']['url'],
      LatLng(
        node['start']['latitude'],
        node['start']['longitude'],
      ),
      node['length'],
      LatLng(node['latitudeSW'], node['longitudeSW']),
      LatLng(node['latitudeNE'], node['longitudeNE']),
      node['vectorAssets']['url'],
    );
  }
}