import 'package:flutter/material.dart';
import 'package:test_app/views/pollDetails/poll_details.dart';

class PollsScreen extends StatelessWidget {
  const PollsScreen();

  Widget _buildRow(BuildContext context, int i){
    return ListTile(
      title: Text("Poll #$i"),
      onTap: () => {
        Navigator.pushNamed(
        context, "/pollDetails", arguments: i)
      },
    );
  }

  Widget _buildList(){
    return ListView.builder(
        itemBuilder: (context, i) {
          if (i.isOdd) return const Divider();

          return _buildRow(context, i ~/ 2);
        }
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      child: _buildList(),
    );
  }
}