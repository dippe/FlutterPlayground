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
              onChange: (txt) {
                // fixme: re-think actions/middleware
                dispatch(DoSearchAction(txt));
                JiraAjax.doSearchAction(txt);
              },
            ),
            _renderResult(vm.resultItems),
          ],
        ));

Widget _renderResult(List items) => (items?.length == 0)
    ? Flex(
        direction: Axis.vertical,
        children: [Text('-- No result --')],
      )
    : Expanded(child: wIssueList(items ?? [], items == null, store.state.config.listViewMode == ListViewMode.COMPACT));
