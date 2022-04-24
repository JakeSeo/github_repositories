import 'package:flutter/material.dart';
import 'package:github_repositories/data/repositories_repository.dart';

class RepositoriesViewModel extends ChangeNotifier {
  RepositoriesRepository? repositoriesRepository;
  RepositoriesViewModel(this.repositoriesRepository);
}
