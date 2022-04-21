import 'package:flutter_dotenv/flutter_dotenv.dart';

class GraphQLQueries {
  GraphQLQueries._();

  static Map<String, String> get graphQLHeader => {
        'X-Parse-Application-Id': dotenv.env['APP_ID']!,
        'X-Parse-Master-Key': dotenv.env['MASTER_KEY']!,
        'X-Parse-Client-Key': dotenv.env['CLIENT_KEY']!,
      };

  static String get graphqlAPI => dotenv.env['GRAPHQL_API']!;

  static const getMaps = r'''
    query getMaps{
      maps {
        edges{
          node {
            objectId,
            name,
            year,
            file
          }
        }
      }
    }
  ''';

  static const getMapReferences = r'''
    query getMapReferences{
      mapReferences {
        edges {
          node {
            objectId,
            key,
            year,
            name,
            mapbox100,
            mapbox50,
            bounds {
              ... on Element {
                value
              }
            }
          }
        }
      }
    }
  ''';

  static const getMapUrlforId = r'''
    query getMapUrlforId($mapId: ID!) {
      map(id: $mapId) {
        url
      }
    }
  ''';

  static const userLogin = r'''
    mutation logIn($username: String!, $password: String!) {
      logIn(input: { username: $username, password: $password }) {
        viewer {
          sessionToken
          user {
            username
            email
          }
        }
      }
    }
  ''';

  static const validateToken = r'''
    query viewer {
      viewer {
        sessionToken
        user {
          username
          email
        }
      }
    }
  ''';

  static const getTours = r'''
  query GetTours {
    tracks {
      edges {
        node {
          id
          objectId
          name
          length
          latitudeNE
          longitudeNE
          latitudeSW
          longitudeSW
          start {
            latitude
            longitude
          }
          geojson {
            url
          }
          vectorAssets {
            url
          }
        }
      }
    }
  }
  ''';
  static const getImageDetails = r'''
    query getImageDetails($id: Float!) {
      images (where: {uuid: {equalTo: $id}}) {
        edges {
          node {
            uuid
            published
            title
            description
            author
            authorURL
            license
            licenseURL
            source
            sourceURL
            image {
              url
            }
          }
        }
      }
    }
  ''';
  static const getTourDetails = r'''
    query getTourDetails($id: ID!) {
      tracks (where: {objectId: {equalTo: $id}}) {
        edges {
          node {
            objectId
            name
            length
            latitudeNE
            longitudeNE
            latitudeSW
            longitudeSW
            geojson {
              name
              url
            }
            vectorAssets {
              url
            }
            start {
              latitude
              longitude
            }
          }
        }
      }
    }
  ''';
}
