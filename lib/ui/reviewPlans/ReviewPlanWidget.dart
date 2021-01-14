import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seal_note/data/appstate/GlobalState.dart';
import 'package:seal_note/data/appstate/ReusablePageWidthChangeNotifier.dart';
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
      child: Column(
        children: [
          ChosenReviewPlanWidget(),
          SizedBox(
            height: GlobalState.defaultVerticalMarginBetweenItems,
          ),
          Container(
            child: GestureDetector(
              child: Text('Click me 2'),
              onTap: () {
                var theWidget = Consumer<ReusablePageWidthChangeNotifier>(
                    builder: (cxt, reusablePageWidthChangeNotifier, child) {
                  return Container(
                    width: GlobalState.currentReusablePageWidth,
                    height: 200,
                    color: Colors.purple,
                  );
                });

                GlobalState.reusablePageStackWidgetState.currentState
                    .showReusablePage(
                        reusablePageTitle: 'Purple页面',
                        reusablePageWidget: theWidget,
                        upcomingReusablePageIndex: 1);
              },
            ),
          ),
          Expanded(child: ManageAllReviewPlanWidget()),
        ],
      ),
    );
  }
}
