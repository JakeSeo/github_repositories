import 'package:github_repositories/data/user.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String _AUTH_KEY = 'AuthKey';

class AuthenticationRepository {
  AuthenticationRepository();

  Future<bool> isUserLoggedIn() async =>
      Future.delayed(const Duration(seconds: 2)).then((value) async {
        SharedPreferences preference = await SharedPreferences.getInstance();
        return preference.getBool(_AUTH_KEY) ?? false;
      });

  Future<bool> _updateLoginStatus(bool loggedIn) =>
      Future.delayed(const Duration(seconds: 2)).then((value) async {
        SharedPreferences preference = await SharedPreferences.getInstance();
        return preference.setBool(_AUTH_KEY, loggedIn);
      });

  Future<bool> logout() => _updateLoginStatus(false);

  Future<bool> login() => _updateLoginStatus(true);

  Future<User> getUser() {
    return Future.delayed(const Duration(seconds: 2)).then((value) {
      return User();
    });
  }
}
