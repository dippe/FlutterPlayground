import 'package:flutter/widgets.dart';
import 'package:todo_flutter_app/todo/Domain.dart';
import 'package:todo_flutter_app/todo/Todo.dart';

abstract class TodoStateStore extends State<TodoApp> {
  final Map<int, TodoData> _todos = {1: new TodoData(1, 'Hello world :P', false)};
  int _idCounter = 0;

  add(String title) {
    setState(() {
      _todos.putIfAbsent(_idCounter, () => new TodoData(_idCounter, title, false));
      _idCounter++;
    });
  }

  update(TodoData todo) {
    setState(() {
      _todos.update(todo.id, (tmp) => tmp.withDone(todo.done).withTitle(todo.title));
    });
  }

  List<TodoData> list() {
    return List.from(_todos.values);
  }

  toggleState(TodoData todo) {
    setState(() {
      _todos.update(todo.id, (tmp) => tmp.withDone(!todo.done));
    });
  }

  int length() {
    return _todos.length;
  }

  int lengthDone() {
    return _todos.values.where((d) => d.done).length;
  }

  int lengthTodo() {
    return _todos.values.where((d) => !d.done).length;
  }
}
