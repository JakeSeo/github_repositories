import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:github_repositories/data/authentication/authentication_repository.dart';
import 'package:github_repositories/data/repositories_repository.dart';
import 'package:github_repositories/router/github_repository_router_delegate.dart';
import 'package:github_repositories/screens/main_screen/main_screen.dart';
import 'package:github_repositories/view_models/authentication_view_model.dart';
import 'package:github_repositories/view_models/repositories_view_model.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  late GithubRepositoryRouterDelegate routerDelegate;
  late AuthenticationRepository authenticationRepository;
  late RepositoriesRepository repositoriesRepository;
  @override
  void initState() {
    super.initState();
    authenticationRepository = AuthenticationRepository();
    repositoriesRepository = RepositoriesRepository();
    routerDelegate = GithubRepositoryRouterDelegate(
        authenticationRepository, repositoriesRepository);
  }

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider<AuthenticationViewModel>(
          create: (_) => AuthenticationViewModel(authenticationRepository),
        ),
        ChangeNotifierProvider<RepositoriesViewModel>(
          create: (_) => RepositoriesViewModel(repositoriesRepository),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Github Repository',
        theme: ThemeData(
          primarySwatch: const MaterialColor(
            0xFF000000,
            <int, Color>{
              50: Color(0xFF000000),
              100: Color(0xFF000000),
              200: Color(0xFF000000),
              300: Color(0xFF000000),
              400: Color(0xFF000000),
              500: Color(0xFF000000),
              600: Color(0xFF000000),
              700: Color(0xFF000000),
              800: Color(0xFF000000),
              900: Color(0xFF000000),
            },
          ),
        ),
        home: Router(
          routerDelegate: routerDelegate,
          backButtonDispatcher: RootBackButtonDispatcher(),
        ),
      ),
    );
  }
}
