import 'package:flutter/material.dart';
import 'package:seal_note/data/appstate/GlobalState.dart';

class RightGreyArrowWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      // color: Colors.yellow,
      width: 10.0,
      child: Icon(
        Icons.arrow_forward_ios,
        size: 12.0,
        color: GlobalState.themeGreyColorAtiOSTodo,
      ),
    );
  }
}
