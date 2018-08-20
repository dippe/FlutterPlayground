import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:todo_flutter_app/jira/domain/misc.dart';
import 'package:todo_flutter_app/jira/jira_ajax_action.dart';
import 'package:todo_flutter_app/state/domain.dart';
import 'package:todo_flutter_app/view/action.dart';
import 'package:todo_flutter_app/view/common/common_date_field.dart';
import 'package:todo_flutter_app/view/common/common_drop_down_field.dart';
import 'package:todo_flutter_app/view/common/common_text_field.dart';
import 'package:todo_flutter_app/state/state.dart';
import 'package:todo_flutter_app/view/jql_tab_edit/action.dart';

wJqlEditPage() => new StoreConnector<AppState, _ViewModel>(
      converter: (store) {
        // fixme: this converter function holds the old name value >> form won't be updated on changes (maybe this not a problem (?))
        final List<JiraFilter> tmpFilters = List<JiraFilter>.from(store.state.jira.predefinedFilters)
          ..addAll(store.state.jira.fetchedFilters ?? []);

        final Map<JiraFilter, String> itemMap = Map.fromIterable(tmpFilters, key: (v) => v, value: (v) => v.name);

        return _ViewModel(
          actListView: store.state.view.issueListViews[store.state.view.actListIdx],
          items: itemMap,
        );
      },
      builder: (context, vm) => ListView(
//                  padding: const EdgeInsets.symmetric(horizontal: 16.0),
            children: <Widget>[
              CommonTextField(
                labelText: 'Tab Name',
                initValue: vm.actListView.name,
                onChange: (txt) => dispatch(SetFilterNameAction(txt)),
                inputType: FieldInputType.TEXT,
              ),
              CommonDropDownField(
                name: 'JIRA Filter',
                items: vm.items,
                onSelect: (filter) => dispatch(SelectFilterAction(filter)),
                selected: vm.actListView.filter,
                icon: Icons.filter_none,
                hint: 'Favourite JIRA filters + predefined',
              ),
              Card(
                  margin: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 16.0),
                  child: Column(
                    children: [
                      ListTile(
                        leading: Text('Filter name:'),
                        title: Text(vm.actListView.filter.name ?? 'No name ??'),
                      ),
                      ListTile(
                        leading: Text('JQL:'),
                        title: Text(vm.actListView.filter.jql ?? 'No filter ??'),
                      ),
                    ],
                  )),
              new Container(
                  padding: const EdgeInsets.only(left: 40.0, top: 20.0),
                  child: new RaisedButton(
                    child: const Text('Back to the list'),
                    onPressed: () {
                      dispatch(HideConfigPage());
                      JiraAjax.doFetchJqlAction(vm.actListView.filter);
                    },
                  )),
            ],
          ),
    );

class _ViewModel {
  IssueListView actListView;
  Map<JiraFilter, String> items;

  _ViewModel({this.actListView, this.items});
}
