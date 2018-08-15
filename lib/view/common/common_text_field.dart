import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

/**
 * Example:
 * CommonTextField(
 *   labelText: 'Labelka',
 *   onChange: (txt) => print('submitted: ' + txt),
 *   initValue: 'initTxt',
 *   inputType: FieldInputType.TEXT,
 *   ),
 *
 */

typedef void _OnChange(String txt);
enum FieldInputType { PHONE, EMAIL, TEXT }

class CommonTextField extends StatefulWidget {
  final FieldInputType inputType;
  final String labelText;
  final String initValue;
  final _OnChange onChange;
  final String Function(dynamic) validator;
  final IconData icon;

  CommonTextField({
    @required this.labelText,
    @required this.initValue,
    @required this.inputType,
    @required this.onChange,
    this.validator = null,
    this.icon = null,
  });

  @override
  _FieldState createState() => _FieldState(initValue);
}

class _FieldState extends State<CommonTextField> {
  TextEditingController _controller;

  _FieldState(String initTxt) {
    _controller = new TextEditingController(text: initTxt);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return ListTile(
        title: TextField(
      controller: _controller,
      decoration: new InputDecoration(
        labelText: widget.labelText,
        icon: Icon(widget.icon) ?? _predefinedTypes[widget.inputType].icon,
        hintText: _predefinedTypes[widget.inputType].hintText ?? '',
      ),
      keyboardType: _predefinedTypes[widget.inputType].keyboardType,
      inputFormatters: _predefinedTypes[widget.inputType].inputFormatters,
      onSubmitted: widget.onChange,
    ));
  }
}

final Map<FieldInputType, _InputType> _predefinedTypes = {
  FieldInputType.PHONE: _InputType(
    icon: const Icon(Icons.phone),
    hintText: 'Enter a phone number',
    keyboardType: TextInputType.phone,
    inputFormatters: [
      WhitelistingTextInputFormatter.digitsOnly,
    ],
  ),
  FieldInputType.EMAIL: _InputType(
    icon: const Icon(Icons.email),
    hintText: 'Enter a email address',
    keyboardType: TextInputType.emailAddress,
    inputFormatters: [],
  ),
  FieldInputType.TEXT: _InputType(
    icon: const Icon(Icons.text_fields),
    hintText: 'Enter a text',
    inputFormatters: [],
    keyboardType: TextInputType.text,
  ),
};

class _InputType {
  final Icon icon;
  final String hintText;
//  final InputDecoration decoration;
  final TextInputType keyboardType;
  final List<TextInputFormatter> inputFormatters;

  _InputType({@required this.icon, this.hintText, @required this.keyboardType, @required this.inputFormatters});
}
