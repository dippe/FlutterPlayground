import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:todo_flutter_app/state/domain.dart';

const _ICONS = {
  AppMessageType.ERROR: Icon(Icons.error, color: Colors.red),
  AppMessageType.WARNING: Icon(Icons.warning, color: Colors.orange),
  AppMessageType.INFO: Icon(Icons.info),
};

Widget wMessages() => StoreConnector<AppState, AppMessages>(
      distinct: true,
      converter: (store) => store.state.view.messages,
      builder: (context, AppMessages messages) {
        if (messages.visible && messages.messages.isNotEmpty) {
          final type = messages.messages.last.type;

          final row = Row(
            children: [
              _ICONS[type],
              Expanded(
                child: Text(messages.messages.last?.text),
              ),
            ],
          );

          new Future<Null>.delayed(Duration.zero, () {
            Scaffold.of(context).showSnackBar(
              new SnackBar(
                content: row,
                duration: Duration(seconds: 3),
              ),
            );
          });

          return Text('');
        } else {
          return Text('');
        }
      },
    );
