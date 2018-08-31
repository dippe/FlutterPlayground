import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:todo_flutter_app/jira/domain/issue.dart';
import 'package:todo_flutter_app/jira/jira_ajax_action.dart';
import 'package:todo_flutter_app/state/domain.dart';
import 'package:todo_flutter_app/view/action.dart';
import 'package:todo_flutter_app/view/config/action.dart';
import 'package:todo_flutter_app/view/issue_list/action.dart' as Actions;
import 'package:todo_flutter_app/state/state.dart';
import 'package:todo_flutter_app/view/action.dart' as Actions;

const DEFAULT_ITEM_KEY = 'UNLINKED-1234';
const DEFAULT_ITEM_NAME = 'Unnamed issue';

Widget wHeaderAppBar() => AppBar(
      actions: <Widget>[
        _wMainBtns,
      ],
    );

Widget _wMainBtns = Expanded(
  child: Row(
    mainAxisAlignment: MainAxisAlignment.spaceAround,
    children: [
      SizedBox(
        width: 80.0,
      ),
      _wToggleCompact,
      _wSearchButton,
      _wRefreshButton
    ],
  ),
);

Widget _wToggleCompact = StoreConnector<AppState, bool>(
    converter: (store) => store.state.config.listViewMode == ListViewMode.COMPACT,
    builder: (context, isCompact) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text('Compact'),
          Switch(
            value: isCompact,
            onChanged: (val) => dispatch(ToggleDisplayModeAction()),
          ),
        ],
      );
    });

Widget _wSearchButton = IconButton(
  tooltip: 'Search',
  icon: Icon(Icons.search),
  onPressed: () => dispatch(ShowSearchPage()),
);

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
