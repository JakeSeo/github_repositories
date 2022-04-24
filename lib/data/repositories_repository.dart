import 'package:github_repositories/data/repository.dart';

class RepositoriesRepository {
  Future<List<Repository>> searchRepositories(String searchText) {
    return Future.delayed(const Duration(seconds: 3)).then(((value) => []));
  }

  Future<List<Repository>> getAllRepositories() {
    return Future.delayed(const Duration(seconds: 3)).then(((value) => []));
  }
}
