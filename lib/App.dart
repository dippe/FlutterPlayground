import 'package:flutter/material.dart';
import 'package:redux/redux.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:todo_flutter_app/state/domain.dart';
import 'package:todo_flutter_app/view/AppDrawer.dart';
import 'package:todo_flutter_app/view/Header.dart';
import 'package:todo_flutter_app/view/list/List.dart';
import 'package:todo_flutter_app/view/config/Login.dart';

class FlutterReduxApp extends StatelessWidget {
  final Store<TodoAppState> store;

  FlutterReduxApp({Key key, this.store}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // The StoreProvider should wrap your MaterialApp or WidgetsApp. This will
    // ensure all routes have access to the store.
    return StoreProvider<TodoAppState>(
      // Pass the store to the StoreProvider. Any ancestor `StoreConnector`
      // Widgets will find and use this value as the `Store`.
      store: store,
      child: MaterialApp(
        home: _wMainRoot(context),
        title: 'Test title',
        theme: ThemeData.dark(),
      ),
    );
  }
}

/* ************************************
 *
 * Renderer functions
 *
 * ************************************/

Widget _wMainRoot(context) => Scaffold(
      appBar: wHeaderAppBar(),
      body: _wBody(),
      drawer: wDrawer(context),
    );

Widget _wBody() => StoreConnector<TodoAppState, dynamic>(
    converter: (store) => {
          'showLogin': store.state.todoView.showLogin,
          'error': store.state.error,
        },
    builder: (context2, s) {
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
      } else if (s['showLogin']) {
        return wLoginFormPage();
      } else {
        return wListPage();
      }
    });

//void _debug(BuildContext context, String msg) {
//  print('**** ' + msg);
////  Scaffold.of(context).showSnackBar(SnackBar(content: Text(msg)));
//}
