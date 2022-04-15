abstract class IUsersRepository {
  Future<String> doUserLogin(String username, String password);
  // Future<bool> hasUserLogged();

  Future<bool> validateToken(String token);
}
