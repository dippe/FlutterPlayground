import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:todo_flutter_app/state/domain.dart';
import 'package:todo_flutter_app/view/app/app_drawer.dart';
import 'package:todo_flutter_app/view/app/header.dart';
import 'package:todo_flutter_app/view/config/config_page.dart';
import 'package:todo_flutter_app/view/jql_tab_edit/jql_edit_form.dart';
import 'package:todo_flutter_app/view/jql_tabs/jql_tabs.dart';
import 'package:todo_flutter_app/view/messages/messages.dart';
import 'package:todo_flutter_app/view/search/search.dart';

final mainGlobalScaffold = GlobalKey(debugLabel: 'MainGlobalScaffold');

class FlutterReduxApp extends StatelessWidget {
//  Persistor<AppState> persistor;
  final Store<AppState> store;

  FlutterReduxApp({this.store});

  @override
  Widget build(BuildContext context) {
//    return PersistorGate(
//      persistor: persistor,
//      builder: (context) =>
    return StoreProvider<AppState>(
      // Pass the store to the StoreProvider. Any ancestor `StoreConnector`
      // Widgets will find and use this value as the `Store`.
      store: store,
      child: MaterialApp(
        home: _wMainRoot(context),
        title: 'Test title',
        theme: ThemeData.dark(),
      ),
//          ),
    );
  }
}

/* ************************************
 *
 * Renderer functions
 *
 * ************************************/

Widget _wMainRoot(context) => Scaffold(
      key: mainGlobalScaffold,
      appBar: wHeaderAppBar(),
      body: _wBody(),
      drawer: wDrawer(context),
      bottomSheet: wMessages(),
    );

Widget _wBody() => StoreConnector<AppState, dynamic>(
    converter: (store) => {
          // fixme: rethink page handling
          'showJqlEdit': store.state.view.actPage == PageType.JqlEdit,
          'showConfig': store.state.view.actPage == PageType.Config,
          'showSearch': store.state.view.actPage == PageType.Search,
          // fixme: rethink error handling
          'error': store.state.jira.error,
        },
    builder: (context2, s) {
      // fixme: replace paging with https://flutter.io/cookbook/navigation/navigation-basics/
      if (s['error'] != null) {
        return SimpleDialog(
          title: Text('Ajax Error'),
          children: <Widget>[
            Text(
              'ERROR: ' + s['error'],
              style: TextStyle(color: Colors.redAccent),
            )
          ],
        );
      } else if (s['showJqlEdit']) {
        return wJqlEditPage();
      } else if (s['showConfig']) {
        return wConfigPage();
      } else if (s['showSearch']) {
        return wSearchPage();
      } else {
        return JqlTabsPage();
      }
    });

//void _debug(BuildContext context, String msg) {
//  print('**** ' + msg);
////  Scaffold.of(context).showSnackBar(SnackBar(content: Text(msg)));
//}
