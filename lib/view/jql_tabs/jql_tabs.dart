import 'dart:async';

import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:todo_flutter_app/jira/jira_ajax_action.dart';
import 'package:todo_flutter_app/state/domain.dart';
import 'package:todo_flutter_app/state/state.dart';
import 'package:todo_flutter_app/view/action.dart' as ViewActions;
import 'package:todo_flutter_app/view/issue_list/action.dart' as Actions;
import 'package:todo_flutter_app/view/issue_list/action.dart';
import 'package:todo_flutter_app/view/issue_list/issue_list.dart';

class JqlTabsPage extends StatefulWidget {
  const JqlTabsPage({Key key}) : super(key: key);
  @override
  _wJqlTabsPageState createState() => new _wJqlTabsPageState();
}

class _wJqlTabsPageState extends State<JqlTabsPage> with SingleTickerProviderStateMixin {
  List<Widget> _myTabs;
  List<Widget> _children;
  List<IssueListView> _recent;
  Store<AppState> _appStore;
  int _currIdx = 0;

  TabController _tabController;

  StreamSubscription<AppState> _subscription;

  ListViewMode _recentListViewMode;

  _wJqlTabsPageState() {
    this._appStore = store;
  }

  @override
  void initState() {
    // fixme: rethink, maybe index mustbe started from 0 ??
    _currIdx = _appStore.state.view.actListIdx ?? 0;

    _recent = _appStore.state.view.issueListViews;

    _subscription = _appStore.onChange.listen((appState) {
      if (appState.view.issueListViews != _recent) {
        setState(() {
          _recent = appState.view.issueListViews;
          // ?? this line seem inappropriate here
          _children = _renderChildren(_appStore);
        });
      } else if (appState.config.listViewMode != _recentListViewMode) {
        setState(() {
          _recentListViewMode = appState.config.listViewMode;
          // ?? this line seem inappropriate here
          _children = _renderChildren(_appStore);
        });
      }
    });

    this._myTabs = _tabsFromStore(_appStore.state);
    this._children = _renderChildren(_appStore);

    _tabController = new TabController(vsync: this, length: _myTabs.length, initialIndex: _currIdx);
    _tabController.addListener(() {
      setState(() => _currIdx = this._tabController.index);
    });

    super.initState();
  }

  @override
  void dispose() {
    _subscription.cancel();
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // fixme: this logic should be refactored out somehow
    if (_appStore.state.view.actListIdx != _currIdx) {
      dispatch(Actions.SetActListIdx(_currIdx));

      // lazy loading like solution:
      if (_appStore.state.view.issueListViews[_currIdx].lastFetched == null) {
        var currFilter = _appStore.state.view.issueListViews[_currIdx].filter;
        JiraAjax.doFetchJqlAction(currFilter);
      }

      this._children = _renderChildren(_appStore);
    }

    return new Scaffold(
      appBar: new TabBar(
        controller: _tabController,
        tabs: _myTabs,
      ),
      body: new TabBarView(
        controller: _tabController,
        children: _children,
      ),
    );
  }
}

List<Widget> _tabsFromStore(AppState appState) => appState.view.issueListViews.map((i) {
      return Tab(
        child: GestureDetector(
          onLongPress: () {
            dispatch(SetActListIdx(appState.view.issueListViews.indexOf(i)));
            JiraAjax.doFetchFilters();
            dispatch(ViewActions.ShowJqlEditPage());
          },
          child: Card(
            margin: EdgeInsets.all(0.0),
            child: Text(
              i.name,
              overflow: TextOverflow.ellipsis,
              maxLines: 2,
              textAlign: TextAlign.center,
            ),
          ),
        ),
      );
    }).toList();

//ignore: unnecessary_cast
List<Widget> _renderChildren(Store<AppState> store) => store.state.view.issueListViews.map((i) {
      if (i.error != null) {
        return Column(
            children: i.error.errorMessages
                .map((err) => ListTile(leading: Icon(Icons.error, color: Colors.red), title: Text(err)))
                .toList() as List<Widget>);
      } else if (i.items != null) {
        return wIssueList(i.items, i.showProgressIndicator(), store.state.config.listViewMode == ListViewMode.COMPACT);
      } else {
        return Column(children: [
          Text('Loading ...'),
          new SizedBox(
            width: 40.0,
            height: 40.0,
            child: new CircularProgressIndicator(),
          ),
        ]);
      }
    }).toList() as List<Widget>;
