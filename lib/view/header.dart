import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:todo_flutter_app/jira/domain/issue.dart';
import 'package:todo_flutter_app/jira/jira.dart';
import 'package:todo_flutter_app/state/domain.dart';
import 'package:todo_flutter_app/action.dart' as Actions;
import 'package:todo_flutter_app/view/basic_chart.dart';
import 'package:todo_flutter_app/state/state.dart';

const DEFAULT_ITEM_KEY = 'UNLINKED-1234';
const DEFAULT_ITEM_NAME = 'Unnamed issue';

Widget wHeaderAppBar() => AppBar(
      actions: <Widget>[
        // fixme: generalize connectors
        new StoreConnector<TodoAppState, TodoAppState>(
            converter: (store) => store.state,
            builder: (context, todos) {
              return Text('-');
              // fixme- re-enable
//              return SimpleBarChart.renderProgressChart(todos.lengthDone(), todos.lengthTodo());
            }),
        _wMainBtns,
      ],
    );

Widget _wMainBtns = Row(
  children: [_wAddButton, _wTopMenu(), _wRefreshButton],
);

Widget _wTopMenu() {
  PopupMenuItemBuilder builder = (BuildContext context) => <PopupMenuEntry<ConfigMenuItems>>[
        PopupMenuItem(value: ConfigMenuItems.About, child: const Text('About')),
        PopupMenuItem(value: ConfigMenuItems.Config, child: const Text('Config')),
        PopupMenuItem(value: ConfigMenuItems.Login, child: const Text('Login')),
      ];
  return PopupMenuButton(
    onSelected: (i) {
      if (i == ConfigMenuItems.Login) {
        dispatch(Actions.ShowLoginDialog(true));
      }
    },
    itemBuilder: builder,
  );
}

Widget _wAddButton = IconButton(
  tooltip: 'New Item',
  icon: Icon(Icons.add),
  onPressed: () => dispatch(Actions.Add(JiraIssue.unlinked(DEFAULT_ITEM_KEY, DEFAULT_ITEM_NAME))),
);

Widget _wRefreshButton = new StoreConnector<TodoAppState, ViewData>(
  converter: (store) => store.state.view,
  builder: (context, view) {
    return IconButton(
      tooltip: 'Refresh',
      icon: Icon(Icons.refresh),
      onPressed: () => JiraAjax.doFetchJqlAction(view.issueListViews[0].filter.jql),
    );
  },
);
