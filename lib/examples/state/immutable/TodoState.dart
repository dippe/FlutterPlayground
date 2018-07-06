import 'package:immutable_state/immutable_state.dart';

enum ConfigMenuItems { About, Config, DisplayFinished }

// fixme: implement hashcodes!!
class TodoData {
  final int id;
  final String title;
  final bool done;

  const TodoData(this.id, this.title, this.done);

  @override
  bool operator ==(other) => other is TodoData && id == (other.id) && title == other.title && done == other.done;

  TodoData withId(int id) {
    return TodoData(id, title, done);
  }

  TodoData withToggled() {
    return TodoData(id, title, !done);
  }

  TodoData withTitle(String newTitle) {
    return TodoData(id, newTitle, done);
  }
}

class Todos {
  final Map<int, TodoData> items;
  final int idCounter;

  Todos({this.items, this.idCounter = 0});

  Todos withNewItem(TodoData d) {
    Map<int, TodoData> copy = Map.from(items);
    var nextId = idCounter + 1;
    copy.putIfAbsent(nextId, () => d.withId(nextId));
    return new Todos(items: copy, idCounter: nextId);
  }

  Todos withToggledItem(TodoData d) {
    Map<int, TodoData> copy = Map.from(items);
    copy.update(d.id, (d) => d.withToggled());
    return Todos(items: copy, idCounter: idCounter);
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
}

class TodoListView {
  final int selectedTitleForEdit;
  final int selectedItem;

  TodoListView({this.selectedTitleForEdit, this.selectedItem});

  isSelectedForEdit(int id) {
    return id == selectedTitleForEdit;
  }

  isSelected(TodoData d) {
    return d.id == selectedItem;
  }

  withSelectedForEdit(int id) {
    return new TodoListView(selectedTitleForEdit: id, selectedItem: selectedItem);
  }

  withSelected(int id) {
    return new TodoListView(selectedTitleForEdit: selectedTitleForEdit, selectedItem: id);
  }

  withUnselect() {
    return new TodoListView(selectedTitleForEdit: null, selectedItem: null);
  }

  @override
  bool operator ==(other) =>
      other is TodoListView && selectedItem == other.selectedItem && selectedTitleForEdit == other.selectedTitleForEdit;
}

class TodoState {
  final Todos todos;
  final TodoListView listView;

  TodoState({this.listView, this.todos});

  TodoState withTodos(newElem) => new TodoState(listView: listView, todos: newElem);

  TodoState withListView(newElem) => new TodoState(listView: newElem, todos: todos);

  @override
  bool operator ==(other) => other is TodoState && todos == other.todos && listView == other.listView;
}

var appState = new Immutable<TodoState>(new TodoState(
  todos: new Todos(
    items: new Map.unmodifiable({0: new TodoData(0, 'Hello world :P', false)}),
    idCounter: 1,
  ),
  listView: new TodoListView(
    selectedItem: null,
    selectedTitleForEdit: null,
  ),
));

var todosState = appState.property(
  (c) => c.todos,
  change: (state, newTodos) => state.withTodos(newTodos),
);

var listViewState = appState.property(
  (c) => c.listView,
  change: (state, newElem) => state.withListView(newElem),
);
