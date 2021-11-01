import 'package:flutter/material.dart';
import 'package:test_app/views/ballot/poll.dart';
import 'package:test_app/views/pollDetails/poll_details.dart';
import 'package:test_app/views/pollsList/polls.dart';
import 'package:test_app/views/profile/profile.dart';
import 'package:test_app/views/home/home_screen.dart';

class Routes {

  static Route<dynamic> generateRoute(RouteSettings settings) {
    // Getting arguments passed in while calling Navigator.pushNamed
    final args = settings.arguments;

    switch (settings.name) {
      case '/':
        return MaterialPageRoute(builder: (_) => HomeScreen());
      case '/polls':
        return MaterialPageRoute(builder: (_) => PollsScreen());
      case '/profile':
        return MaterialPageRoute(builder: (_) => ProfileScreen());
      case '/pollDetails':
        if (args is int) {
          return MaterialPageRoute(
            builder: (_) => PollDetailsScreen(args),
          );
        }
        else {
          return MaterialPageRoute(builder: (_) => HomeScreen());
        }
      case '/ballot':
        if (args is String) {
          return MaterialPageRoute(
            builder: (_) => BallotScreen(args),
          );
        }
        else {
          return MaterialPageRoute(builder: (_) => HomeScreen());
        }
      default:
        return MaterialPageRoute(builder: (_) => HomeScreen());
    }
  }
}
