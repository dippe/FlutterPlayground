import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:todo_flutter_app/state/domain.dart';
import 'package:todo_flutter_app/state/state.dart' as State;
import 'package:todo_flutter_app/view/list/ListItem.dart';

Widget wListPage() => DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          bottom: TabBar(
            tabs: [
              Tab(icon: Icon(Icons.directions_car)),
              Tab(icon: Icon(Icons.directions_transit)),
              Tab(icon: Icon(Icons.directions_bike)),
            ],
          ),
          title: Text('Issue Lists: Valami'),
        ),
        body: TabBarView(
          children: [
            wList(),
            Icon(Icons.directions_transit),
            Icon(Icons.directions_bike),
          ],
        ),
      ),
    );

Widget wList() => new StoreConnector<TodoAppState, Function>(
    converter: State.dispatchConverter,
    builder: (context, dispatchFn) {
      return new StoreConnector<TodoAppState, Todos>(
        converter: (store) => store.state.todos,
        builder: (context, todos) {
          return ListView(
            scrollDirection: Axis.vertical,
            children: todos.list().map((item) => wDraggableListItem(item, dispatchFn)).toList(),
          );
        },
      );
    });
