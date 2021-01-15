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
    return Column(
      children: [

        RoundCornerPanelWidget(
          // caption: '已选复习计划',
          child: ItemContentWidget(
            icon: Icons.access_alarm,
            itemTitle: '已选计划',
            itemContent: '艾宾浩斯记忆曲线2019-2020版（秋）',
            itemContentForeColor: GlobalState.greyFontColor,
            showSwitch: true,
            showRightGreyArrow: true,
            onSwitchChanged: (isOn) async {
              var v = isOn;
            },
          ),
          height: GlobalState.reviewPlanItemHeight,
          showDivider: false,
          // isBottomLeftAndBottomRightCornerRound: false,
          // bottomMargin: GlobalState.defaultRoundCornerPanelBottomMargin,
          addBottomMargin: true,
          onTap: () async {
            GlobalState.reusablePageStackWidgetState.currentState
                .showReusablePage(
                reusablePageTitle: '已选复习计划',
                reusablePageWidget: ReviewPlanSecondSubPage(
                  key: GlobalState.reviewPlanSecondSubPageState,
                ),
                upcomingReusablePageIndex: 1);
          },
        ),
        RoundCornerPanelWidget(
          caption: '管理复习计划',
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
          showDivider: true,
          isBottomLeftAndBottomRightCornerRound: false,
          // addBottomMargin: true,
          onTap: () async {
            GlobalState.reusablePageStackWidgetState.currentState
                .showReusablePage(
                    reusablePageTitle: '已选复习计划',
                    reusablePageWidget: ReviewPlanSecondSubPage(
                      key: GlobalState.reviewPlanSecondSubPageState,
                    ),
                    upcomingReusablePageIndex: 1);
          },
        ),
        RoundCornerPanelWidget(
          isTopLeftAndTopRightCornerRound: false,
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
          onTap: () async {
            GlobalState.reusablePageStackWidgetState.currentState
                .showReusablePage(
                    reusablePageTitle: '已选复习计划',
                    reusablePageWidget: ReviewPlanSecondSubPage(
                      key: GlobalState.reviewPlanSecondSubPageState,
                    ),
                    upcomingReusablePageIndex: 1);
          },
        )
      ],
    );

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
