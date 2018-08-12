import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:todo_flutter_app/state/domain.dart';
import 'package:todo_flutter_app/view/issue_list/issue_list.dart';

Widget wJqlTabsPage() => StoreConnector<AppState, ViewState>(
      converter: (store) => store.state.view,
      builder: (context, view) {
        var tabs = view.issueListViews.map((i) {
          // fixme: re-rendered on every minor change!!
//          print(i.name);
          return Tab(
            icon: Icon(Icons.directions_car),
            text: i.name,
          );
        }).toList();

        var children = view.issueListViews.map((i) {
          print(i.name);
          return wIssueList(i.items);
        }).toList();
//        var selected = List.of(view.issueListViews.values).indexOf(view.selectedIssueListView)

        return DefaultTabController(
//          initialIndex: ,
          length: 3,
          child: Scaffold(
            appBar: AppBar(
              bottom: TabBar(
                tabs: tabs,
              ),
              title: Text('Issue Lists: Valami'),
            ),
            body: TabBarView(
              children: children,
            ),
          ),
        );
      },
    );
