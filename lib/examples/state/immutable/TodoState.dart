import 'package:flutter_immutable_state/flutter_immutable_state.dart';
import 'package:immutable_state/immutable_state.dart';

enum ConfigMenuItems { About, Config, DisplayFinished }

class TodoData {
  final int id;
  final String title;
  final bool done;

  const TodoData(this.id, this.title, this.done);

  @override
  bool operator ==(other) => id == (other.id) && title == other.title && done == other.done;
}

class TodoItems {
  final Map<int, TodoData> items;
  final int idCounter;

  TodoItems({this.items, this.idCounter});

// fixme: implement ==
}

class TodoState {
  final int selectedTitleForEdit;
  final int selectedItem;
  final TodoItems todos;

  TodoState({this.selectedTitleForEdit, this.selectedItem, this.todos});

// fixme: implement ==

//  TodoState changeTitleState(TitleState titleState) => new AppState(titleState: titleState);
}

var state = new Immutable<TodoState>(new TodoState(
  todos: new TodoItems(
    items: new Map.unmodifiable({0: new TodoData(0, 'Hello world :P', false)}),
    idCounter: 1,
  ),
  selectedItem: 2,
  selectedTitleForEdit: 3,
));
