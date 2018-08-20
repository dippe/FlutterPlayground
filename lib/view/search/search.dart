import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:todo_flutter_app/jira/domain/misc.dart';
import 'package:todo_flutter_app/state/domain.dart';
import 'package:todo_flutter_app/state/state.dart';
import 'package:todo_flutter_app/view/common/common_text_field.dart';
import 'package:todo_flutter_app/view/issue_list/issue_list.dart';
import 'package:todo_flutter_app/view/search/action.dart';

wSearchPage() => new StoreConnector<AppState, SearchState>(
    converter: (store) => store.state.view.search,
    builder: (context, vm) => Column(
          children: <Widget>[
            CommonTextField(
              initValue: vm.text,
              inputType: FieldInputType.TEXT,
              icon: Icons.search,
              labelText: 'Search',
              onChange: (txt) => dispatch(DoSearchAction(txt)),
            ),
            _renderResult(vm.resultItems),
          ],
        ));

class _ViewModel {
  IssueListView actListView;
  Map<JiraFilter, String> items;

  _ViewModel({this.actListView, this.items});
}

Widget _renderResult(items) => (items == null)
    ? Text('--')
    : wIssueList(items, true, store.state.config.listViewMode == ListViewMode.COMPACT) as Widget;
