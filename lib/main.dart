import 'package:flutter/material.dart';
import 'views/home/home_screen.dart';
import 'views/authentication/register.dart';
import 'views/authentication/login.dart';
import 'login/providers/authorisation.dart';
import 'login/providers/user_provider.dart';
import 'login/utils/preferences.dart';
import 'package:provider/provider.dart';
import 'data/constants.dart' as constants;

import 'data/model/user.dart';
import 'package:test_app/routes.dart';
import 'package:test_app/views/utils/drawer.dart';
import 'data/constants.dart' as constants;

void main() => runApp(const App());

class App extends StatelessWidget {
  const App({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    Future<User> getUserData() => UserPreferences().getUser();

    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthorisationProvider()),
        ChangeNotifierProvider(create: (_) => UserProvider()),
      ],
      child: MaterialApp(
          title: constants.appTitle,
          theme: ThemeData(
            primarySwatch: Colors.blue,
            visualDensity: VisualDensity.adaptivePlatformDensity,
          ),
          home: FutureBuilder(
              future: getUserData(),
              builder: (context, snapshot) {
                switch (snapshot.connectionState) {
                  case ConnectionState.none:
                  case ConnectionState.waiting:
                    return const CircularProgressIndicator();
                  default:
                    return const Login();
                }
              }),
          routes: {
            '/homeScreen': (context) => const HomeScreen(),
            '/login': (context) => const Login(),
            '/register': (context) => const Register(),
          },
        onGenerateRoute: Routes.generateRoute,
      ));
  }
}
