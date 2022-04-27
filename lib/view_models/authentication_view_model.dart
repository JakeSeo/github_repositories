import 'package:flutter/material.dart';
import 'package:github_repositories/data/authentication_repository.dart';

import '../data/custom_user.dart';

class AuthenticationViewModel extends ChangeNotifier {
  AuthenticationRepository? authenticationRepository;
  bool loading = false;

  String? accessToken;

  CustomUser? user;

  AuthenticationViewModel(this.authenticationRepository);

  Future<bool> login(String token) async {
    loading = true;
    notifyListeners();
    final result = await authenticationRepository!.login(token);
    accessToken = await authenticationRepository?.getSavedAccessToken();
    loading = false;
    notifyListeners();
    return result;
  }

  Future<bool> logout() async {
    loading = true;
    notifyListeners();
    final result = await authenticationRepository!.logout();
    loading = false;
    notifyListeners();
    return result;
  }

  void loadUser() async {
    loading = true;
    notifyListeners();
    user = await authenticationRepository!.getUser();
    loading = false;
    notifyListeners();
  }
}
