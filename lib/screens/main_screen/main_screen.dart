import 'dart:async';

import 'package:easy_debounce/easy_debounce.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:github_repositories/custom_clippers/clip_shadow_path.dart';
import 'package:github_repositories/custom_clippers/custom_clippers.dart';
import 'package:github_repositories/data/repositories_repository.dart';
import 'package:github_repositories/data/repository.dart';
import 'package:github_repositories/view_models/authentication_view_model.dart';
import 'package:github_repositories/view_models/repositories_view_model.dart';
import 'package:github_sign_in/github_sign_in.dart';
import 'package:provider/provider.dart';
import '../../configs.dart' as Configs;

const TextStyle _textStyle = TextStyle(
  fontSize: 25,
  fontWeight: FontWeight.bold,
  letterSpacing: 2,
  fontStyle: FontStyle.italic,
);

class MainScreen extends StatefulWidget {
  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;
  List<Widget> pages = const [
    Text('Search', style: _textStyle),
    Text('Profile', style: _textStyle),
  ];
  final myController = TextEditingController();

  void _onClickLoginButton() async {
    final GitHubSignIn gitHubSignIn = GitHubSignIn(
      clientId: Configs.githubClientID,
      clientSecret: Configs.githubClientSecret,
      redirectUrl: Configs.githubCallbackURL,
      clearCache: false,
    );

    // Trigger the sign-in flow
    final result = await gitHubSignIn.signIn(context);

    AuthenticationViewModel authVM = context.read<AuthenticationViewModel>();

    if (result.token != null) {
      authVM.login(result.token!);
    }
  }

  void _searchRepositories(String searchText) async {
    RepositoriesViewModel reposVM = context.read<RepositoriesViewModel>();

    EasyDebounce.debounce('searchDebouncer', const Duration(milliseconds: 500),
        () async {
      bool result = await reposVM.loadSearchRepositories(searchText);
    });
  }

  void _onDestinationSelected(int newIndex) {
    AuthenticationViewModel authVM = context.read<AuthenticationViewModel>();
    RepositoriesViewModel reposVM = context.read<RepositoriesViewModel>();
    setState(
      () {
        _currentIndex = newIndex;
      },
    );
    if (_currentIndex == 0) {
      reposVM.loadSearchRepositories(myController.text);
    } else if (_currentIndex == 1) {
      if (authVM.accessToken != null) {
        authVM.loadUser();
        reposVM.loadUserRepositories(authVM.accessToken!);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    AuthenticationViewModel authVM = context.watch<AuthenticationViewModel>();
    RepositoriesViewModel reposVM = context.watch<RepositoriesViewModel>();
    bool userLoggedIn = authVM.accessToken != null;
    AppBar appBar = AppBar(
      title: const Text("Github Repository"),
      actions: [
        InkWell(
          onTap: () async {
            AuthenticationViewModel authVM =
                context.read<AuthenticationViewModel>();
            if (userLoggedIn) {
              authVM.logout();
            } else if (!userLoggedIn) {
              _onClickLoginButton();
            }
          },
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            alignment: Alignment.center,
            child: Text(
              userLoggedIn ? "로그아웃" : "로그인",
            ),
          ),
        ),
      ],
    );
    NavigationBar navigationBar = NavigationBar(
      height: 70,
      selectedIndex: _currentIndex,
      onDestinationSelected: _onDestinationSelected,
      destinations: const [
        NavigationDestination(
            selectedIcon: Icon(Icons.search),
            icon: Icon(Icons.search_outlined),
            label: 'Search'),
        NavigationDestination(
            selectedIcon: Icon(Icons.person),
            icon: Icon(Icons.person_outline),
            label: 'Profile'),
      ],
    );
    final double statusBarHeight = MediaQuery.of(context).padding.top;
    double contentHeight = MediaQuery.of(context).size.height -
        statusBarHeight -
        appBar.preferredSize.height -
        70;
    final double _yScaling = contentHeight / 896;
    final double bezierHeight = 413.99600000000004 * _yScaling;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: appBar,
      body: Stack(
        children: [
          ClipShadowPath(
            shadow: const BoxShadow(
              color: Colors.black,
              offset: Offset(4, 4),
              blurRadius: 4,
              spreadRadius: 8,
            ),
            clipper: BigClipper(),
            child: Container(
              color: Colors.grey,
            ),
          ),
          ClipShadowPath(
            shadow: const BoxShadow(
              color: Colors.black,
              offset: Offset(4, 4),
              blurRadius: 4,
              spreadRadius: 8,
            ),
            clipper: SmallClipper(),
            child: Container(
              color: Colors.black,
            ),
          ),
          Visibility(
            visible: _currentIndex == 0,
            child: Container(
              padding: const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 10,
              ),
              child: TextField(
                controller: myController,
                onChanged: (text) {
                  _searchRepositories(text);
                },
                style: const TextStyle(color: Colors.white),
                cursorColor: Colors.white,
                decoration: const InputDecoration(
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(color: Colors.white),
                  ),
                  labelText: "검색",
                  labelStyle: TextStyle(color: Colors.grey),
                  icon: Icon(Icons.search, color: Colors.white),
                ),
              ),
            ),
          ),
          Visibility(
            visible: userLoggedIn && _currentIndex == 1,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 16),
              child: authVM.user != null
                  ? Row(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(25.0),
                          child: Image.network(
                            authVM.user!.imagePath,
                            width: 50,
                          ),
                        ),
                        const SizedBox(width: 20),
                        Text(
                          authVM.user!.name,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 36,
                            color: Colors.white,
                          ),
                        ),
                      ],
                    )
                  : Container(),
            ),
          ),
          Visibility(
            visible: authVM.loading || reposVM.loading,
            child: const Center(child: CircularProgressIndicator()),
          ),
          Visibility(
              visible: _currentIndex == 1 && !userLoggedIn,
              child: Center(child: Text("로그인이 필요합니다.", style: _textStyle))),
          Visibility(
            visible: !authVM.loading &&
                !reposVM.loading &&
                !(_currentIndex == 1 && !userLoggedIn),
            child: Positioned(
              bottom: 0,
              child: Container(
                height: contentHeight - bezierHeight + 50,
                width: MediaQuery.of(context).size.width,
                child: ListView.builder(
                  itemCount: reposVM.currRepositories == null
                      ? 0
                      : reposVM.currRepositories!.length,
                  itemBuilder: (context, index) {
                    Repository? repo = reposVM.currRepositories == null
                        ? null
                        : reposVM.currRepositories![index];

                    return Container(
                      width: MediaQuery.of(context).size.width,
                      height: 100,
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: Stack(
                        children: [
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                "Repo: ${repo!.name}",
                                style: const TextStyle(
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              Text("Owner: ${repo.owner}"),
                              Text(
                                "Des: ${repo.description ?? "-"}",
                                overflow: TextOverflow.ellipsis,
                              ),
                              Row(
                                children: [
                                  const Icon(Icons.star_outline, size: 14),
                                  Text("${repo.numStars}"),
                                ],
                              ),
                            ],
                          ),
                          Positioned(
                            right: 0,
                            child: Icon(
                              repo.starred ? Icons.star : Icons.star_outline,
                              color: Colors.yellow.shade600,
                            ),
                          )
                        ],
                      ),
                    );
                  },
                ),
              ),
            ),
          ),
        ],
      ),
      bottomNavigationBar: navigationBar,
    );
  }
}
