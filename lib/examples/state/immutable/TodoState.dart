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

  withEdit(bool edit) {
    return new TodoData(id, title, done, isEdit: edit, isSelected: edit);
  }

  TodoData withSelected(bool val) {
    return new TodoData(id, title, done, isEdit: isEdit, isSelected: val);
  }

  withToggled() {
    return TodoData(id, title, !done, isEdit: isEdit, isSelected: isSelected);
  }

  withTitle(String newTitle) {
    return TodoData(id, newTitle, done, isEdit: false, isSelected: isSelected);
  }
}

class Todos {
  final Map<int, TodoData> items;
  final int idCounter;

  Todos({this.items, this.idCounter = 0});

  Todos withNewItem(String title) {
    Map<int, TodoData> copy = Map.from(items);
    var nextId = idCounter + 1;
    copy.putIfAbsent(nextId, () => TodoData(nextId, title, false));
    return new Todos(items: copy, idCounter: nextId);
  }

  TodoData getById(int id) {
    return items[id];
  }

  Todos withUpdated(TodoData todo) {
    Map<int, TodoData> copy = Map.from(items);
    copy.update(todo.id, (tmp) => todo);
    return Todos(items: copy, idCounter: idCounter);
  }

  Todos withDeleted(d) {
    Map<int, TodoData> copy = Map.from(items);
    copy.remove(d.id);
    return Todos(items: copy, idCounter: idCounter);
  }

  int length() {
    return items.length;
  }

  int lengthDone() {
    return items.values.where((d) => d.done).length;
  }

  int lengthTodo() {
    return items.values.where((d) => !d.done).length;
  }

  List<TodoData> list() {
    return List.from(items.values);
  }

  @override
  bool operator ==(other) =>
      other is Todos && other.items != null && _itemsEqual(items, other.items) && idCounter == other.idCounter;

  bool _itemsEqual(Map items, Map otherItems) {
    bool isEq = true;
    items.forEach((key, i) {
      if (otherItems[key] != items[key]) {
        isEq = false;
      }
    });
    return otherItems is Map<int, TodoData> && isEq;
  }

  Todos withAllUnselected() {
    return Todos(
      items: items.map((key, value) => MapEntry(key, value.withSelected(false).withEdit(false))),
      idCounter: idCounter,
    );
  }
}

class TodoListView {}

class TodoState {
  final Todos todos;
  final TodoListView listView;

  TodoState({this.listView, this.todos});

  TodoState withTodos(Todos newElem) => new TodoState(listView: listView, todos: newElem);

  TodoState withListView(newElem) => new TodoState(listView: newElem, todos: todos);

  @override
  bool operator ==(other) => other is TodoState && todos == other.todos && listView == other.listView;
}

// todo: re-think if these are needed and remove if not:
// immutable object example:
var appState = new Immutable<TodoState>(new TodoState(
  todos: new Todos(
    items: new Map.unmodifiable({0: new TodoData(0, 'Hello world :P', false)}),
    idCounter: 1,
  ),
  listView: new TodoListView(),
));

var todosState = appState.property(
  (c) => c.todos,
  change: (state, newTodos) => state.withTodos(newTodos),
);

var listViewState = appState.property(
  (c) => c.listView,
  change: (state, newElem) => state.withListView(newElem),
);
