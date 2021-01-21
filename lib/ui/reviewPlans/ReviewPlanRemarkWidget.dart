import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seal_note/data/appstate/GlobalState.dart';
import 'package:seal_note/data/appstate/ReusablePageWidthChangeNotifier.dart';

class ReviewPlanRemarkWidget extends StatefulWidget {
  @override
  _ReviewPlanRemarkWidgetState createState() => _ReviewPlanRemarkWidgetState();
}

class _ReviewPlanRemarkWidgetState extends State<ReviewPlanRemarkWidget> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ReusablePageWidthChangeNotifier>(
        builder: (cxt, reusablePageWidthChangeNotifier, child) {
      return Container(
        margin: EdgeInsets.only(
          left: GlobalState.defaultLeftAndRightMarginBetweenParentBoarderAndPanel,
          right: GlobalState.defaultLeftAndRightMarginBetweenParentBoarderAndPanel,
        ),
        padding: EdgeInsets.only(
          left: GlobalState.defaultLeftAndRightMarginBetweenParentBoarderAndPanel,
          right: GlobalState.defaultLeftAndRightMarginBetweenParentBoarderAndPanel,
        ),
        // height: 200,
        width: GlobalState.currentReusablePageWidth,
        child: Text(
          '说明：选择后，此文件夹的笔记，会按复习计划（如：艾宾浩斯遗忘曲线），间隔地出现在【今天】的文件夹中，方便你「间隔重复」复习，从而抵抗遗忘。',
          style: GlobalState.remarkTextStyle,
        ),
      );
    });
  }
}
