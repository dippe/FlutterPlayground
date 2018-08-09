import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:todo_flutter_app/state/domain.dart';
import 'package:todo_flutter_app/state/state.dart' as State;
import 'package:todo_flutter_app/action.dart' as Actions;
import 'package:todo_flutter_app/view/BasicChart.dart';

const DEFAULT_ITEM_NAME = 'Unnamed';

Widget HeaderAppBar() => AppBar(
      actions: <Widget>[
        // fixme: generalize connectors
        new StoreConnector<TodoAppState, Todos>(
            converter: (store) => store.state.todos,
            builder: (context, todos) {
              return SimpleBarChart.renderProgressChart(todos.lengthDone(), todos.lengthTodo());
            }),
        _MainBtns(),
      ],
    );

Widget _MainBtns() => Row(
      children: [_AddButton(), _TopMenu],
    );

Widget _TopMenu = StoreConnector<TodoAppState, Function>(
    converter: State.dispatchConverter,
    builder: (context, dispatchFn) {
      PopupMenuItemBuilder builder = (BuildContext context) => <PopupMenuEntry<ConfigMenuItems>>[
            PopupMenuItem(value: ConfigMenuItems.About, child: const Text('About')),
            PopupMenuItem(value: ConfigMenuItems.Config, child: const Text('Config')),
            PopupMenuItem(value: ConfigMenuItems.Login, child: const Text('Login')),
          ];
      return PopupMenuButton(
        onSelected: (i) {
          if (i == ConfigMenuItems.Login) {
            dispatchFn(Actions.ShowLoginDialog(true))();
          }
        },
        itemBuilder: builder,
      );
    });

Widget _AddButton() => new StoreConnector<TodoAppState, Function>(
      converter: State.dispatchConverter,
      builder: (context, dispatch) {
        return IconButton(
          tooltip: 'New Todo',
          icon: Icon(Icons.add),
          onPressed: dispatch(Actions.Add(DEFAULT_ITEM_NAME)),
        );
      },
    );
