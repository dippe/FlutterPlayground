import 'package:flutter/material.dart';
import 'package:flutter_redux/flutter_redux.dart';
import 'package:todo_flutter_app/state/domain.dart';
import 'package:todo_flutter_app/state/state.dart';
import 'package:todo_flutter_app/view/common/common_switch_field.dart';
import 'package:todo_flutter_app/view/common/common_text_field.dart';
import 'package:todo_flutter_app/view/config/action.dart';
import 'package:todo_flutter_app/view/action.dart';

Widget wConfigPage() => new StoreConnector<AppState, ConfigState>(
      converter: (state) => state.state.config,
      builder: (context, config) => new Column(
            children: <Widget>[
              Title(
                color: Colors.greenAccent,
                title: 'Login',
                child: Text('Configure JIRA Login'),
              ),
              const Divider(
                color: Colors.white,
                height: 15.0,
              ),
              CommonTextField(
                inputType: FieldInputType.TEXT,
                initValue: config.baseUrl != null && config.baseUrl.isNotEmpty ? config.baseUrl : 'https://',
                labelText: 'JIRA BaseURL',
                onChange: (txt) => dispatch(SetBaseUrl(txt)),
                icon: Icons.input,
              ),
              CommonTextField(
                inputType: FieldInputType.TEXT,
                initValue: config.user,
                labelText: 'Username',
                onChange: (txt) => dispatch(SetUserName(txt)),
                icon: Icons.person,
              ),
              CommonTextField(
                inputType: FieldInputType.PASSWORD,
                initValue: config.password,
                labelText: 'Password',
                onChange: (txt) => dispatch(SetPwd(txt)),
                icon: Icons.input,
              ),
              Divider(
                height: 2.0,
                color: Colors.white,
              ),
              CommonSwitchField(
                labelText: 'Compact List View',
                initValue: config.listViewMode == ListViewMode.COMPACT,
                onChange: (val) => dispatch(ToggleDisplayModeAction()),
              ),
              new FlatButton(
                child: Text('Back to the list'),
                onPressed: () => dispatch(HideConfigPage()),
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
      onSubmitted: (txt) => dispatch(SetUserName(txt)),
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
      onSubmitted: (txt) => dispatch(SetPwd(txt)),
    );
  }
}
