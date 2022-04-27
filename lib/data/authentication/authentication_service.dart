import 'dart:convert';
import 'package:github_repositories/data/authentication/github_login_response.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:http/http.dart' as http;
import '../../configs.dart' as SecretKey;

class AuthenticationService {
  final auth.FirebaseAuth _firebaseAuth = auth.FirebaseAuth.instance;
  Future<auth.User?> loginWithGitHub(String code) async {
    //ACCESS TOKEN REQUEST
    final response = await http.post(
      Uri.parse("https://github.com/login/oauth/access_token"),
      headers: {
        "Content-Type": "application/json",
        "Accept": "application/json"
      },
      body: jsonEncode(GitHubLoginRequest(
        clientId: SecretKey.githubClientID,
        clientSecret: SecretKey.githubClientSecret,
        code: code,
      )),
    );
    GitHubLoginResponse loginResponse =
        GitHubLoginResponse.fromJson(json.decode(response.body));
//FIREBASE SIGNIN
    final auth.AuthCredential credential =
        auth.GithubAuthProvider.credential(loginResponse.accessToken!);

    final auth.User? user =
        (await _firebaseAuth.signInWithCredential(credential)).user;
    return user;
  }
}
