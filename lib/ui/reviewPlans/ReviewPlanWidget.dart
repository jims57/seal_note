import 'package:flutter/material.dart';
import 'package:seal_note/data/appstate/GlobalState.dart';
import 'package:seal_note/ui/reviewPlans/ChosenReviewPlanWidget.dart';
import 'package:seal_note/ui/reviewPlans/ManageAllReviewPlanWidget.dart';

class ReviewPlanWidget extends StatefulWidget {
  @override
  _ReviewPlanWidgetState createState() => _ReviewPlanWidgetState();
}

class _ReviewPlanWidgetState extends State<ReviewPlanWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      // margin: EdgeInsets.only(left: 15.0, right: 15.0),
      child: Column(
        children: [
          ChosenReviewPlanWidget(),
          // ChosenReviewPlanWidget(),
          SizedBox(height: GlobalState.defaultVerticalMarginBetweenItems,),
          Expanded(child: ManageAllReviewPlanWidget()),
        ],
      ),
    );
  }
}
