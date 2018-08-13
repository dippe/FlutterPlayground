import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:todo_flutter_app/state/domain.dart';
import 'package:todo_flutter_app/state/state.dart';
import 'package:todo_flutter_app/view/issue_list/issue_list.dart';
import 'package:todo_flutter_app/view/issue_list/action.dart' as Actions;

class wJqlTabsPage extends StatefulWidget {
  const wJqlTabsPage({Key key}) : super(key: key);
  @override
  _wJqlTabsPageState createState() => new _wJqlTabsPageState();
}

class _wJqlTabsPageState extends State<wJqlTabsPage> with SingleTickerProviderStateMixin {
  List<Tab> myTabs;

  TabController _tabController;

  @override
  void initState() {
    this.myTabs = _tabsFromStore(store.state);
    super.initState();
    _tabController = new TabController(vsync: this, length: myTabs.length);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var currIdx = this._tabController.index;
    dispatch(Actions.SetActListIdx(currIdx));

    var children = store.state.view.issueListViews.map((i) {
      print(i.name);
      return wIssueList(i.items);
    }).toList();

    return new Scaffold(
      appBar: new AppBar(
        bottom: new TabBar(
          controller: _tabController,
          tabs: myTabs,
        ),
      ),
      body: new TabBarView(controller: _tabController, children: children
//        myTabs.map((Tab tab) {
//          return new Center(child: new Text(tab.text));
//        }).toList(),
          ),
    );
  }
}

List<Tab> _tabsFromStore(AppState appState) => appState.view.issueListViews.map((i) {
      return Tab(
        icon: Icon(Icons.directions_car),
        text: i.name,
      );
    }).toList();
