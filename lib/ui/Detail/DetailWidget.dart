import 'package:flutter/material.dart';

class DetailWidget extends StatefulWidget {
  DetailWidget(this.selectedIndex);

  final int selectedIndex;

  @override
  State<StatefulWidget> createState() => _DetailWidgetState();
}

class _DetailWidgetState extends State<DetailWidget> {
  @override
  Widget build(BuildContext context) {
    return Text(
        'I am detail widget! Selected index is: ${widget.selectedIndex}');
  }
}
