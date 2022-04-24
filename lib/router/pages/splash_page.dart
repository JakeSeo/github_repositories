import 'package:flutter/material.dart';
import 'package:github_repositories/screens/splash_screen.dart';

class SplashPage extends Page {
  SplashPage() : super(key: const ValueKey('SplashPage'));

  @override
  Route createRoute(BuildContext context) {
    return MaterialPageRoute(
      settings: this,
      builder: (BuildContext context) {
        return const SplashScreen();
      },
    );
  }
}
