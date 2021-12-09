import 'package:flutter/material.dart';
import 'views/authentication/login.dart';
import 'login/providers/authorisation.dart';
import 'login/providers/user_provider.dart';
import 'login/utils/preferences.dart';
import 'package:provider/provider.dart';
import 'data/constants.dart' as Constants;
import 'package:test_app/routes.dart';

import 'login/user/user.dart';

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
          title: Constants.appTitle,
          onGenerateRoute: Routes.generateRoute,
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
          ),
    );
  }
}