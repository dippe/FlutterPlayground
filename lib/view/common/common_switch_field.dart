import 'package:flutter/material.dart';

Widget CommonSwitchField({
  @required String labelText,
  @required bool initValue,
  @required Function onChange,
}) =>
    ListTile(
      title: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          Text(labelText),
          Switch(
            value: initValue,
            onChanged: onChange,
          ),
        ],
      ),
    );
