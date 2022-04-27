import 'dart:io';

import 'package:firebase_auth/firebase_auth.dart';
import 'package:github_repositories/data/authentication/authentication_service.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../configs.dart' as Configs;
import 'package:http/http.dart' as http;

const String _AUTH_KEY = 'AuthKey';

class AuthenticationRepository {
  bool? loggedIn;
  UserCredential? user;
  String? accessToken;
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

  Future<bool> _logout() async {
    try {
      FirebaseAuth.instance.signOut();
    } on Exception catch (e) {
      print(e);
      return false;
    }
    loggedIn = false;
    return true;
  }

  Future<bool> _login(String token) async {
    accessToken = token;
    print("access token: $accessToken");
    try {
      final githubAuthCredential = GithubAuthProvider.credential(token);
      user = await FirebaseAuth.instance
          .signInWithCredential(githubAuthCredential);
    } on Exception catch (e) {
      print(e);
      return false;
    }
    loggedIn = true;
    return true;
  }

  Future<bool> logout() => _logout();

  Future<bool> login(String token) => _login(token);

  Future<void> getUser() async {
    var url =
        Uri.parse(Configs.githubAPIURL + Configs.githubAPISearch + "?q=D");
    var response = await http.get(
      url,
      headers: {
        "Authorization": "token ${accessToken!}",
      },
    );

    print("response: ${response.body} ${accessToken}");
  }
}
