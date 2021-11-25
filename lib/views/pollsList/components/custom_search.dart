import 'package:flutter/material.dart';
import 'package:test_app/data/model/poll.dart';

class CustomSearch extends SearchDelegate {
  List<Poll> searchResult = List.empty(growable: true);
  final List<Poll> pollsList;

  CustomSearch(this.pollsList);

  @override
  List<Widget> buildActions(BuildContext context) {
    return [
      IconButton(
        icon: Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      ),
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    return IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    searchResult.clear();

    searchResult = pollsList.where(
                (item) => item.title.toLowerCase().contains(query.toLowerCase())
        ).toList();

    return ListView.builder(
        itemCount: searchResult.length,
        itemBuilder: (BuildContext context, int index) {
          var poll = searchResult[index];
          return ListTile(
            title: Text(poll.title),
            onTap: () => {
              Navigator.pushNamed(context, "/pollDetails", arguments: poll.id)
            },);
        });
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    var listToShow;
    if (query.isNotEmpty) {
      listToShow = pollsList.where(
              (item) => item.title.toLowerCase().contains(query.toLowerCase())
      ).toList();
    } else {
      listToShow = pollsList;
    }

// view a list view with the search result
    return ListView.builder(
        itemCount: listToShow.length,
        itemBuilder: (BuildContext context, int index) {
            var poll = listToShow[index];
            return ListTile(
              title: Text(poll.title),
              onTap: () => {
                Navigator.pushNamed(context, "/pollDetails", arguments: poll.id)
                },);
          });
  }

}