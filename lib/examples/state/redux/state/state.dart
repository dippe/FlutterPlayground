import 'package:flutter/material.dart';
import 'package:flutter_immutable_state/flutter_immutable_state.dart';
import 'package:immutable_state/immutable_state.dart';
import 'package:todo_flutter_app/examples/state/redux/state/domain.dart';

final INIT_STATE = TodoAppState(
  todos: Todos(
    items: List.unmodifiable([new TodoData(0, 'Hello world :P', false)]),
    idCounter: 1,
  ),
  listView: TodoListView(),
);
