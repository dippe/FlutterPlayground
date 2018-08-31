import 'dart:async';

import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:todo_flutter_app/consts.dart';
import 'package:todo_flutter_app/state/domain.dart';
import 'package:todo_flutter_app/view/action.dart';
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
    try {
      return StoreProvider<AppState>(
        // Pass the store to the StoreProvider. Any ancestor `StoreConnector`
        // Widgets will find and use this value as the `Store`.
        store: store,
        child: MaterialApp(
          home: WillPopScope(
            child: Scaffold(
              key: mainGlobalScaffold,
              appBar: wHeaderAppBar(),
              body: _wBody(),
              drawer: wDrawer(context),
              bottomSheet: wMessages(),
            ),
            onWillPop: () {
              store.dispatch(ShowActualIssueListPage());
              return Future.value(false);
            },
          ),
          title: 'Test title',
          theme: ThemeData.dark(),
        ),
//          ),
      );
    } catch (e) {
      print(e.toString());
      rethrow;
    }
  }
}

/* ************************************
 *
 * Renderer functions
 *
 * ************************************/

Widget _wBody() => StoreConnector<AppState, _BodyDto>(
    converter: (store) => _BodyDto(
          actPage: store.state.view.actPage,
          error: store.state.jira.error,
        ),
    builder: (context2, d) {
      if (d.actPage == PageType.AppStart) {
        return new Row(
          children: [SizedBox(height: 100.0, width: 100.0, child: AppConsts.APP_LOGO)],
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
        );
      } else if (d.error != null) {
        return SimpleDialog(
          title: Text('Ajax Error'),
          children: <Widget>[
            Text(
              'ERROR: ' + d.error,
              style: TextStyle(color: Colors.redAccent),
            )
          ],
        );
      } else if (d.actPage == PageType.JqlEdit) {
        return wJqlEditPage();
      } else if (d.actPage == PageType.Config) {
        return wConfigPage();
      } else if (d.actPage == PageType.Search) {
        return wSearchPage();
      } else {
        return JqlTabsPage();
      }
    });

class _BodyDto {
  final PageType actPage;
  final String error;

  _BodyDto({this.actPage, this.error});
}
