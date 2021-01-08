import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:seal_note/data/appstate/GlobalState.dart';

class CupertinoSwitchWidget extends StatefulWidget {
  CupertinoSwitchWidget({
    Key key,
    @required this.onSwitchChanged,
  }) : super(key: key);

  final Function(bool) onSwitchChanged;

  @override
  _CupertinoSwitchWidgetState createState() => _CupertinoSwitchWidgetState();
}

class _CupertinoSwitchWidgetState extends State<CupertinoSwitchWidget> {
  var _isOn = true;

  @override
  Widget build(BuildContext context) {
    return CupertinoSwitch(
      value: _isOn,
      activeColor: GlobalState.themeBlueColor,
      trackColor: GlobalState.themeGreyColorAtiOSTodoForBackground,
      onChanged: (isOn) {
        setState(() {
          _isOn = isOn;
          widget.onSwitchChanged(isOn);
        });
      },
    );
  }
}
