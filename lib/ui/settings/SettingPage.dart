import 'dart:async';

import 'package:flutter/material.dart';
import 'package:seal_note/data/appstate/GlobalState.dart';
import 'package:seal_note/ui/common/items/ItemContentWidget.dart';

// import 'package:seal_note/ui/common/loadings/LoadingWidget.dart';
import 'package:seal_note/ui/common/panels/RoundCornerPanelWidget.dart';
import 'package:seal_note/util/dialog/AlertDialogHandler.dart';
import 'package:seal_note/util/networks/NetworkHandler.dart';
import 'package:seal_note/util/tcb/TCBLoginHandler.dart';

class SettingPage extends StatefulWidget {
  @override
  _SettingPageState createState() => _SettingPageState();
}

class _SettingPageState extends State<SettingPage> {
  int _reusablePageIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (!GlobalState.isReviewApp)
          RoundCornerPanelWidget(
            // sign out button
            child: ItemContentWidget(
              itemTitle: '退出登录',
              itemTitleForeColor: Colors.red,
              centerContent: true,
            ),
            onTap: () async {
              // click on sign out // sign out wx account
              // sign out event // exit wx account
              // exit account event // signout event

              // When there is no network, failed to show it
              var hasNetwork = await NetworkHandler.hasNetworkConnection();
              if (hasNetwork) {
                // When there is network
                GlobalState.noteDetailWidgetState.currentState
                    .hideWebView(forceToSyncWithShouldHideWebViewVar: false);

                // Always to show OK button
                GlobalState.appState.enableAlertDialogOKButton = true;

                // var shouldSignOut = await AlertDialogHandler().(
                var shouldSignOut = await AlertDialogHandler().showAlertDialog(
                  parentContext: context,
                  captionText: '确定退出登录？',
                  centerRemark: true,
                  restoreWebViewToShowIfNeeded: true,
                  textForLoadingWidget: '退出并同步数据中...\n（请勿关闭App）',
                  showLoadingAfterClickingOK: true,
                  alwaysEnableOKButton: false,
                  callbackWhenExecutingLoading: _executeSyncDataWhenSignOut,
                );

                if (shouldSignOut) {
                  await TCBLoginHandler.signOutWX();

                  GlobalState.viewAgreementPageChangeNotifier
                      .shouldAvoidTransitionEffect = true;
                  GlobalState.reusablePageStackWidgetState.currentState
                      .clickOnReusablePageBackButton(
                          reusablePageIndex: _reusablePageIndex);
                  GlobalState.masterDetailPageState.currentState
                      .triggerSetState();
                  GlobalState.loginPageState.currentState.showLoginPage();
                }

              } else {
                // When there isn't network

                await AlertDialogHandler().showAlertDialog(
                  parentContext: context,
                  captionText: '网络未连接',
                  remark: '请先连接网络，以便同步数据！',
                  restoreWebViewToShowIfNeeded: true,
                  showButtonForCancel: false,
                );
              }
            },
          ),
      ],
    );
  }

  // Private methods
  Future<void> _executeSyncDataWhenSignOut() async {
    await Future.delayed(Duration(seconds: 2), () {
      var sp = 'ss';
    });
  }
}
