import 'package:flutter/material.dart';
import 'package:seal_note/data/appstate/GlobalState.dart';
import 'package:seal_note/ui/common/arrows/RightArrowWidget.dart';
import 'package:seal_note/ui/common/items/ItemContentWidget.dart';
import 'package:seal_note/ui/common/panels/RoundCornerPanelWidget.dart';

class ChosenReviewPlanWidget extends StatefulWidget {
  @override
  _ChosenReviewPlanWidgetState createState() => _ChosenReviewPlanWidgetState();
}

class _ChosenReviewPlanWidgetState extends State<ChosenReviewPlanWidget> {
  @override
  Widget build(BuildContext context) {
    return RoundCornerPanelWidget(
      child: ItemContentWidget(
        icon: Icons.access_alarm,
        itemTitle: '复习计划',
        itemContent: '艾宾浩斯记忆曲线2019-2020版（秋）',
        itemContentForeColor: GlobalState.greyFontColor,
        showSwitch: true,
        showRightGreyArrow: true,
        onSwitchChanged: (isOn) async {
          var v = isOn;
        },
      ),
      height: GlobalState.reviewPlanItemHeight,
      // onTap: () async {
      //   var s = 's';
      // },
    );
  }
}
