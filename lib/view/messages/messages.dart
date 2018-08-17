import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:todo_flutter_app/state/domain.dart';

const _ICONS = {
  AppMessageType.WARNING: Icons.warning,
  AppMessageType.INFO: Icons.info,
};

Widget wMessages() => StoreConnector<AppState, AppMessages>(
      converter: (store) => store.state.view.messages,
      builder: (context, AppMessages messages) {
        if (messages.visible && messages.messages.isNotEmpty) {
          final type = messages.messages.last.type;

          return Row(
            children: [
              Icon(_ICONS[type]),
              Text(messages.messages.last?.text),
            ],
          );
        } else {
          return Text('No message');
        }
      },
    );
