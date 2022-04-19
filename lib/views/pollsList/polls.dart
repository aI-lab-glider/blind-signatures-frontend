import 'package:flutter/material.dart';
import 'package:test_app/data/model/poll.dart';
import 'package:test_app/data/data_source.dart' as data;
import 'package:test_app/data/constants.dart' as constants;
import 'package:test_app/views/utils/drawer.dart';

import 'components/custom_search.dart';

class PollsScreen extends StatefulWidget {
  const PollsScreen({Key? key}) : super(key: key);

  @override
  State<StatefulWidget> createState() => PollsListSortState();
}

class PollsListSortState extends State<PollsScreen> {
  SortingParameter _sortBy = SortingParameter.title;

  Widget _buildRow(BuildContext context, Poll poll) {
    return ListTile(
      title: Text(poll.title),
      onTap: () =>
          {Navigator.pushNamed(context, "/pollDetails", arguments: poll.id)},
    );
  }

  Widget _buildList({required List<Poll> pollsList}) {
    if (_sortBy == SortingParameter.title) {
      pollsList.sort((a, b) => a.title.compareTo(b.title));
    }
    if (_sortBy == SortingParameter.date) {
      pollsList.sort((a, b) => a.expirationDate.compareTo(b.expirationDate));
    }
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
            return Scaffold(
              appBar: AppBar(
                title: const Text(constants.appTitle),
                automaticallyImplyLeading: false,
              ),
              body: const Center(
                  child: Text(
                'An error has occurred!',
                textAlign: TextAlign.center,
              )),
            );
          } else if (snapshot.hasData) {
            return WillPopScope(
                onWillPop: () async {
                  return false;
                },
                child: Scaffold(
                  appBar: AppBar(
                    title: const Text(constants.appTitle),
                    automaticallyImplyLeading: false,
                    actions: <Widget>[
                      IconButton(
                          icon: const Icon(
                            Icons.search,
                          ),
                          onPressed: () {
                            showSearch(
                              context: context,
                              delegate: CustomSearch(snapshot.data!),
                            );
                          }),
                      PopupMenuButton(
                          icon: const Icon(Icons.sort),
                          itemBuilder: (BuildContext context) =>
                              <PopupMenuEntry<SortingParameter>>[
                                PopupMenuItem<SortingParameter>(
                                    value: SortingParameter.title,
                                    child: GestureDetector(
                                      child: Text('Sort by title'),
                                      onTap: () {
                                        setState(() =>
                                            _sortBy = SortingParameter.title);
                                      },
                                    )),
                                PopupMenuItem<SortingParameter>(
                                    value: SortingParameter.date,
                                    child: GestureDetector(
                                      child: Text('Sort by date'),
                                      onTap: () {
                                        setState(() =>
                                            _sortBy = SortingParameter.date);
                                      },
                                    )),
                              ]),
                    ],
                  ),
                  body: _buildList(pollsList: snapshot.data!),
                  drawer: AppDrawer(),
                )
            );
          } else {
            return Scaffold(
                appBar: AppBar(
                    title: const Text(constants.appTitle),
                    automaticallyImplyLeading: false,
                ),
                body: const Center(
                  child: CircularProgressIndicator(),
                ));
          }
        });
  }
}

enum SortingParameter { title, date }
