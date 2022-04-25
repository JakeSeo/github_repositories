import 'package:flutter/material.dart';
import 'package:github_repositories/data/authentication/authentication_repository.dart';

class AuthenticationViewModel extends ChangeNotifier {
  AuthenticationRepository? authenticationRepository;
  bool loggingIn = false;
  bool loggingOut = false;

  AuthenticationViewModel(this.authenticationRepository);

  Future<bool> login() async {
    loggingIn = true;
    notifyListeners();
    authenticationRepository!.login();
    loggingIn = false;
    notifyListeners();
    return true;
  }

  Future<bool> logout() async {
    loggingOut = true;
    notifyListeners();
    final result = await authenticationRepository!.logout();
    loggingOut = false;
    notifyListeners();
    return loggingOut;
  }

  void checkDeepLink(String link) {
    String code = link.substring(link.indexOf(RegExp('code=')) + 5);
    authenticationRepository?.authService
        .loginWithGitHub(code)
        .then((firebaseUser) {
      print(firebaseUser!.email);
      print(firebaseUser.photoURL);
      print("LOGGED IN AS:  ${firebaseUser.displayName}");
    }).catchError((e) {
      print("LOGIN ERROR: " + e.toString());
    });
  }
}
