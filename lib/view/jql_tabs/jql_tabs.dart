import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:todo_flutter_app/jira/jira_ajax.dart';
import 'package:todo_flutter_app/state/domain.dart';
import 'package:todo_flutter_app/state/state.dart';
import 'package:todo_flutter_app/view/action.dart' as ViewActions;
import 'package:todo_flutter_app/view/issue_list/action.dart' as Actions;
import 'package:todo_flutter_app/view/issue_list/issue_list.dart';

class wJqlTabsPage extends StatefulWidget {
  const wJqlTabsPage({Key key}) : super(key: key);
  @override
  _wJqlTabsPageState createState() => new _wJqlTabsPageState();
}

class _wJqlTabsPageState extends State<wJqlTabsPage> with SingleTickerProviderStateMixin {
  List<Widget> _myTabs;
  List<Widget> _children;
  List<IssueListView> _recent;
  Store<AppState> _appStore;
  int _currIdx = 0;

  TabController _tabController;

  _wJqlTabsPageState() {
    this._appStore = store;
  }

  @override
  void initState() {
    _recent = _appStore.state.view.issueListViews;

    _appStore.onChange.listen((appState) {
      if (appState.view.issueListViews != _recent) {
        setState(() {
          _recent = appState.view.issueListViews;
          // ?? this line seem inappropriate here
          _children = _renderChildren(_appStore);
        });
      }
    });

    this._myTabs = _tabsFromStore(_appStore.state);
    this._children = _renderChildren(_appStore);

    super.initState();
    _tabController = new TabController(vsync: this, length: _myTabs.length);
    _tabController.addListener(() {
      setState(() => _currIdx = this._tabController.index);
    });
  }

  @override
  void dispose() {
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
      body: new TabBarView(controller: _tabController, children: _children
//        myTabs.map((Tab tab) {
//          return new Center(child: new Text(tab.text));
//        }).toList(),
          ),
    );
  }
}

List<Widget> _tabsFromStore(AppState appState) => appState.view.issueListViews.map((i) {
      return Tab(
        icon: GestureDetector(
          onLongPress: () => dispatch(ViewActions.ShowJqlEditPage()),
          child: Icon(Icons.directions_car),
        ),
        text: i.name,
      );
    }).toList();

List<Widget> _renderChildren(Store<AppState> store) => store.state.view.issueListViews.map((i) {
      print(i.name);
      if (i.items != null) {
        return wIssueList(i.items) as Widget;
      } else {
        return Text('Loading ...') as Widget;
      }
    }).toList() as List<Widget>;
