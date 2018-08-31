import 'package:redux/redux.dart';
import 'package:todo_flutter_app/state/domain.dart';
import 'package:todo_flutter_app/state/state.dart';
import 'package:todo_flutter_app/util/tripledes/lib/tripledes.dart';
import 'package:todo_flutter_app/view/config/action.dart';
import 'package:todo_flutter_app/view/issue_list/action.dart' as Actions;
import 'package:todo_flutter_app/view/config/action.dart' as Actions;
import 'package:todo_flutter_app/view/messages/action.dart';

Reducer<ConfigState> configReducer = (ConfigState state, dynamic action) {
  if (action is Actions.SetUserName) {
    return state.copyWith(user: action.name);
  } else if (action is ToggleDisplayModeAction) {
    final newMode = state.listViewMode == ListViewMode.COMPACT ? ListViewMode.NORMAL : ListViewMode.COMPACT;
    return state.copyWith(listViewMode: newMode);
  } else if (action is Actions.SetBaseUrl) {
    return state.copyWith(baseUrl: action.url);
  } else if (action is Actions.SetPwd) {
    return state.copyWith(password: action.pwd.length > 0 ? getEncryptedPwd(state, action.pwd) : '');
  } else if (action is Actions.SetMaxIssueKeyLength) {
    return state.copyWith(maxIssueKeyLength: int.parse(action.num));
  } else if (action is Actions.SetMaxJqlIssueNum) {
    return state.copyWith(maxJqlIssueNum: int.parse(action.num));
  } else if (action is Actions.SetRecentIssueCommentsNum) {
    return state.copyWith(recentIssueCommentsNum: int.parse(action.num));
  } else {
    return state;
  }
};

getEncryptedPwd(ConfigState state, pwd) {
  try {
    final key = state.baseUrl + state.user;
    var blockCipher = new BlockCipher(new DESEngine(), key);
    final encrypted = blockCipher.encodeB64(pwd);
    return encrypted;
  } catch (e) {
    throw Exception('Password encrypt error: ' + e.toString());
  }
}

getDecryptedPwd(ConfigState state, pwd) {
  if (pwd == '') return '';
  try {
    final key = state.baseUrl + state.user;
    var blockCipher = new BlockCipher(new DESEngine(), key);
    final decrypted = blockCipher.decodeB64(pwd);
    return decrypted;
  } catch (e) {
    store.dispatch(AddWarningMessageAction('Password decrypt error: try to re-enter the pwd!  ' + e.toString()));
    return '';
  }
}
