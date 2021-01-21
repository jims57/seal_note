import 'package:flutter/material.dart';
import 'package:seal_note/data/appstate/GlobalState.dart';

class RoundCornerButtonWidget extends StatefulWidget {
  RoundCornerButtonWidget({
    Key key,
    @required this.buttonText,
    @required this.buttonCallback,
    this.buttonTextFontSize = 18.0,
    this.buttonThemeColor = GlobalState.themeBlueColor,
    this.topMargin = 15.0,
    this.bottomMargin = 15.0,
  }) : super(key: key);

  final String buttonText;
  final VoidCallback buttonCallback;
  final double buttonTextFontSize;
  final Color buttonThemeColor;
  final double topMargin;
  final double bottomMargin;

  @override
  _RoundCornerButtonWidgetState createState() =>
      _RoundCornerButtonWidgetState();
}

class _RoundCornerButtonWidgetState extends State<RoundCornerButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.only(
          left: 15.0,
          right: 15.0,
          top: widget.topMargin,
          bottom: widget.bottomMargin),
      child: GestureDetector(
        child: Container(
          alignment: Alignment.center,
          height: 40.0,
          width: double.maxFinite,
          decoration: BoxDecoration(
            color: Colors.white,
            border: Border.all(color: widget.buttonThemeColor),
            borderRadius: const BorderRadius.all(const Radius.circular(15.0)),
          ),
          child: Text(
            widget.buttonText,
            style: TextStyle(
                color: widget.buttonThemeColor,
                fontSize: widget.buttonTextFontSize),
          ),
        ),
        onTap: widget.buttonCallback,
      ),
    );
  }
}
