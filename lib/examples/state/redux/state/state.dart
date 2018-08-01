import 'package:redux/redux.dart';
import 'package:todo_flutter_app/examples/state/redux/state/domain.dart';
import 'package:todo_flutter_app/examples/state/redux/reducer.dart';
import 'package:todo_flutter_app/examples/state/redux/action.dart';

final _initState = TodoAppState(
  todos: Todos(
    items: List.unmodifiable([new TodoData(0, 'Hello world :P', false)]),
    idCounter: 1,
  ),
  listView: TodoListView(),
);

final store = new Store<TodoAppState>(todoReducer, initialState: _initState);

final dispatchConverter = (store) => (action) => () => store.dispatch(action);
