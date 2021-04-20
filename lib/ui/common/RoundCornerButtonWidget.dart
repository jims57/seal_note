import 'package:flutter/material.dart';
import 'package:seal_note/data/appstate/GlobalState.dart';

class RoundCornerButtonWidget extends StatefulWidget {
  RoundCornerButtonWidget({
    Key key,
    @required this.buttonText,
    @required this.buttonCallback,
    this.buttonTextFontSize = 18.0,
    this.buttonTextColor = GlobalState.themeBlueColor,
    this.buttonBorderColor = GlobalState.themeBlueColor,
    this.buttonPaddingColor = Colors.white,
    this.buttonHeight = 40.0,
    this.topMargin = 15.0,
    this.bottomMargin = 15.0,
    this.isDisabled = false,
  }) : super(key: key);

  final String buttonText;
  final VoidCallback buttonCallback;
  final double buttonTextFontSize;
  final Color buttonTextColor;
  final Color buttonBorderColor;
  final Color buttonPaddingColor;
  final double buttonHeight;
  final double topMargin;
  final double bottomMargin;
  final bool isDisabled;

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
          height: widget.buttonHeight,
          width: double.maxFinite,
          decoration: BoxDecoration(
            color: _showNormalOrDisabledColor(
                colorForNormalStatus: widget.buttonPaddingColor,
                isDisabled: widget.isDisabled),
            border: Border.all(
                color: _showNormalOrDisabledColor(
                    colorForNormalStatus: widget.buttonBorderColor,
                    isDisabled: widget.isDisabled)),
            borderRadius: const BorderRadius.all(
                const Radius.circular(GlobalState.borderRadius15)),
          ),
          child: Text(
            widget.buttonText,
            style: TextStyle(
                color: widget.buttonTextColor,
                fontSize: widget.buttonTextFontSize),
          ),
        ),
        // onTap: (widget.isDisabled) ? () {} : widget.buttonCallback,
        onTap: widget.buttonCallback,
      ),
    );
  }

  // Private methods
  Color _showNormalOrDisabledColor(
      {@required Color colorForNormalStatus, @required bool isDisabled}) {
    if (isDisabled) {
      return GlobalState.themeGreyColorForDisabled;
    } else {
      return colorForNormalStatus;
    }
  }
}
