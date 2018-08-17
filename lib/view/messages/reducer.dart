import 'package:redux/redux.dart';
import 'package:todo_flutter_app/state/domain.dart';
import 'package:todo_flutter_app/state/state.dart';
import 'package:todo_flutter_app/view/messages/action.dart';

Reducer<ViewState> messagesReducer = combineReducers<ViewState>([
  debugReducer<ViewState>('messagesReducer'),
  TypedReducer<ViewState, ShowMessagesAction>(_show),
  TypedReducer<ViewState, HideMessagesAction>(_hide),
  TypedReducer<ViewState, AddErrorMessageAction>(_addError),
  TypedReducer<ViewState, AddWarningMessageAction>(_addWarning),
  TypedReducer<ViewState, AddInfoMessageAction>(_addInfo),
]);

/* **********************
*
*    Reducer functions
*
* ***********************/

ViewState _show(ViewState state, ShowMessagesAction action) {
  return state.copyWith(messages: state.messages.copyWith(visible: true));
}

ViewState _hide(ViewState state, HideMessagesAction action) {
  return state.copyWith(messages: state.messages.copyWith(visible: false));
}

ViewState _addError(ViewState state, AddErrorMessageAction action) => _add(
    state,
    AppMessage(
      type: AppMessageType.ERROR,
      text: action.text,
    ));

ViewState _addWarning(ViewState state, AddWarningMessageAction action) => _add(
    state,
    AppMessage(
      type: AppMessageType.WARNING,
      text: action.text,
    ));

ViewState _addInfo(ViewState state, AddInfoMessageAction action) => _add(
    state,
    AppMessage(
      type: AppMessageType.INFO,
      text: action.text,
    ));

ViewState _add(ViewState state, AppMessage msg) {
  return state.copyWith(
    messages: state.messages.copyWith(
      visible: true,
      messages: List.of(state.messages.messages..add(msg)).toList(),
    ),
  );
}
