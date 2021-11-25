import 'package:flutter/material.dart';


Future<void> showFilterDialog(BuildContext context) {
  String _sortValue = "Title";
  String _ascValue = "ASC";

    return showDialog(
        context: context,
        builder: (BuildContext build) {
          return StatefulBuilder(builder: (context, setState) {
            return AlertDialog(
              title: const Center(
                  child: Text(
                    "Sort",
                  )),
              actions: <Widget>[
                TextButton(
                  onPressed: () => Navigator.pop(context, {_sortValue: _ascValue}),
                  child: const Text('Cancel'),
                ),
                TextButton(
                  onPressed: () => Navigator.pop(context, {_sortValue: _ascValue}),
                  child: const Text('OK'),
                ),
              ],
              content: SingleChildScrollView(
                child: Column(
                  children: <Widget>[
                    Container(
                      padding: EdgeInsets.only(top: 12, right: 10),
                      child: Row(
                        children: <Widget>[
                          const Padding(
                            padding: EdgeInsets.only(right: 16.0),
                            child: Icon(
                              Icons.sort,
                              color: Color(0xff808080),
                            ),
                          ),
                          Expanded(
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                isExpanded: true,
                                hint: Text("Sort by"),
                                items: <String>[
                                  "Title",
                                  "Date",
                                ].map((String value) {
                                  return DropdownMenuItem(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                value: _sortValue,
                                onChanged: (newValue) {
                                  setState(() {
                                    _sortValue = newValue!;
                                  });
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                    Container(
                      padding: EdgeInsets.only(top: 8, right: 10),
                      child: Row(
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.only(right: 16.0),
                            child: Icon(
                              Icons.sort_by_alpha,
                              color: Color(0xff808080),
                            ),
                          ),
                          Expanded(
                            child: DropdownButtonHideUnderline(
                              child: DropdownButton<String>(
                                isExpanded: true,
                                items: <String>[
                                  "ASC",
                                  "DESC",
                                ].map((String value) {
                                  return DropdownMenuItem(
                                    value: value,
                                    child: Text(value),
                                  );
                                }).toList(),
                                value: _ascValue,
                                onChanged: (newValue) {
                                  setState(() {
                                    _ascValue = newValue!;
                                  });
                                },
                              ),
                            ),
                          )
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            );
          });
        });
}
