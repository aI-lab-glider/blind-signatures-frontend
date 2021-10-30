import 'package:flutter/material.dart';
import 'package:test_app/views/pollDetails/poll_details.dart';

import 'components.dart';

class BallotScreen extends StatelessWidget {
  const BallotScreen(this.pollName);

  final String pollName;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(pollName)),
      body: Column(
        children: [
          Question(pollName),
          Options(pollName),
          SubmitButton(),
        ],
      ),
    );
  }
}