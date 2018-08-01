import 'package:immutable_state/immutable_state.dart';

enum ConfigMenuItems { About, Config, DisplayFinished }

// fixme: implement hashcodes!!
class TodoData {
  final int id;
  final String title;
  final bool done;
  final bool isEdit;
  final bool isSelected;

  const TodoData(this.id, this.title, this.done, {this.isEdit = false, this.isSelected = false});

  @override
  bool operator ==(other) => other is TodoData && id == (other.id) && title == other.title && done == other.done;

  @override
  int get hashCode => id.hashCode ^ title.hashCode ^ done.hashCode;

  TodoData withEdit(bool edit) {
    return new TodoData(id, title, done, isEdit: edit, isSelected: edit);
  }

  TodoData withSelected(bool val) {
    return new TodoData(id, title, done, isEdit: isEdit, isSelected: val);
  }

  TodoData withToggled() {
    return TodoData(id, title, !done, isEdit: isEdit, isSelected: isSelected);
  }

  TodoData withTitle(String newTitle) {
    return TodoData(id, newTitle, done, isEdit: false, isSelected: isSelected);
  }
}

class Todos {
  final List<TodoData> items;
  final int idCounter;

  Todos({this.items, this.idCounter = 0});

  Todos withNewItem(String title) {
    final List<TodoData> copy = List.from(items);
    var nextId = idCounter + 1;
    copy.add(TodoData(nextId, title, false));
    return new Todos(items: copy, idCounter: nextId);
  }

  TodoData getById(int id) {
    return items.firstWhere((i) => i.id == id);
  }

  Todos withUpdated(TodoData todo) {
    final List<TodoData> copy = List.from(items);
    final index = copy.indexOf(getById(todo.id));
    copy[index] = todo;
    return Todos(
      items: copy,
      idCounter: idCounter,
    );
  }

  Todos withDeleted(todo) {
    final List<TodoData> copy = List.from(items);
    copy.remove(getById(todo.id));
    return Todos(
      items: copy,
      idCounter: idCounter,
    );
  }

  Todos withAllUnselected() {
    List<TodoData> tmp = items.map((value) => value.withSelected(false).withEdit(false)).toList();
    return Todos(
      items: tmp,
      idCounter: idCounter,
    );
  }

  Todos withMoved(TodoData what, TodoData target) {
    final List<TodoData> copy = List.from(items);

    copy.remove(what);
    final newIndex = copy.indexOf(target);
    copy.insert(newIndex, what);

    return Todos(
      items: copy,
      idCounter: idCounter,
    );
  }

  int length() {
    return items.length;
  }

  int lengthDone() {
    return items.where((d) => d.done).length;
  }

  int lengthTodo() {
    return items.where((d) => !d.done).length;
  }

  List<TodoData> list() {
    return items;
  }

  @override
  bool operator ==(other) =>
      identical(this, other) ||
      other is Todos && other.items != null && _itemsEqual(items, other.items) && idCounter == other.idCounter;

  @override
  int get hashCode => items.hashCode ^ idCounter.hashCode;

  bool _itemsEqual(List<TodoData> items, List<TodoData> otherItems) {
    bool isEq = true;
    if (!(otherItems is List<TodoData>)) {
      return false;
    } else {
      return items.every((i) => otherItems.any((o) => o == i));
    }
  }
}

class TodoListView {}

class TodoAppState {
  final Todos todos;
  final TodoListView listView;

  TodoAppState({this.listView, this.todos});

  TodoAppState withTodos(Todos newElem) => new TodoAppState(listView: listView, todos: newElem);

  TodoAppState withListView(newElem) => new TodoAppState(listView: newElem, todos: todos);

  @override
  bool operator ==(other) =>
      identical(this, other) || other is TodoAppState && todos == other.todos && listView == other.listView;

  @override
  int get hashCode => todos.hashCode ^ listView.hashCode;
}
