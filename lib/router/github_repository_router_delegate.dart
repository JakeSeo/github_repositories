import 'package:flutter/material.dart';
import 'package:github_repositories/data/authentication_repository.dart';
import 'package:github_repositories/data/repositories_repository.dart';
import 'package:github_repositories/router/pages/main_page.dart';
import 'package:github_repositories/router/pages/splash_page.dart';

class GithubRepositoryRouterDelegate extends RouterDelegate
    with ChangeNotifier, PopNavigatorRouterDelegateMixin {
  final GlobalKey<NavigatorState> _navigatorKey = GlobalKey<NavigatorState>();

  final AuthenticationRepository authenticationRepository;
  final RepositoriesRepository repositoriesRepository;

  bool? _loggedIn;
  bool? get loggedIn => _loggedIn;
  set loggedIn(value) {
    _loggedIn = value;
    notifyListeners();
  }

  List<Page> get _splashStack {
    return [
      SplashPage(),
    ];
  }

  List<Page> get _loggedInStack => [
        const MainPage(),
      ];

  GithubRepositoryRouterDelegate(
      this.authenticationRepository, this.repositoriesRepository) {
    _init();
  }

  _init() async {
    loggedIn = await authenticationRepository.isUserLoggedIn();
  }

  @override
  GlobalKey<NavigatorState>? get navigatorKey => _navigatorKey;

  @override
  Widget build(BuildContext context) {
    List<Page> stack;
    final loggedIn = this.loggedIn;
    if (loggedIn == null) {
      stack = _splashStack;
    } else {
      stack = _loggedInStack;
    }
    return Navigator(
      key: navigatorKey,
      pages: stack,
      onPopPage: (route, result) {
        if (!route.didPop(result)) return false;
        return true;
      },
    );
  }

  @override
  void removeListener(VoidCallback listener) {
    // TODO: implement removeListener
  }

  @override
  Future<void> setNewRoutePath(configuration) async {}
}
