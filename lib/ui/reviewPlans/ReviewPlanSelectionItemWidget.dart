import 'package:flutter/material.dart';
import 'package:seal_note/data/appstate/GlobalState.dart';
import 'package:seal_note/ui/common/items/ItemContentWidget.dart';
import 'package:seal_note/ui/common/panels/RoundCornerPanelWidget.dart';
import 'package:seal_note/util/dialog/AlertDialogHandler.dart';

class ReviewPlanSelectionItemWidget extends StatefulWidget {
  ReviewPlanSelectionItemWidget({
    Key key,
    this.caption,
    @required this.selectedReviewPlanId,
    @required this.reviewPlanId,
    @required this.reviewPlanName,
    @required this.reviewPlanIntroduction,
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
  final String reviewPlanIntroduction;
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
        onInfoIconClicked: () async {
          // click on info icon button // click info icon button
          // click info button // click info button event

          GlobalState.noteDetailWidgetState.currentState
              .executionCallbackToAvoidBeingBlockedByWebView(
                  callback: () async {
            AlertDialogHandler().showAlertDialog(
              parentContext: context,
              captionText: widget.reviewPlanName,
              showButtonForCancel: false,
              showButtonForOK: true,
              restoreWebViewToShowIfNeeded: true,
              barrierDismissible: true,
              expandRemarkToMaxFinite: true,
              centerRemark: false,
              remark: widget.reviewPlanIntroduction,
              // child: Text('ch'),
              // '第一次复习之后，可以间隔更长的时间来回顾：1个小时后复习一次，之后是分别在1天、3天、7天、14天、21天、28天、2个月、3个月之后再复习一次，然后这些内容就永远地储存在你的大脑里了。在最开始的72个小时内记忆会更深刻，关联性也会更强.第一次复习之后，可以间隔更长的时间来回顾：1个小时后复习一次，之后是分别在1天、3天、7天、14天、21天、28天、2个月、3个月之后再复习一次，然后这些内容就永远地储存在你的大脑里了。在最开始的72个小时内记忆会更深刻，关联性也会更强第一次复习之后，可以间隔更长的时间来回顾：1个小时后复习一次，之后是分别在1天、3天、7天、14天、21天、28天、2个月、3个月之后再复习一次，然后这些内容就永远地储存在你的大脑里了。在最开始的72个小时内记忆会更深刻，关联性也会更强第一次复习之后，可以间隔更长的时间来回顾：1个小时后复习一次，之后是分别在1天、3天、7天、14天、21天、28天、2个月、3个月之后再复习一次，然后这些内容就永远地储存在你的大脑里了。在最开始的72个小时内记忆会更深刻，关联性也会更强第一次复习之后，可以间隔更长的时间来回顾：1个小时后复习一次，之后是分别在1天、3天、7天、14天、21天、28天、2个月、3个月之后再复习一次，然后这些内容就永远地储存在你的大脑里了。在最开始的72个小时内记忆会更深刻，关联性也会更强第一次复习之后，可以间隔更长的时间来回顾：1个小时后复习一次，之后是分别在1天、3天、7天、14天、21天、28天、2个月、3个月之后再复习一次，然后这些内容就永远地储存在你的大脑里了。在最开始的72个小时内记忆会更深刻，关联性也会更强第一次复习之后，可以间隔更长的时间来回顾：1个小时后复习一次，之后是分别在1天、3天、7天、14天、21天、28天、2个月、3个月之后再复习一次，然后这些内容就永远地储存在你的大脑里了。在最开始的72个小时内记忆会更深刻，关联性也会更强第一次复习之后，可以间隔更长的时间来回顾：1个小时后复习一次，之后是分别在1天、3天、7天、14天、21天、28天、2个月、3个月之后再复习一次，然后这些内容就永远地储存在你的大脑里了。在最开始的72个小时内记忆会更深刻，关联性也会更强第一次复习之后，可以间隔更长的时间来回顾：1个小时后复习一次，之后是分别在1天、3天、7天、14天、21天、28天、2个月、3个月之后再复习一次，然后这些内容就永远地储存在你的大脑里了。在最开始的72个小时内记忆会更深刻，关联性也会更强第一次复习之后，可以间隔更长的时间来回顾：1个小时后复习一次，之后是分别在1天、3天、7天、14天、21天、28天、2个月、3个月之后再复习一次，然后这些内容就永远地储存在你的大脑里了。在最开始的72个小时内记忆会更深刻，关联性也会更强第一次复习之后，可以间隔更长的时间来回顾：1个小时后复习一次，之后是分别在1天、3天、7天、14天、21天、28天、2个月、3个月之后再复习一次，然后这些内容就永远地储存在你的大脑里了。在最开始的72个小时内记忆会更深刻，关联性也会更强第一次复习之后，可以间隔更长的时间来回顾：1个小时后复习一次，之后是分别在1天、3天、7天、14天、21天、28天、2个月、3个月之后再复习一次，然后这些内容就永远地储存在你的大脑里了。在最开始的72个小时内记忆会更深刻，关联性也会更强第一次复习之后，可以间隔更长的时间来回顾：1个小时后复习一次，之后是分别在1天、3天、7天、14天、21天、28天、2个月、3个月之后再复习一次，然后这些内容就永远地储存在你的大脑里了。在最开始的72个小时内记忆会更深刻，关联性也会更强第一次复习之后，可以间隔更长的时间来回顾：1个小时后复习一次，之后是分别在1天、3天、7天、14天、21天、28天、2个月、3个月之后再复习一次，然后这些内容就永远地储存在你的大脑里了。在最开始的72个小时内记忆会更深刻，关联性也会更强第一次复习之后，可以间隔更长的时间来回顾：1个小时后复习一次，之后是分别在1天、3天、7天、14天、21天、28天、2个月、3个月之后再复习一次，然后这些内容就永远地储存在你的大脑里了。在最开始的72个小时内记忆会更深刻，关联性也会更强第一次复习之后，可以间隔更长的时间来回顾：1个小时后复习一次，之后是分别在1天、3天、7天、14天、21天、28天、2个月、3个月之后再复习一次，然后这些内容就永远地储存在你的大脑里了。在最开始的72个小时内记忆会更深刻，关联性也会更强第一次复习之后，可以间隔更长的时间来回顾：1个小时后复习一次，之后是分别在1天、3天、7天、14天、21天、28天、2个月、3个月之后再复习一次，然后这些内容就永远地储存在你的大脑里了。在最开始的72个小时内记忆会更深刻，关联性也会更强第一次复习之后，可以间隔更长的时间来回顾：1个小时后复习一次，之后是分别在1天、3天、7天、14天、21天、28天、2个月、3个月之后再复习一次，然后这些内容就永远地储存在你的大脑里了。在最开始的72个小时内记忆会更深刻，关联性也会更强第一次复习之后，可以间隔更长的时间来回顾：1个小时后复习一次，之后是分别在1天、3天、7天、14天、21天、28天、2个月、3个月之后再复习一次，然后这些内容就永远地储存在你的大脑里了。在最开始的72个小时内记忆会更深刻，关联性也会更强第一次复习之后，可以间隔更长的时间来回顾：1个小时后复习一次，之后是分别在1天、3天、7天、14天、21天、28天、2个月、3个月之后再复习一次，然后这些内容就永远地储存在你的大脑里了。在最开始的72个小时内记忆会更深刻，关联性也会更强',
            );
          });
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
