import 'package:flutter/material.dart';

CommonDropDownField<E>({
  @required String name,
  @required Map<E, String> items,
  @required Function(E) onSelect,
  E selected = null,
  IconData icon = Icons.arrow_drop_down_circle,
}) =>
    new InputDecorator(
      decoration: InputDecoration(
        icon: Icon(icon),
        labelText: name,
      ),
      isEmpty: selected == null,
      child: new DropdownButtonHideUnderline(
        child: new DropdownButton<E>(
          value: selected,
          isDense: true,
          onChanged: (E newValue) => onSelect(newValue),
          items: items.keys.map((key) {
            return new DropdownMenuItem<E>(
              value: key,
              child: new Text(items[key]),
            );
          }).toList() as List<DropdownMenuItem>,
        ),
      ),
    );
