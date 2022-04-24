import 'package:flutter/material.dart';
import 'package:github_repositories/custom_clippers/clip_shadow_path.dart';
import 'package:github_repositories/custom_clippers/custom_clippers.dart';

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
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
          Center(
            child: Container(child: pages[_currentIndex]),
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
