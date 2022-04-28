import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:graphql/client.dart';
import 'package:historical_guide/core/commons/graphql_setup.dart';
import 'package:historical_guide/core/exeptions/general_exeption.dart';
import 'package:historical_guide/core/services/interfaces/i_user_repository.dart';
import 'package:historical_guides_commons/historical_guides_commons.dart';

class ParseUsersRepository implements IUsersRepository {
  GraphQLClient? _client;
  GraphQLClient get client {
    return _client ??= GraphQLClient(
      cache: GraphQLCache(),
      link: HttpLink(GraphQLSetup.graphqlAPI,
          defaultHeaders: GraphQLSetup.graphQLHeader),
    );
  }

  @override
  Future<String> doUserLogin(String username, String password) async {
    final options = QueryOptions(
      document: gql(GraphQLQueries.userLogin),
      variables: {
        "username": username,
        "password": password,
      },
    );

    final result = await client.query(options);
    print(result);

    if (result.hasException) {
      final message =
          result.exception?.graphqlErrors.first.message ?? 'Login Error';
      throw GeneralExeption(title: 'graphQL Exception', message: message);
    } else {
      print(result.data);
      return result.data?['logIn']['viewer']['sessionToken'] as String;
    }
  }

  // @override
  // Future<bool> hasUserLogged() async {
  //   ParseUser? currentUser = await ParseUser.currentUser() as ParseUser?;
  //   if (currentUser == null) {
  //     return false;
  //   }
  //   //Checks whether the user's session token is valid
  //   final ParseResponse? parseResponse =
  //       await ParseUser.getCurrentUserFromServer(currentUser.sessionToken!);

  //   if (parseResponse?.success == null || !parseResponse!.success) {
  //     //Invalid session. Logout
  //     await currentUser.logout();
  //     return false;
  //   } else {
  //     return true;
  //   }
  // }

  @override
  Future<bool> validateToken(String token) async {
    var header = {
      'X-Parse-Application-Id': dotenv.env['APP_ID']!,
      'X-Parse-Client-Key': dotenv.env['CLIENT_KEY']!,
      'X-Parse-Session-Token': token
    };
    final client = GraphQLClient(
      cache: GraphQLCache(),
      link: HttpLink(
        GraphQLSetup.graphqlAPI,
        defaultHeaders: header,
      ),
    );
    final options = QueryOptions(
      document: gql(GraphQLQueries.validateToken),
    );

    final result = await client.query(options);
    return result.data != null;
  }
}
