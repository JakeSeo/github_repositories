import 'package:flutter/material.dart';
import 'package:github_repositories/screens/main_screen/main_screen.dart';

class MainPage extends Page {
  const MainPage() : super(key: const ValueKey('MainPage'));

  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (BuildContext context) {
        return const MainScreen();
      },
    );
  }
}
