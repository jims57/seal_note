import 'package:flutter/material.dart';
import 'package:seal_note/data/appstate/GlobalState.dart';
import 'package:seal_note/data/database/database.dart';
import 'package:seal_note/ui/reviewPlans/ChosenReviewPlanWidget.dart';
import 'package:seal_note/ui/reviewPlans/ReviewPlanRemarkWidget.dart';

import 'ReviewPlanSelectionItemWidget.dart';

class ReviewPlanWidget extends StatefulWidget {
  ReviewPlanWidget({
    @required Key key,
    @required this.folderId,
    @required this.getFolderReviewPlanByFolderIdResult,
  }) : super(key: key);

  final int folderId;
  final GetFolderReviewPlanByFolderIdResult getFolderReviewPlanByFolderIdResult;

  @override
  ReviewPlanWidgetState createState() => ReviewPlanWidgetState();
}

class ReviewPlanWidgetState extends State<ReviewPlanWidget> {
  var selectedReviewPlanId;
  var selectedReviewPlanName;
  var reviewPlanList = <ReviewPlanEntry>[];
  var reviewPlanSelectionItemWidgetList = <ReviewPlanSelectionItemWidget>[];

  @override
  void initState() {
    _initReviewPlanIdAndNameVar();
    _buildReviewPlanSelectionItemWidgetList();
    super.initState();
  }

  @override
  void didUpdateWidget(covariant ReviewPlanWidget oldWidget) {
    _initReviewPlanIdAndNameVar();
    _buildReviewPlanSelectionItemWidgetList();

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Column(
          children: reviewPlanSelectionItemWidgetList,
        ),
        ReviewPlanRemarkWidget(),
      ],
    );
  }

  // Private methods
  Future<void> _initReviewPlanListByDataFromDb() async {
    reviewPlanList.clear();
    reviewPlanList = await GlobalState.database.getAllReviewPlans();
  }

  Future<void> _clickReviewPlanSelectionItemWidgetCallback(
    int oldReviewPlanId,
    int newReviewPlanId,
    String reviewPlanName,
  ) async {
    // change review plan // change folder review plan
    // click to change folder review plan // click to change review plan

    if (selectedReviewPlanId != newReviewPlanId) {
      selectedReviewPlanId = newReviewPlanId;
      selectedReviewPlanName = reviewPlanName;

      // Update the reviewPlanId for the folder
      await GlobalState.database.updateFolderReviewPlanId(
        folderId: widget.folderId,
        oldReviewPlanId: oldReviewPlanId,
        newReviewPlanId: newReviewPlanId,
      );

      _buildReviewPlanSelectionItemWidgetList(triggerSetState: false);

      setState(() {});
    }

    // Set the reviewProgressNo and isReviewFinished field to the right values
    await GlobalState.database
        .setRightReviewProgressNoAndIsReviewFinishedFieldForAllNotes();
  }

  void _initReviewPlanIdAndNameVar() {
    var getFolderReviewPlanByFolderIdResult =
        widget.getFolderReviewPlanByFolderIdResult;

    if (getFolderReviewPlanByFolderIdResult == null) {
      selectedReviewPlanId = 0;
      selectedReviewPlanName = '不复习';
    } else {
      selectedReviewPlanId = getFolderReviewPlanByFolderIdResult.reviewPlanId;
      selectedReviewPlanName =
          getFolderReviewPlanByFolderIdResult.reviewPlanName;
    }
  }

  void _buildReviewPlanSelectionItemWidgetList(
      {bool triggerSetState = true}) async {
    reviewPlanSelectionItemWidgetList.clear();

    await _initReviewPlanListByDataFromDb();

    var index = 0;
    var maxIndex = reviewPlanList.length - 1;

    // Add the first item for *Non-Review*
    reviewPlanSelectionItemWidgetList.add(ReviewPlanSelectionItemWidget(
      caption: '已选择：$selectedReviewPlanName',
      selectedReviewPlanId: selectedReviewPlanId,
      reviewPlanId: 0,
      reviewPlanName: '不复习',
      reviewPlanIntroduction: '不复习就是指不用复习的！',
      showDivider: true,
      isTopLeftAndTopRightCornerRound: true,
      isBottomLeftAndBottomRightCornerRound: false,
      onTap: _clickReviewPlanSelectionItemWidgetCallback,
    ));

    reviewPlanList.forEach((reviewPlan) {
      // Check if it is the last review plan
      var isLastReviewPlan = false;
      if (index == maxIndex) {
        isLastReviewPlan = true;
      }

      var theReviewPlanSelectionItemWidget = ReviewPlanSelectionItemWidget(
        selectedReviewPlanId: selectedReviewPlanId,
        reviewPlanId: reviewPlan.id,
        reviewPlanName: reviewPlan.name,
        reviewPlanIntroduction: reviewPlan.introduction,
        showDivider: true,
        isTopLeftAndTopRightCornerRound: false,
        isBottomLeftAndBottomRightCornerRound: isLastReviewPlan,
        addBottomMargin: isLastReviewPlan,
        onTap: _clickReviewPlanSelectionItemWidgetCallback,
      );

      reviewPlanSelectionItemWidgetList.add(theReviewPlanSelectionItemWidget);

      index++;
    });

    if (triggerSetState) {
      setState(() {});
    }
  }
}
