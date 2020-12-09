import 'package:flutter/material.dart';
import 'package:seal_note/data/appstate/GlobalState.dart';

class TextFieldWithClearButtonWidget extends StatefulWidget {
  TextFieldWithClearButtonWidget(
      {Key key, this.watermarkText = '名称', this.marginForLeftAndRight = 10.0})
      : super(key: key);

  final String watermarkText;
  final double marginForLeftAndRight;

  @override
  _TextFieldWithClearButtonWidgetState createState() =>
      _TextFieldWithClearButtonWidgetState();
}

class _TextFieldWithClearButtonWidgetState
    extends State<TextFieldWithClearButtonWidget> {
  var _controller = TextEditingController();
  var _shouldShowClearButton = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          left: widget.marginForLeftAndRight,
          right: widget.marginForLeftAndRight),
      child: TextField(
        controller: _controller,
        decoration: InputDecoration(
          hintText: widget.watermarkText,
          suffixIcon: IconButton(
            onPressed: () {
              if (_shouldShowClearButton) _controller.clear();
            },
            icon: Icon(
              Icons.clear,
              color: (_shouldShowClearButton)
                  ? GlobalState.themeBlueColor
                  : Colors.transparent,
            ),
          ),
        ),
        onChanged: (input) {
          setState(() {
            if (input.length > 0) {
              _shouldShowClearButton = true;
            } else {
              _shouldShowClearButton = false;
            }
          });
        },
      ),
    );
  }
}
