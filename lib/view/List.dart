import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:todo_flutter_app/state/domain.dart';
import 'package:todo_flutter_app/state/state.dart' as State;
import 'package:todo_flutter_app/view/ListItem.dart';

Widget TodoListItems() => new StoreConnector<TodoAppState, Function>(
    converter: State.dispatchConverter,
    builder: (context, dispatch) {
      return new StoreConnector<TodoAppState, Todos>(
        converter: (store) => store.state.todos,
        builder: (context, todos) {
          return ListView(
            scrollDirection: Axis.vertical,
            children: todos.list().map((todo) => ListItem(todo, dispatch)).toList(),
          );
        },
      );
    });
