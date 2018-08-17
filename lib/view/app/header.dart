import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:todo_flutter_app/jira/domain/issue.dart';
import 'package:todo_flutter_app/jira/jira_ajax_action.dart';
import 'package:todo_flutter_app/state/domain.dart';
import 'package:todo_flutter_app/view/issue_list/action.dart' as Actions;
import 'package:todo_flutter_app/state/state.dart';
import 'package:todo_flutter_app/view/action.dart' as Actions;

const DEFAULT_ITEM_KEY = 'UNLINKED-1234';
const DEFAULT_ITEM_NAME = 'Unnamed issue';

Widget wHeaderAppBar() => AppBar(
      actions: <Widget>[
        // fixme: generalize connectors
        new StoreConnector<AppState, AppState>(
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
  PopupMenuItemBuilder builder = (BuildContext context) => <PopupMenuEntry<PageType>>[
        PopupMenuItem(value: PageType.IssueList, child: const Text('List view')),
        PopupMenuItem(value: PageType.Config, child: const Text('Config')),
      ];
  return PopupMenuButton(
    onSelected: (i) {
      if (i == PageType.Config) {
        dispatch(Actions.ShowConfigPage());
      } else {
        dispatch(Actions.ShowActualIssueListPage());
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

Widget _wRefreshButton = new StoreConnector<AppState, ViewState>(
  converter: (store) => store.state.view,
  builder: (context, view) {
    return IconButton(
      tooltip: 'Refresh',
      icon: Icon(Icons.refresh),
      // fixme: re-think this overcomplicated line >> probably a new action is required e.g. fetchCurrentPage...
      onPressed: () => JiraAjax.doFetchJqlAction(view.issueListViews[view.actListIdx].filter),
    );
  },
);
