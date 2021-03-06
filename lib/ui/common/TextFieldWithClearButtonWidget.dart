import 'package:flutter/material.dart';
import 'package:seal_note/data/appstate/GlobalState.dart';

class TextFieldWithClearButtonWidget extends StatefulWidget {
  TextFieldWithClearButtonWidget({
    Key key,
    this.watermarkText = '名称',
    this.currentText = '',
    this.marginForLeftAndRight = 10.0,
    this.onTextChanged,
    this.showClearButton = false,
  }) : super(key: key);

  final String watermarkText;
  final String currentText;
  final double marginForLeftAndRight;
  final Function(String) onTextChanged;
  final bool showClearButton;

  @override
  _TextFieldWithClearButtonWidgetState createState() =>
      _TextFieldWithClearButtonWidgetState();
}

class _TextFieldWithClearButtonWidgetState
    extends State<TextFieldWithClearButtonWidget> {
  var _controller = TextEditingController();

  var _showClearButton = false;

  @override
  void initState() {
    _controller.value = TextEditingValue(text: widget.currentText);

    _showClearButton = widget.showClearButton;

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          left: widget.marginForLeftAndRight,
          right: widget.marginForLeftAndRight),
      child: TextField(
        controller: _controller,
        autofocus: true,
        decoration: InputDecoration(
          hintText: widget.watermarkText,
          suffixIcon: IconButton(
            onPressed: () {
              setState(() {
                if (_showClearButton) {
                  _showClearButton = false;
                  _controller.clear();
                  _triggerOnTextChangedCallback(input: '');
                }
              });
            },
            icon: Icon(
              Icons.clear,
              color: (_showClearButton)
                  ? GlobalState.themeBlueColor
                  : Colors.transparent,
            ),
          ),
        ),
        onChanged: (input) {
          _triggerOnTextChangedCallback(input: input);

          setState(() {
            input = input.trim();

            if (input.length > 0) {
              _showClearButton = true;
            } else {
              _showClearButton = false;
            }
          });
        },
      ),
    );
  }

  // Private methods
  void _triggerOnTextChangedCallback({@required String input}) {
    if (widget.onTextChanged != null) {
      widget.onTextChanged(input);
    }
  }
}
