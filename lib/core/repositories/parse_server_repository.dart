import 'dart:convert';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:graphql/client.dart';
import 'package:http/http.dart' as http;

import 'package:historical_guide/core/commons/graphql_queries.dart';
import 'package:historical_guide/core/models/image_entity.dart';

import 'package:historical_guide/core/models/map_referece.dart';
import 'package:historical_guide/core/models/map_entity.dart';
import 'package:historical_guide/core/models/tour.dart';
import 'package:historical_guide/core/services/interfaces/i_database_repository.dart';

import '../exeptions/general_exeption.dart';

class ParseServerRepository implements IDatabaseRepository {
  GraphQLClient? _client;
  GraphQLClient get client {
    return _client ??= GraphQLClient(
      cache: GraphQLCache(),
      link: HttpLink(GraphQLQueries.graphqlAPI,
          defaultHeaders: GraphQLQueries.graphQLHeader),
    );
  }

  @override
  Future<List<MapReference>> getMapReferences() async {
    var output = <MapReference>[];

    final options = QueryOptions(
      document: gql(GraphQLQueries.getMapReferences),
    );

    final result = await client.query(options);

    if (result.hasException) {
      throw GeneralExeption(
          title: 'graphQL Exception', message: result.exception.toString());
    } else {
      output = List<MapReference>.from(result.data?['mapReferences']['edges']
          .map((node) => MapReference.fromGraphQL(node['node'])));
    }

    return output;
  }

  @override
  Future<String?> getMapURLForId(String id) {
    // TODO: implement getMapURLForId
    throw UnimplementedError();
  }

  @override
  Future<List<MapEntity>> getMaps() {
    // TODO: implement getMaps
    throw UnimplementedError();
  }

  @override
  Future<List<Tour>> getTours() async {
    // List<Tour> output = [];

    final options = QueryOptions(
      document: gql(GraphQLQueries.getTours),
    );

    final result = await client.query(options);

    if (result.hasException) {
      final message =
          result.exception?.graphqlErrors.first.message ?? 'Server Error';
      throw GeneralExeption(title: 'graphQL Exception', message: message);
    } else {
      try {
        final output = List<Tour>.from(result.data?['tracks']['edges']
            .map((node) => Tour.fromGraphQL(node['node'])));
        return output;
      } catch (e) {
        print(e);
        return [];
      }
    }
  }

  @override
  Future<ImageEntity> getImageInfo(int imageId) async {
    final options = QueryOptions(
      document: gql(GraphQLQueries.getImageDetails),
      variables: {'id': imageId},
    );
    final result = await client.query(options);
    if (result.hasException) {
      final message =
          result.exception?.graphqlErrors.first.message ?? 'Server Error';
      throw GeneralExeption(title: 'graphQL Exception', message: message);
    } else {
      try {
        final node = List.from(result.data?['images']['edges']).first['node'];
        return ImageEntity.fromQuery(node);
      } catch (_) {
        throw GeneralExeption(
            title: 'graphQL Exception', message: 'Data error');
      }
    }
  }

  @override
  Future<Map<String, dynamic>> getPhotos(Map<String, String> parameters) async {
    final parseUrl = dotenv.env['PARSE_SERVER'];
    final uri = Uri.parse('${parseUrl}parse/functions/getImagesForBounds');
    final headers = {
      'X-Parse-Application-Id': dotenv.env['APP_ID']!,
      'X-Parse-REST-API-Key': dotenv.env['REST_API_KEY']!,
      'Content-Type': 'application/x-www-form-urlencoded',
    };
    final response = await http.post(
      uri,
      headers: headers,
      body: parameters,
    );
    final body = json.decode(response.body);
    return body['result'];
  }

  @override
  Future<Tour> getTour(String id) async {
    final options = QueryOptions(
      document: gql(GraphQLQueries.getTourDetails),
      variables: {'id': id},
    );
    final result = await client.query(options);
    if (result.hasException) {
      final message =
          result.exception?.graphqlErrors.first.message ?? 'Server Error';
      throw GeneralExeption(title: 'graphQL Exception', message: message);
    } else {
      final node = List.from(result.data?['tracks']['edges']).first['node'];
      print(node);
      return Tour.fromGraphQL(node);
    }
  }
}

// final parseQuery = QueryBuilder<ParseObject>(ParseObject('Track'));

// final ParseResponse apiResponse = await parseQuery.query();

// if (apiResponse.success && apiResponse.results != null) {
//   List<Tour> output = [];
//   for (final obj in apiResponse.results!) {
//     output.add(Tour.fromParseObject(obj));
//   }
//   return output;
// } else {
//   throw Exception();
// }
