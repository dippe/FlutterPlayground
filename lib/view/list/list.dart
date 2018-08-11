import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:todo_flutter_app/state/domain.dart';
import 'package:todo_flutter_app/view/list/list_item.dart';

Widget wListPage() => StoreConnector<AppState, ViewState>(
      converter: (store) => store.state.view,
      builder: (context, view) {
        var tabs = view.issueListViews.map((i) {
          print(i.name);
          return Tab(
            icon: Icon(Icons.directions_car),
            text: i.name,
          );
        }).toList();

        var children = view.issueListViews.map((i) {
          print(i.name);
          return wList(i.items);
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

Widget wList(List<ListItemData> issues) => ListView(
      scrollDirection: Axis.vertical,
      children: issues.map((item) => wDraggableListItem(item)).toList(),
    );
