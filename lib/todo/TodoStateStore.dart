import 'package:flutter/widgets.dart';
import 'package:todo_flutter_app/todo/Domain.dart';
import 'package:todo_flutter_app/todo/Todo.dart';

abstract class TodoStateStore extends State<TodoApp> {
  final Map<int, TodoData> _todos = {1: new TodoData(1, 'Hello world :P', false)};
  int _idCounter = 0;
  int _selectedTitleForEdit = null;
  int _selectedItem = null;

  add(String title) {
    setState(() {
      _todos.putIfAbsent(_idCounter, () => new TodoData(_idCounter, title, false));
      _idCounter++;
      _unSelectTitleForEdit();
      _unSelectItem();
    });
  }

  update(TodoData todo) {
    setState(() {
      _todos.update(todo.id, (tmp) => tmp.withDone(todo.done).withTitle(todo.title));
    });
  }

  delete(TodoData todo) {
    setState(() {
      _todos.remove(todo.id);
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

  TodoData getById(int id) {
    return _todos[id];
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

  selectItemTitleForEdit(TodoData d) {
    setState(() {
      _unSelectItem();
      _selectedTitleForEdit = d.id;
    });
  }

  _unSelectTitleForEdit() {
    setState(() {
      _selectedTitleForEdit = null;
    });
  }

  selectItem(TodoData d) {
    setState(() {
      _selectedTitleForEdit = null;
      _selectedItem = d.id;
    });
  }

  _unSelectItem() {
    setState(() {
      _selectedItem = null;
    });
  }

  isSelectedForEdit(TodoData d) {
    return d.id == _selectedTitleForEdit;
  }

  isSelected(TodoData d) {
    return d.id == _selectedItem;
  }
}
