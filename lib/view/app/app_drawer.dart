import 'package:flutter/material.dart';
import 'package:todo_flutter_app/state/state.dart';
import 'package:todo_flutter_app/view/action.dart';

final _globalKey = GlobalKey(debugLabel: 'MenuDrawer');

Widget wDrawer(context) => Drawer(
      key: _globalKey,
      // Add a ListView to the drawer. This ensures the user can scroll
      // through the options in the Drawer if there isn't enough vertical
      // space to fit everything.
      child: ListView(
        // Important: Remove any padding from the ListView.
        padding: EdgeInsets.zero,
        children: <Widget>[
          DrawerHeader(
            child: Text('Menu'),
            decoration: BoxDecoration(
              color: Colors.blue,
            ),
          ),
          ListTile(
            leading: Icon(Icons.list),
            title: Text('Issue Lists'),
            onTap: () {
              dispatch(ShowActualIssueListPage());
              // Update the state of the app
              // ...
              // Then close the drawer
              Navigator.pop(_globalKey.currentContext);
            },
          ),
          ListTile(
            leading: Icon(Icons.search),
            title: Text('Search'),
            onTap: () {
              dispatch(ShowSearchPage());
              // Update the state of the app
              // ...
              // Then close the drawer
              Navigator.pop(_globalKey.currentContext);
            },
          ),
          ListTile(
            leading: Icon(Icons.settings_applications),
            title: Text('Configure'),
            onTap: () {
              dispatch(ShowConfigPage());
              // Update the state of the app
              // ...
              // Then close the drawer
              Navigator.pop(_globalKey.currentContext);
            },
          ),
        ],
      ),
    );
