import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:todo_flutter_app/jira/jira_ajax_action.dart';
import 'package:todo_flutter_app/state/domain.dart';
import 'package:todo_flutter_app/state/state.dart';
import 'package:todo_flutter_app/view/common/common_text_field.dart';
import 'package:todo_flutter_app/view/issue_list/issue_list.dart';
import 'package:todo_flutter_app/view/search/action.dart';

wSearchPage() => new StoreConnector<AppState, SearchState>(
    converter: (store) => store.state.view.search,
    builder: (context, vm) => Flex(
          direction: Axis.vertical,
          children: <Widget>[
            CommonTextField(
              initValue: vm.text ?? '',
              inputType: FieldInputType.TEXT,
              icon: Icons.search,
              labelText: 'Search',
              onChange: (txt) => JiraAjax.doSearchAction(txt),
            ),
            _renderResult(vm.text?.isEmpty ?? true, vm.resultItems),
          ],
        ));

Widget _renderResult(bool txtIsEmpty, List items) {
  if (items?.length == 0) {
    return Flex(
      direction: Axis.vertical,
      children: [Text('-- No result --')],
    );
  } else if (txtIsEmpty) {
    return Text('');
  } else if (items == null) {
    return Column(children: [
      Text('Loading ...'),
      new SizedBox(
        width: 40.0,
        height: 40.0,
        child: new CircularProgressIndicator(),
      ),
    ]);
  } else {
    return Expanded(child: wIssueList(items ?? [], store.state.config.listViewMode == ListViewMode.COMPACT));
  }
}
