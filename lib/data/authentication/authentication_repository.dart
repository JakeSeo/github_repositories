import 'package:github_repositories/data/authentication/authentication_service.dart';
import 'package:github_repositories/data/user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../secret_keys.dart' as SecretKey;
import 'package:url_launcher/url_launcher.dart';

const String _AUTH_KEY = 'AuthKey';

class AuthenticationRepository {
  bool? loggedIn;
  AuthenticationRepository();

  final AuthenticationService authService = AuthenticationService();

  Future<bool?> isUserLoggedIn() async {
    loggedIn =
        await Future.delayed(const Duration(seconds: 2)).then((value) async {
      SharedPreferences preference = await SharedPreferences.getInstance();
      return preference.getBool(_AUTH_KEY) ?? false;
    });
    return loggedIn;
  }

  Future<bool> _updateLoginStatus(bool loggedIn) {
    return Future.delayed(const Duration(seconds: 2)).then((value) async {
      this.loggedIn = loggedIn;
      SharedPreferences preference = await SharedPreferences.getInstance();
      return preference.setBool(_AUTH_KEY, loggedIn);
    });
  }

  void onClickGitHubLoginButton() async {
    const String url = "https://github.com/login/oauth/authorize" +
        "?client_id=" +
        SecretKey.GITHUB_CLIENT_ID +
        "&scope=public_repo%20read:user%20user:email";
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(
        Uri.parse(url),
      );
    } else {
      print("CANNOT LAUNCH THIS URL!");
    }
  }

  Future<bool> logout() => _updateLoginStatus(false);

  void login() => onClickGitHubLoginButton();

  Future<User> getUser() {
    return Future.delayed(const Duration(seconds: 2)).then((value) {
      return User();
    });
  }
}
