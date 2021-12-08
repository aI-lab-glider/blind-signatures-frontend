import 'package:flutter/material.dart';
import 'package:test_app/data/model/poll.dart';

import 'components.dart';
import 'package:test_app/data/data_source.dart' as data;
import 'package:test_app/data/model/question.dart';
import 'package:test_app/data/constants.dart' as constants;

class BallotScreen extends StatelessWidget {
  const BallotScreen(this.poll);

  final Poll poll;

  Widget _buildQuestion({required Question question}) {
    return Scaffold(
      appBar: AppBar(title: Text(poll.title)),
      body: Column(
        children: [
          QuestionText(question.questionText),
          Ballot(question.answers.keys.toList(), poll.id),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Question>(
        future: data.fetchPollQuestion(id: poll.id),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return Scaffold(
              appBar: AppBar(title: const Text(constants.appTitle)),
              body: const Center( child: Text('An error has occurred!', textAlign: TextAlign.center,) ) ,
            );
          } else if (snapshot.hasData) {
            return _buildQuestion(question: snapshot.data!);
          } else {
            return Scaffold(
                appBar: AppBar(title: const Text(constants.appTitle)),
                body: const Center(
                  child: CircularProgressIndicator(),
                )
            );
          }
        }
    );
  }
}