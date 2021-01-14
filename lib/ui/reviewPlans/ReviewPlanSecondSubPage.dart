import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:seal_note/data/appstate/GlobalState.dart';
import 'package:seal_note/data/appstate/ReusablePageWidthChangeNotifier.dart';
import 'package:seal_note/ui/reviewPlans/ReviewPlanThirdSubPage.dart';

class ReviewPlanSecondSubPage extends StatefulWidget {
  ReviewPlanSecondSubPage({
    @required Key key,
  }) : super(key: key);

  @override
  ReviewPlanSecondSubPageState createState() => ReviewPlanSecondSubPageState();
}

class ReviewPlanSecondSubPageState extends State<ReviewPlanSecondSubPage> {
  @override
  Widget build(BuildContext context) {
    return Consumer<ReusablePageWidthChangeNotifier>(
        builder: (cxt, reusablePageWidthChangeNotifier, child) {
      return Container(
        color: Colors.blue,
        height: 200,
        width: GlobalState.currentReusablePageWidth,
        child: Column(
          children: [
            GestureDetector(
              child: Text(
                  'Click me to the 3rd sub page!Click me to the 3rd sub page!Click me to the 3rd sub page!Click me to the 3rd sub page!Click me to the 3rd sub page!'),
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
                var theWidget = Consumer<ReusablePageWidthChangeNotifier>(
                    builder: (cxt, reusablePageWidthChangeNotifier, child) {
                  return Container(
                    color: Colors.greenAccent,
                    width: GlobalState.currentReusablePageWidth,
                    height: 200,
                  );
                });

                GlobalState.reusablePageStackWidgetState.currentState
                    .showReusablePage(
                        reusablePageTitle: '3-3rd 页面',
                        reusablePageWidget: theWidget,
                        upcomingReusablePageIndex: 2);
              },
            ),
          ],
        ),
      );
    });
  }

  // Public methods
  void triggerSetState() {
    setState(() {});
  }
}
