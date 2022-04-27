import 'dart:convert';
import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:github_repositories/data/custom_user.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../configs.dart' as configs;
import 'package:http/http.dart' as http;

const String _AUTH_KEY = 'AuthKey';

class AuthenticationRepository {
  AuthenticationRepository();

  Future<String?> getSavedAccessToken() async {
    String? accessToken =
        await Future.delayed(const Duration(seconds: 2)).then((value) async {
      SharedPreferences preference = await SharedPreferences.getInstance();
      return preference.getString(_AUTH_KEY);
    });
    return accessToken;
  }

  Future<bool> _logout() async {
    try {
      FirebaseAuth.instance.signOut();
    } on Exception catch (e) {
      print(e);
      return false;
    }
    SharedPreferences preference = await SharedPreferences.getInstance();
    preference.remove(_AUTH_KEY);
    return true;
  }

  Future<bool> _login(String token) async {
    SharedPreferences preference = await SharedPreferences.getInstance();
    preference.setString(_AUTH_KEY, token);
    try {
      final githubAuthCredential = GithubAuthProvider.credential(token);
      await FirebaseAuth.instance.signInWithCredential(githubAuthCredential);
    } on Exception catch (e) {
      print(e);
      return false;
    }
    return true;
  }

  Future<bool> logout() => _logout();

  Future<bool> login(String token) => _login(token);

  Future<CustomUser?> getUser() async {
    String? accessToken = await getSavedAccessToken();
    if (accessToken == null) return null;
    var url = Uri.parse(configs.githubAPIURL + configs.githubAPIUser);
    var response = await http.get(
      url,
      headers: {
        "Authorization": "token $accessToken",
      },
    );

    var jsonUser = json.decode(response.body);
    CustomUser user = CustomUser.fromJson(jsonUser);

    return user;
  }
}
