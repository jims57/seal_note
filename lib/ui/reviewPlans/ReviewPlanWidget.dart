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
  void _clickReviewPlanSelectionItemWidgetCallback(
      int reviewPlanId, String reviewPlanName) {
    setState(() {
      selectedReviewPlanId = reviewPlanId;
      selectedReviewPlanName = reviewPlanName;

      // Update the reviewPlanId for the folder
      GlobalState.database.updateFolderReviewPlanId(
        folderId: widget.folderId,
        newReviewPlanId: selectedReviewPlanId,
      );

      _buildReviewPlanSelectionItemWidgetList(triggerSetState: false);
    });
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

    var reviewPlanList = await GlobalState.database.getAllReviewPlans();
    var index = 0;
    var maxIndex = reviewPlanList.length - 1;

    // Add the first item for *Non-Review*
    reviewPlanSelectionItemWidgetList.add(ReviewPlanSelectionItemWidget(
      caption: '已选择：$selectedReviewPlanName',
      selectedReviewPlanId: selectedReviewPlanId,
      reviewPlanId: 0,
      reviewPlanName: '不复习',
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
