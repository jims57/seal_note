import 'package:flutter/material.dart';
import 'package:seal_note/data/appstate/GlobalState.dart';
import 'package:seal_note/ui/common/items/ItemContentWidget.dart';
import 'package:seal_note/ui/common/panels/RoundCornerPanelWidget.dart';

class ManageAllReviewPlanWidget extends StatefulWidget {
  @override
  _ManageAllReviewPlanWidgetState createState() =>
      _ManageAllReviewPlanWidgetState();
}

class _ManageAllReviewPlanWidgetState extends State<ManageAllReviewPlanWidget> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        RoundCornerPanelWidget(
          caption: '管理所有复习计划',
          // caption: '管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划管理所有复习计划',
          child: ItemContentWidget(
            itemContent: '英语复习计划【五段式】',
            itemContentForeColor: GlobalState.themeBlueColor,
            showRightGreyArrow: true,
          ),
          height: GlobalState.defaultItemHeight,
          isTopLeftAndTopRightCornerRound: true,
          isBottomLeftAndBottomRightCornerRound: false,
          showDivider: true,
        ),
        RoundCornerPanelWidget(
          child: ItemContentWidget(
            // itemTitle: '理解性材料复习计划',
            itemContent: '理解性材料复习计划',
            itemContentForeColor: GlobalState.themeBlueColor,
            showRightGreyArrow: true,
          ),
          height: GlobalState.defaultItemHeight,
          isTopLeftAndTopRightCornerRound: false,
          isBottomLeftAndBottomRightCornerRound: false,
          showDivider: true,
        ),
        RoundCornerPanelWidget(
          child: ItemContentWidget(
            itemContent: '考研一周冲刺复习计划',
            itemContentForeColor: GlobalState.themeBlueColor,
            showRightGreyArrow: true,
          ),
          height: GlobalState.defaultItemHeight,
          isTopLeftAndTopRightCornerRound: false,
          isBottomLeftAndBottomRightCornerRound: false,
          showDivider: true,
        ),
        RoundCornerPanelWidget(
          child: ItemContentWidget(
            itemContent: '艾宾浩斯记忆曲线',
            itemContentForeColor: GlobalState.themeBlueColor,
            showRightGreyArrow: true,
          ),
          height: GlobalState.defaultItemHeight,
          isTopLeftAndTopRightCornerRound: false,
          isBottomLeftAndBottomRightCornerRound: true,
          showDivider: false,
        ),


        RoundCornerPanelWidget(
          child: ItemContentWidget(
            itemContent: '艾宾浩斯记忆曲线',
            itemContentForeColor: GlobalState.themeBlueColor,
            showRightGreyArrow: true,
          ),
          height: GlobalState.defaultItemHeight,
          isTopLeftAndTopRightCornerRound: false,
          isBottomLeftAndBottomRightCornerRound: true,
          showDivider: false,
        ),
        RoundCornerPanelWidget(
          child: ItemContentWidget(
            itemContent: '艾宾浩斯记忆曲线',
            itemContentForeColor: GlobalState.themeBlueColor,
            showRightGreyArrow: true,
          ),
          height: GlobalState.defaultItemHeight,
          isTopLeftAndTopRightCornerRound: false,
          isBottomLeftAndBottomRightCornerRound: true,
          showDivider: false,
        ),
        RoundCornerPanelWidget(
          child: ItemContentWidget(
            itemContent: '艾宾浩斯记忆曲线',
            itemContentForeColor: GlobalState.themeBlueColor,
            showRightGreyArrow: true,
          ),
          height: GlobalState.defaultItemHeight,
          isTopLeftAndTopRightCornerRound: false,
          isBottomLeftAndBottomRightCornerRound: true,
          showDivider: false,
        ),
      ],
    );
  }
}
