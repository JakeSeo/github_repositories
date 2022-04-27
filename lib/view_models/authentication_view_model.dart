import 'package:flutter/material.dart';
import 'package:github_repositories/data/authentication/authentication_repository.dart';

class AuthenticationViewModel extends ChangeNotifier {
  AuthenticationRepository? authenticationRepository;
  bool loggingIn = false;
  bool loggingOut = false;

  AuthenticationViewModel(this.authenticationRepository);

  Future<bool> login(String token) async {
    loggingIn = true;
    notifyListeners();
    final result = await authenticationRepository!.login(token);
    loggingIn = false;
    notifyListeners();
    return result;
  }

  Future<bool> logout() async {
    loggingOut = true;
    notifyListeners();
    final result = await authenticationRepository!.logout();
    loggingOut = false;
    notifyListeners();
    return loggingOut;
  }
}
