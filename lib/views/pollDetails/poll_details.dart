import 'package:english_words/english_words.dart';
import 'package:flutter/material.dart';
import 'package:test_app/data/constants.dart' as constants;
import 'package:test_app/data/model/poll.dart';

import 'components.dart';
import 'package:test_app/data/data_source.dart' as data;

class PollDetailsScreen extends StatelessWidget {
  const PollDetailsScreen(this.id);

  final int id;

  Widget _optionDependingOnExpirationDate({required Poll poll}) {
    if (poll.expirationDate.isAfter(DateTime.now())) {
      return StartButton(poll);
    }
    else {
      return PollStatistics(poll.id, true);
    }
  }

  Widget _buildDetails({required Poll poll}) {
    return Scaffold(
        appBar: AppBar(title: Text(poll.title)),
        body: Column(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(poll.description, textAlign: TextAlign.center,)
              ),
              _optionDependingOnExpirationDate(poll: poll)
            ]
        )
    );
  }

    @override
    Widget build(BuildContext context) {
      return FutureBuilder<Poll>(
          future: data.fetchPollDetails(id: id),
          builder: (context, snapshot) {
            if (snapshot.hasError) {
              return Scaffold(
                appBar: AppBar(title: const Text(constants.appTitle)),
                body: const Center( child: Text('An error has occurred!', textAlign: TextAlign.center,) ) ,
              );
            } else if (snapshot.hasData) {
              return Container(
                  child: _buildDetails(poll: snapshot.data!)
              );
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

