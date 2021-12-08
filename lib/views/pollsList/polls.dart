import 'package:flutter/material.dart';
import 'package:test_app/data/model/poll.dart';
import 'package:test_app/views/pollDetails/poll_details.dart';
import 'package:test_app/data/data_source.dart' as data;

class PollsScreen extends StatelessWidget {
  const PollsScreen({Key? key}) : super(key: key);

  Widget _buildRow(BuildContext context, Poll poll){
    return ListTile(
      title: Text(poll.title),
      onTap: () => {
        Navigator.pushNamed(
        context, "/pollDetails", arguments: poll.id)
      },
    );
  }

  Widget _buildList({required List<Poll> pollsList}){
    return ListView.builder(
        itemBuilder: (context, i) {
          if (i.isOdd) return const Divider();
          return _buildRow(context, pollsList[i ~/ 2]);
        },
      itemCount: pollsList.length * 2,
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Poll>>(
        future: data.fetchPolls(),
        builder: (context, snapshot) {
          if (snapshot.hasError) {
            return const Center(
              child: Text('An error has occurred!'),
            );
          } else if (snapshot.hasData) {
            return Container(
              child: _buildList(pollsList: snapshot.data!)
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