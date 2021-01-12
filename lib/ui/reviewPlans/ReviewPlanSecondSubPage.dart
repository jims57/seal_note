import 'package:flutter/material.dart';
import 'package:seal_note/data/appstate/GlobalState.dart';
import 'package:seal_note/ui/reviewPlans/ReviewPlanThirdSubPage.dart';

class ReviewPlanSecondSubPage extends StatefulWidget {
  ReviewPlanSecondSubPage({
    Key key,
  }) : super(key: key);

  @override
  _ReviewPlanSecondSubPageState createState() =>
      _ReviewPlanSecondSubPageState();
}

class _ReviewPlanSecondSubPageState extends State<ReviewPlanSecondSubPage> {
  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.blue,
      height: 200,
      width: GlobalState.currentReusablePageWidth,
      child: Column(
        children: [
          GestureDetector(
            child: Text('Click me to the 3rd sub page!'),
            onTap: () async {
              GlobalState.reusablePageStackWidgetState.currentState
                  .showReusablePage(
                      reusablePageTitle: '3rd 页面',
                      reusablePageWidget: ReviewPlanThirdSubPage(),
                      upcomingReusablePageIndex: 2);
            },
          ),
          GestureDetector(
            child: Text('Click me to the 3-3rd sub page!'),
            onTap: () async {
              GlobalState.reusablePageStackWidgetState.currentState
                  .showReusablePage(
                      reusablePageTitle: '3-3rd 页面',
                      reusablePageWidget: Container(
                        color: Colors.greenAccent,
                        width: GlobalState.currentReusablePageWidth,
                        height: 200,
                      ),
                      upcomingReusablePageIndex: 2);
            },
          ),
        ],
      ),
    );
  }
}
