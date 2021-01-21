import 'package:flutter/material.dart';
import 'package:seal_note/data/appstate/GlobalState.dart';
import 'package:seal_note/ui/common/items/ItemContentWidget.dart';
import 'package:seal_note/ui/common/panels/RoundCornerPanelWidget.dart';

class ReviewPlanSelectionItemWidget extends StatefulWidget {
  ReviewPlanSelectionItemWidget({
    Key key,
    this.caption,
    @required this.selectedReviewPlanId,
    @required this.reviewPlanId,
    @required this.reviewPlanName,
    this.isTopLeftAndTopRightCornerRound = false,
    this.isBottomLeftAndBottomRightCornerRound = false,
    this.showDivider = false,
    this.addBottomMargin = false,
    this.onTap,
  }) : super(key: key);

  final String caption;
  final int selectedReviewPlanId;
  final int reviewPlanId;
  final String reviewPlanName;
  final bool isTopLeftAndTopRightCornerRound;
  final bool isBottomLeftAndBottomRightCornerRound;
  final bool showDivider;
  final bool addBottomMargin;
  final Function(int, String) onTap;

  @override
  _ReviewPlanSelectionItemWidgetState createState() =>
      _ReviewPlanSelectionItemWidgetState();
}

class _ReviewPlanSelectionItemWidgetState
    extends State<ReviewPlanSelectionItemWidget> {
  @override
  Widget build(BuildContext context) {
    return RoundCornerPanelWidget(
      caption: (widget.caption != null) ? widget.caption : null,
      child: ItemContentWidget(
        icon: Icons.check,
        iconColor: _isSelectedReviewPlan()
            ? GlobalState.themeBlackColor87ForFontForeColor
            : Colors.transparent,
        itemContent: widget.reviewPlanName,
        showSwitch: false,
        showInfoIcon: _isSelectedReviewPlan(),
        showRightGreyArrow: false,
        onSwitchChanged: (isOn) async {
          var v = isOn;
        },
      ),
      height: GlobalState.reviewPlanItemHeight,
      addBottomMargin: widget.addBottomMargin,
      showDivider: widget.showDivider,
      isTopLeftAndTopRightCornerRound: widget.isTopLeftAndTopRightCornerRound,
      isBottomLeftAndBottomRightCornerRound:
          widget.isBottomLeftAndBottomRightCornerRound,
      onTap: () {
        if (widget.onTap != null) {
          widget.onTap(widget.reviewPlanId, widget.reviewPlanName);
        }
      },
    );
  }

  // Private methods
  bool _isSelectedReviewPlan() {
    var isSelectedReviewPlan = false;

    if (widget.selectedReviewPlanId == widget.reviewPlanId) {
      isSelectedReviewPlan = true;
    }

    return isSelectedReviewPlan;
  }
}
