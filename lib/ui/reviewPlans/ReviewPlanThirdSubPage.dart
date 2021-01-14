import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seal_note/data/appstate/GlobalState.dart';
import 'package:seal_note/data/appstate/ReusablePageWidthChangeNotifier.dart';

class ReviewPlanThirdSubPage extends StatefulWidget {
  @override
  _ReviewPlanThirdSubPageState createState() => _ReviewPlanThirdSubPageState();
}

class _ReviewPlanThirdSubPageState extends State<ReviewPlanThirdSubPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ReusablePageWidthChangeNotifier>(
        builder: (cxt, reusablePageWidthChangeNotifier, child) {
      return Container(
        color: Colors.yellow,
        height: 200,
        width: GlobalState.currentReusablePageWidth,
        child: Text('I am 3rd sub page'),
      );
    });
  }
}
