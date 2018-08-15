import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:todo_flutter_app/state/domain.dart';
import 'package:todo_flutter_app/state/state.dart';
import 'package:todo_flutter_app/view/common/common_text_field.dart';
import 'package:todo_flutter_app/view/config/action.dart' as Actions;
import 'package:todo_flutter_app/view/action.dart' as ViewActions;

Widget wConfigPage() => new StoreConnector<AppState, ConfigState>(
      converter: (state) => state.state.config,
      builder: (context, user) => new Column(
            children: <Widget>[
              Title(
                color: Colors.greenAccent,
                title: 'Login',
                child: Text('JIRA Login'),
              ),
              const Divider(
                height: 1.0,
              ),
              new ListTile(
                leading: const Icon(Icons.person),
                title: _Name(user.user),
              ),
              new ListTile(
                leading: const Icon(Icons.person),
                title: CommonTextField(
                  inputType: FieldInputType.TEXT,
                  initValue: user.user,
                  onChange: (txt) => dispatch(Actions.SetUserName(txt)),
                  labelText: 'Name',
                ),
              ),
              new ListTile(
                leading: const Icon(Icons.account_box),
                title: _Pwd(user.password),
              ),
              new ListTile(
                leading: const Icon(Icons.email),
                title: new TextField(
                  decoration: new InputDecoration(
                    hintText: "Email",
                  ),
                ),
              ),
              new FlatButton(
                child: Text('Ok-Mok'),
                onPressed: () => dispatch(ViewActions.HideConfigPage()),
              ),
            ],
          ),
    );

class _Name extends StatefulWidget {
  final String txt;

  _Name(this.txt);

  @override
  _NameState createState() => _NameState(txt);
}

class _NameState extends State<_Name> {
  TextEditingController _controller;

  _NameState(String initTxt) {
    _controller = new TextEditingController(text: initTxt);
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      decoration: new InputDecoration(labelText: 'Name'),
      onSubmitted: (txt) => dispatch(Actions.SetUserName(txt)),
    );
  }
}

class _Pwd extends StatefulWidget {
  final String txt;

  _Pwd(this.txt);

  @override
  _PwdState createState() => new _PwdState(txt);
}

class _PwdState extends State<_Pwd> {
  TextEditingController _controller;

  _PwdState(String initTxt) {
    _controller = new TextEditingController(text: initTxt);
  }

  @override
  Widget build(BuildContext context) {
    return new TextField(
      controller: _controller,
      decoration: new InputDecoration(labelText: 'Pwd'),
      onSubmitted: (txt) => dispatch(Actions.SetPwd(txt)),
    );
  }
}
