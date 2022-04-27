import 'package:github_repositories/data/repository.dart';
import '../configs.dart' as configs;
import 'package:http/http.dart' as http;
import 'dart:convert';

class RepositoriesRepository {
  List<Repository>? jsonToRepositoriesList(dynamic jsonRepositories) {
    var jsonArrayRepositories =
        jsonRepositories != null ? List.from(jsonRepositories) : null;
    List<Repository>? repositories = jsonArrayRepositories
        ?.map((tagJson) => Repository.fromJson(tagJson))
        .toList();
    return repositories;
  }

  Future<List<Repository>?> searchRepositories(String searchText) async {
    var url = Uri.parse(configs.githubAPIURL +
        configs.githubAPISearch +
        "?q=$searchText&page=1&per_page=100");
    var response = await http.get(
      url,
    );
    final jsonRepositories = json.decode(response.body)["items"];

    return jsonToRepositoriesList(jsonRepositories);
  }

  Future<List<Repository>?> getUserRepositories(String accessToken) async {
    var url = Uri.parse(configs.githubAPIURL +
        configs.githubAPIUserRepos +
        "?page=1&per_page=100");
    var response = await http.get(
      url,
      headers: {
        "Authorization": "token $accessToken",
      },
    );

    final jsonRepositories = json.decode(response.body);
    List<Repository> repositories = [];

    return jsonToRepositoriesList(jsonRepositories);
  }
}
