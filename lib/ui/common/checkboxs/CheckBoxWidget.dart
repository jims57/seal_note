import 'package:flutter/material.dart';
import 'package:seal_note/data/appstate/GlobalState.dart';

class CheckBoxWidget extends StatefulWidget {
  @override
  _CheckBoxWidgetState createState() => _CheckBoxWidgetState();
}

class _CheckBoxWidgetState extends State<CheckBoxWidget> {
  var _isChecked = false;

  @override
  Widget build(BuildContext context) {

    return Container(
      width: GlobalState.defaultCheckBoxWidth,
      // color: Colors.red,
      child: ClipRRect(
        borderRadius: BorderRadius.all(Radius.circular(90.0)),
        child: Checkbox(
          value: _isChecked,
          onChanged: (isChecked) async {
            var isLoginButtonDisabled = true;
            var hasCheckedAgreement = false;

            if (isChecked) {
              isLoginButtonDisabled = false;
              hasCheckedAgreement = true;
            }

            setState(() {
              _isChecked = isChecked;
            });

            GlobalState.loginPageState.currentState.triggerSetState(
              isLoginButtonDisabled: isLoginButtonDisabled,
              hasCheckedAgreement: hasCheckedAgreement,
            );
          },
        ),
      ),
    );
  }
}
