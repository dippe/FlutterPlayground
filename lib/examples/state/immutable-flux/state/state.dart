import 'package:flutter/material.dart';
import 'package:flutter_immutable_state/flutter_immutable_state.dart';
import 'package:immutable_state/immutable_state.dart';
import 'package:todo_flutter_app/examples/state/immutable/state/domain.dart';

final INIT_STATE = TodoAppState(
  todos: Todos(
    items: List.unmodifiable([new TodoData(0, 'Hello world :P', false)]),
    idCounter: 1,
  ),
  listView: TodoListView(),
);

final immutableAppState = new Immutable<TodoAppState>(INIT_STATE);

// used only in the Unit Tests
class State {
  static final todosList = immutableAppState.property(
    (c) => c.todos,
    change: (state, newTodos) => state.withTodos(newTodos),
  );

  static final listView = immutableAppState.property(
    (c) => c.listView,
    change: (state, newElem) => state.withListView(newElem),
  );
}

class ViewState {
  static Widget todos(Widget child) => ImmutablePropertyManager<TodoAppState, Todos>(
        current: (state) => state.todos,
        child: child,
        change: (state, newElem) => state.withTodos(newElem),
      );

  static Widget todo(Widget child, int todoId) => ImmutablePropertyManager<TodoAppState, TodoData>(
        current: (state) => state.todos.getById(todoId),
        child: child,
        change: (state, newTodo) => state.withTodos(state.todos.withUpdated(newTodo)),
      );
}
