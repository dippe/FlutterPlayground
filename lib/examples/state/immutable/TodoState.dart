import 'package:flutter_immutable_state/flutter_immutable_state.dart';
import 'package:immutable_state/immutable_state.dart';

enum ConfigMenuItems { About, Config, DisplayFinished }

class TodoData {
  final int id;
  final String title;
  final bool done;

  const TodoData(this.id, this.title, this.done);

  @override
  bool operator ==(other) =>
      other is TodoData && id == (other.id) && title == other.title && done == other.done;

  TodoData withId(int id) {
    return TodoData(id, title, done);
  }
}

class Todos {
  final Map<int, TodoData> items;
  final int idCounter;

  Todos({this.items, this.idCounter});

  Todos withNewItem(TodoData d) {
    Map<int, TodoData> copy = Map.from(items);
    var nextId = idCounter + 1;
    copy.putIfAbsent(nextId, () => d.withId(nextId));
    return new Todos(items: copy, idCounter: nextId);
  }

  @override
  bool operator ==(other) =>
      other is Todos &&
      other.items != null &&
      _itemsEqual(items, other.items) &&
      idCounter == other.idCounter;

  bool _itemsEqual(Map items, Map otherItems) {
    bool isEq = true;
    items.forEach((key, i) {
      if (otherItems[key] != items[key]) {
        isEq = false;
      }
    });
    return otherItems is Map<int, TodoData> && isEq;
  }
}

class TodoListView {
  final int selectedTitleForEdit;
  final int selectedItem;

  TodoListView({this.selectedTitleForEdit, this.selectedItem});

  @override
  bool operator ==(other) =>
      other is TodoListView &&
      selectedItem == other.selectedItem &&
      selectedTitleForEdit == other.selectedTitleForEdit;
}

class TodoState {
  final Todos todos;
  final TodoListView listView;

  TodoState({this.listView, this.todos});

  TodoState withTodos(newElem) => new TodoState(listView: listView, todos: newElem);
  TodoState withListView(newElem) => new TodoState(listView: newElem, todos: todos);

  @override
  bool operator ==(other) =>
      other is TodoState && todos == other.todos && listView == other.listView;
}

var appState = new Immutable<TodoState>(new TodoState(
  todos: new Todos(
    items: new Map.unmodifiable({0: new TodoData(0, 'Hello world :P', false)}),
    idCounter: 1,
  ),
  listView: new TodoListView(
    selectedItem: 2,
    selectedTitleForEdit: 3,
  ),
));

var todosState = appState.property(
  (c) => c.todos,
  change: (state, newTodos) => state.withTodos(newTodos),
);

var listViewState = appState.property(
  (c) => c.listView,
  change: (state, newElem) => state.withTodos(newElem),
);
