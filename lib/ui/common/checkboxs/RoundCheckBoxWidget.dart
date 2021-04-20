import 'package:flutter/material.dart';

class RoundCheckBoxWidget extends StatefulWidget {
  RoundCheckBoxWidget({
    Key key,
    this.isChecked = true,
    this.checkBoxSize = 20.0,
    this.onChanged,
  }) : super(key: key);

  final bool isChecked;
  final double checkBoxSize;
  final ValueChanged<bool> onChanged;

  @override
  _RoundCheckBoxWidgetState createState() => _RoundCheckBoxWidgetState();
}

class _RoundCheckBoxWidgetState extends State<RoundCheckBoxWidget> {
  bool _isChecked = false;

  @override
  void initState() {
    _isChecked = widget.isChecked;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      child: Container(
        margin: EdgeInsets.only(right: 5.0),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _getFillColor(isChecked: _isChecked),
          border: Border.all(
            color: _getBorderColor(isChecked: _isChecked),
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.all(2.0),
          child: _isChecked
              ? Icon(
                  Icons.check,
                  size: widget.checkBoxSize,
                  color: Colors.white,
                )
              : Icon(
                  Icons.check_box_outline_blank,
                  size: widget.checkBoxSize,
                  color: _getFillColor(isChecked: _isChecked),
                ),
        ),
      ),
      onTap: () async {
        setState(() {
          _isChecked = !_isChecked;
        });

        widget.onChanged(_isChecked);
      },
    );
  }

  // Private methods
  Color _getFillColor({@required bool isChecked}) {
    if (isChecked) {
      return Colors.blue;
    } else {
      return Colors.white;
    }
  }

  Color _getBorderColor({@required bool isChecked}) {
    if (_isChecked) {
      return Colors.blue;
    } else {
      return Colors.grey;
    }
  }
}
