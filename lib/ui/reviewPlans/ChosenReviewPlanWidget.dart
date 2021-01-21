import 'package:flutter/material.dart';
import 'package:seal_note/data/appstate/GlobalState.dart';
import 'package:seal_note/ui/common/items/ItemContentWidget.dart';
import 'package:seal_note/ui/common/panels/RoundCornerPanelWidget.dart';
import 'package:seal_note/ui/reviewPlans/ReviewPlanSecondSubPage.dart';

class ChosenReviewPlanWidget extends StatefulWidget {
  @override
  _ChosenReviewPlanWidgetState createState() => _ChosenReviewPlanWidgetState();
}

class _ChosenReviewPlanWidgetState extends State<ChosenReviewPlanWidget> {
  @override
  Widget build(BuildContext context) {
    return RoundCornerPanelWidget(
      caption: '选择复习计划',
      child: ItemContentWidget(
        // itemTitle: '已选计划',
        itemContent: '艾宾浩斯记忆曲线2019-2020版（秋）',
        itemContentForeColor: GlobalState.greyFontColor,
        showSwitch: false,
        showRightGreyArrow: true,
        onSwitchChanged: (isOn) async {
          var v = isOn;
        },
      ),
      height: GlobalState.reviewPlanItemHeight,
      showDivider: false,
      addBottomMargin: true,
      onTap: () async {
        GlobalState.reusablePageStackWidgetState.currentState.showReusablePage(
            reusablePageTitle: '已选复习计划',
            reusablePageWidget: ReviewPlanSecondSubPage(
              key: GlobalState.reviewPlanSecondSubPageState,
            ),
            upcomingReusablePageIndex: 1);
      },
    );
  }
}
