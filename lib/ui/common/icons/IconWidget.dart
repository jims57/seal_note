import 'package:flutter/material.dart';
import 'package:seal_note/data/appstate/GlobalState.dart';

class IconWidget extends StatefulWidget {
  IconWidget({
    Key key,
    @required this.icon,
    this.iconSize = GlobalState.defaultIconSize,
    this.iconColor = GlobalState.themeLightBlueColorAtiOSTodo,
  }) : super(key: key);

  final IconData icon;
  final double iconSize;
  final Color iconColor;

  @override
  _IconWidgetState createState() => _IconWidgetState();
}

class _IconWidgetState extends State<IconWidget> {
  @override
  Widget build(BuildContext context) {
    return Icon(
      widget.icon,
      size: widget.iconSize,
      color: widget.iconColor,
    );
  }
}
