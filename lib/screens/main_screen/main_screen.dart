import 'dart:async';

import 'package:flutter/material.dart';
import 'package:github_repositories/custom_clippers/clip_shadow_path.dart';
import 'package:github_repositories/custom_clippers/custom_clippers.dart';
import 'package:github_repositories/view_models/authentication_view_model.dart';
import 'package:provider/provider.dart';
import 'package:uni_links/uni_links.dart';

const TextStyle _textStyle = TextStyle(
  fontSize: 40,
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

  StreamSubscription? _subs;

  @override
  void initState() {
    super.initState();
    _initDeepLinkListener();
  }

  @override
  void dispose() {
    super.dispose();
    _disposeDeepLinkListener();
  }

  void _initDeepLinkListener() async {
    _subs = getLinksStream().listen(
      (String? link) {
        context.read<AuthenticationViewModel>().checkDeepLink(link!);
      },
      cancelOnError: true,
    );
  }

  void _disposeDeepLinkListener() {
    if (_subs != null) {
      _subs!.cancel();
      _subs = null;
    }
  }

  @override
  Widget build(BuildContext context) {
    AuthenticationViewModel authVM = context.watch<AuthenticationViewModel>();
    bool? userLoggedIn = authVM.authenticationRepository?.loggedIn;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        title: const Text("Github Repository"),
        actions: [
          InkWell(
            onTap: () {
              AuthenticationViewModel authVM =
                  context.read<AuthenticationViewModel>();
              if (userLoggedIn!) {
                authVM.logout();
              } else if (!userLoggedIn) {
                authVM.login();
              }
            },
            child: Container(
              alignment: Alignment.center,
              child: Text(
                userLoggedIn != null && userLoggedIn ? "로그아웃" : "로그인",
              ),
            ),
          ),
        ],
      ),
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
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 10,
            ),
            child: const TextField(
              style: TextStyle(color: Colors.white),
              cursorColor: Colors.white,
              decoration: InputDecoration(
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
          Visibility(
            visible: authVM.loggingIn || authVM.loggingOut,
            child: const Center(child: CircularProgressIndicator()),
          ),
          Visibility(
            visible: !authVM.loggingIn && !authVM.loggingOut,
            child: Center(
              child: Container(
                  child: userLoggedIn != null && userLoggedIn
                      ? pages[_currentIndex]
                      : const Text("Not Logged In")),
            ),
          ),
        ],
      ),
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (int newIndex) {
          setState(
            () {
              _currentIndex = newIndex;
            },
          );
        },
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
      ),
    );
  }
}
