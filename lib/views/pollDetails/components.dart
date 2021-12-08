import 'dart:math';

import 'package:english_words/english_words.dart';
import 'package:charts_flutter/flutter.dart' as charts;
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import 'package:test_app/data/constants.dart' as constants;
import 'package:test_app/data/data_source.dart' as data;
import 'package:test_app/data/model/poll.dart';
import 'package:test_app/data/model/question.dart';


class StartButton extends StatelessWidget {
  const StartButton(this.poll);

  final Poll poll;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: ElevatedButton(
        onPressed: () {
          Navigator.pushNamed(
              context,
              '/ballot',
              arguments: poll
          );
        },
        child: const Text('Start!'),
      ),
    );
  }
}

class PollStatistics extends StatelessWidget {
  final int pollID;
  final bool? animate;

  const PollStatistics(this.pollID, this.animate);

  static List<charts.Series<VotesPerOption, String>> _createData(Map<String, int> answers) {
    final data = answers.entries
        .map((entry) => VotesPerOption(entry.key, entry.value))
        .toList();

    final overallVotesCount = data.fold(0, (int val, current) => val + current.votesCount);

    return [
      charts.Series<VotesPerOption, String>(
        id: 'Votes',
        domainFn: (VotesPerOption votesCount, _) => votesCount.option,
        measureFn: (VotesPerOption votesCount, _) => votesCount.votesCount,
        data: data,
        labelAccessorFn: (VotesPerOption votesCount, _) => '${(votesCount.votesCount/overallVotesCount*100).toStringAsFixed(0)}%',
      )
    ];
  }

  Widget _buildStats({required Question question}) {
    return Column(
      children: [
        const Text("Poll Statistics", style: TextStyle(fontWeight: FontWeight.bold)),
        Container(
            padding: const EdgeInsets.all(8.0),
            child:  SizedBox(
                height: 200.0,
                child: charts.PieChart<String>(
                  _createData(question.answers),
                  animate: animate,
                  defaultInteractions: true,
                  behaviors: [
                    charts.DatumLegend(
                      position: charts.BehaviorPosition.start,
                      outsideJustification: charts.OutsideJustification.middleDrawArea,
                      desiredMaxColumns: 2,
                      desiredMaxRows: 5,)
                  ],
                  defaultRenderer: charts.ArcRendererConfig(
                      arcWidth: 100,
                      arcRendererDecorators: [
                        charts.ArcLabelDecorator(
                            labelPosition: charts.ArcLabelPosition.auto,
                        )]
                  ),
                )
            )
        ),
        Text("${2+Random().nextInt(98)}% of all users voted."), // TODO: count this
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Question>(
        future: data.fetchPollQuestion(id: pollID),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            print(snapshot.error);
            return const Center(
              child: Text('An error has occurred!'),
            );
          } else if (snapshot.hasData) {
            return Container(
                child: _buildStats(question: snapshot.data!)
            );
          } else {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
        }
    );
  }
}


class VotesPerOption {
  String option;
  int votesCount;

  VotesPerOption(this.option, this.votesCount);
}