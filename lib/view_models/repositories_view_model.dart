import 'package:flutter/material.dart';
import 'package:github_repositories/data/repositories_repository.dart';
import 'package:github_repositories/data/repository.dart';

class RepositoriesViewModel extends ChangeNotifier {
  RepositoriesRepository? repositoriesRepository;
  RepositoriesViewModel(this.repositoriesRepository);

  bool loading = false;

  List<Repository>? currRepositories;

  Future<bool> loadSearchRepositories(String searchText) async {
    loading = true;
    notifyListeners();

    currRepositories =
        await repositoriesRepository!.searchRepositories(searchText);
    loading = false;
    notifyListeners();

    if (currRepositories == null) {
      return false;
    }

    return true;
  }

  void clearRepositories() {
    currRepositories = [];
    notifyListeners();
  }

  Future<bool> loadUserRepositories(String accessToken) async {
    loading = true;
    notifyListeners();

    currRepositories =
        await repositoriesRepository!.getUserRepositories(accessToken);
    loading = false;
    notifyListeners();

    if (currRepositories == null) {
      return false;
    }

    return true;
  }

  Future<bool> starRepository() async {
    return true;
  }

  Future<bool> unstarRepository() async {
    return true;
  }
}
