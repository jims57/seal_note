import 'package:flutter/material.dart';
import 'package:seal_note/data/appstate/GlobalState.dart';
import 'package:seal_note/ui/common/RoundCornerButtonWidget.dart';

class ManageReviewPlanButtonWidget extends StatefulWidget {
  ManageReviewPlanButtonWidget({
    Key key,
    this.buttonContainerHeight = 90.0,
  }) : super(key: key);

  final double buttonContainerHeight;

  @override
  _ManageReviewPlanButtonWidgetState createState() =>
      _ManageReviewPlanButtonWidgetState();
}

class _ManageReviewPlanButtonWidgetState
    extends State<ManageReviewPlanButtonWidget> {
  @override
  Widget build(BuildContext context) {
    return Container(
      height: widget.buttonContainerHeight,
      width: GlobalState.currentReusablePageWidth,
      child: RoundCornerButtonWidget(
        topMargin: 20.0,
        bottomMargin: 20.0,
        buttonText: '管理复习计划',
        buttonCallback: () async {},
      ),
    );
  }
}
