import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_webview_plugin/flutter_webview_plugin.dart';
import 'package:provider/provider.dart';
import 'package:seal_note/data/appstate/AppState.dart';
import 'package:seal_note/data/appstate/GlobalState.dart';
import 'package:seal_note/data/appstate/ViewAgreementPageChangeNotifier.dart';
import 'package:seal_note/ui/NoteDetailPage.dart';
import 'package:seal_note/ui/authentications/ViewAgreementPage.dart';
import 'package:seal_note/ui/common/RoundCornerButtonWidget.dart';
import 'package:seal_note/ui/common/checkboxs/CheckBoxWidget.dart';
import 'package:seal_note/ui/common/checkboxs/RoundCheckBoxWidget.dart';
import 'package:seal_note/util/dialog/FlushBarHandler.dart';

class LoginPage extends StatefulWidget {
  LoginPage({
    Key key,
  }) : super(key: key);

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> {
  bool _isLoginButtonDisabled = false;
  bool _hasCheckedAgreement = true;
  bool _shouldShowErrorPanel = false;

  double _loginPageWidth = 0.0;
  double _fontSizeForErrorPanel = 14.0;
  double _defaultLoginPageWidth = double.infinity;
  int _durationMillisecondsToShowViewAgreementPage = 250;

  @override
  void initState() {
    _loginPageWidth = _defaultLoginPageWidth;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      // constraints: BoxConstraints.expand(),
      width: _loginPageWidth,
      color: GlobalState.themeGreyColorAtiOSTodoForBackground,
      child: Stack(
        children: [
          Container(
            // color: Colors.red,
            height: GlobalState.screenHeight,
            child: Column(
              children: [
                Expanded(
                  child: Container(
                    // color: Colors.green,
                    alignment: Alignment.center,
                    child: SingleChildScrollView(
                      // physics: AlwaysScrollableScrollPhysics(),
                      physics: ClampingScrollPhysics(),
                      scrollDirection: Axis.vertical,
                      child: Container(
                        // color: Colors.red,

                        alignment: Alignment.center,
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Image.asset(
                              'assets/appImages/flutter-icon.png',
                              width: 200,
                              height: 200,
                            ),
                            Container(
                              alignment: Alignment.center,
                              // color: Colors.red,
                              height: 50,
                              child: Text(
                                '让学习不再遗忘',
                                style: TextStyle(
                                    fontSize: 20.0, fontFamily: '微软雅黑'),
                              ),
                            )
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                // Container(color: Colors.yellow,width: 200,height: 50,),
                AnimatedCrossFade(
                  crossFadeState: _shouldShowErrorPanel
                      ? CrossFadeState.showSecond
                      : CrossFadeState.showFirst,
                  duration: const Duration(milliseconds: 500),
                  firstChild: Container(),
                  secondChild: Container(
                    decoration: BoxDecoration(
                      color: GlobalState.themeLightBlueColorAtiOSTodo,
                      // color: Colors.red,
                      // borderRadius:
                      //     const BorderRadius.all(const Radius.circular(GlobalState.borderRadius15)),
                    ),
                    alignment: Alignment.center,
                    height: 30,
                    margin: EdgeInsets.only(
                      left: GlobalState
                              .defaultLeftAndRightMarginBetweenParentBoarderAndPanel *
                          2,
                      right: GlobalState
                              .defaultLeftAndRightMarginBetweenParentBoarderAndPanel *
                          2,
                    ),
                    // color: GlobalState.themeLightBlueColorAtiOSTodo,
                    child: Text(
                      // show login error info // login error label
                      // login error info // login error widget

                      '请选择同意协议',
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: _fontSizeForErrorPanel,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                // login wx button // login WeChat button
                // wx login button // login button
                RoundCornerButtonWidget(
                  buttonText: '微信登录',
                  buttonTextColor: GlobalState.themeWhiteColorAtiOSTodo,
                  buttonBorderColor: GlobalState.themeGreenColorAtWeChat,
                  buttonPaddingColor: GlobalState.themeGreenColorAtWeChat,
                  topMargin: 5.0,
                  bottomMargin: 15.0,
                  buttonHeight: 50.0,
                  isDisabled: _isLoginButtonDisabled,
                  buttonCallback: () async {
                    // click on login button // click wx login button
                    // click on wx login button

                    if (_hasCheckedAgreement) {
                      hideLoginPage(forceToShowWebView: true);

                      _shouldShowErrorPanel = false;

                      GlobalState.isLoggedIn = true;

                      GlobalState.masterDetailPageState.currentState
                          .triggerSetState();
                      print(
                        '微信登录成功！',
                      );
                    } else {
                      GlobalState.viewAgreementPageChangeNotifier
                          .shouldAvoidTransitionEffect = true;

                      showErrorPanel(shouldTriggerSetState: true);

                      print('请选择协议');
                    }
                  },
                ),
                Container(
                  alignment: Alignment.topCenter,
                  margin: EdgeInsets.only(
                      left: GlobalState
                          .defaultLeftAndRightMarginBetweenParentBoarderAndPanel,
                      right: GlobalState
                          .defaultLeftAndRightMarginBetweenParentBoarderAndPanel),
                  height: 50,
                  // width: 200,
                  // color: Colors.red,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // login checkbox // agreement checkbox
                      // checkbox agreement // check agreement
                      RoundCheckBoxWidget(
                        isChecked: _hasCheckedAgreement,
                        onChanged: (isChecked) {
                          GlobalState.viewAgreementPageChangeNotifier
                              .shouldAvoidTransitionEffect = true;
                          _checkLoginCheckBox(hasCheckedAgreement: isChecked);
                        },
                      ),

                      // agreement info // agreement label
                      Container(
                        // color: Colors.yellow,
                        width: GlobalState.screenWidth -
                            GlobalState
                                    .defaultLeftAndRightMarginBetweenParentBoarderAndPanel *
                                2 -
                            GlobalState.defaultCheckBoxWidth,
                        child: Row(
                          children: [
                            Container(
                              child: _getAgreementTitle(
                                  title: '已阅并同意 ', clickable: false),
                              // width: 50,
                            ),
                            Container(
                              // color: Colors.green,
                              child: Row(
                                children: [
                                  _getAgreementTitle(
                                      // title: '软件许可', clickable: true),
                                      title: '软件许可',
                                      clickable: true),
                                  _getAgreementTitle(
                                      title: ' 和 ', clickable: false),
                                  _getAgreementTitle(
                                      title: '服务协议', clickable: true),
                                ],
                              ),
                            ),
                            // _getAgreementTitle(
                            //     title: '『海豚笔记』软件许可', clickable: true),
                            // _getAgreementTitle(title: ' 和 ', clickable: false),
                            // _getAgreementTitle(title: '服务协议', clickable: true),
                          ],
                        ),
                      )
                    ],
                  ),
                ),
              ],
            ),
          ),

          // view agreement page consume
          Consumer<ViewAgreementPageChangeNotifier>(
              builder: (cxt, viewAgreementPageChangeNotifier, child) {
            var _fromDy = 0.0;
            var _toDy = 1.0;

            if (viewAgreementPageChangeNotifier.shouldShowViewAgreementPage) {
              _fromDy = 1.0;
              _toDy = 0.0;
            }

            // If it is the first time to load the view agreement page, don't transmit it
            if (viewAgreementPageChangeNotifier.shouldAvoidTransitionEffect) {
              _fromDy = 1.0;
              _toDy = 1.0;
            }

            return SlideTransition(
              // Note detail page
              position:
                  GlobalState.masterDetailPageState.currentState.getAnimation(
                fromDx: 0.0,
                toDx: 0.0,
                fromDy: _fromDy,
                toDy: _toDy,
                durationMilliseconds:
                    _durationMillisecondsToShowViewAgreementPage,
              ),
              transformHitTests: true,
              textDirection: TextDirection.ltr,
              child: ViewAgreementPage(
                title: viewAgreementPageChangeNotifier.title,
              ),
            );
          }),

          // ViewAgreementPage(),
          // login page webview
          // ViewAgreementPage(),
          // Container(
          //   color: Colors.green,
          //   width: 500,
          //   height: 500,
          //   // child: WebView(
          //   //   initialUrl: 'https://www.baidu.com',
          //   // ),
          // ),
        ],
      ),
    );
  }

  // Public methods
  void triggerSetState({
    @required bool isLoginButtonDisabled,
    @required bool hasCheckedAgreement,
  }) {
    setState(() {
      _isLoginButtonDisabled = isLoginButtonDisabled;
      _hasCheckedAgreement = hasCheckedAgreement;
    });
  }

  void showLoginPage() {
    setState(() {
      _loginPageWidth = _defaultLoginPageWidth;
      GlobalState.noteDetailWidgetState.currentState
          .hideWebView(forceToSyncWithShouldHideWebViewVar: false);
    });
  }

  void hideLoginPage({
    bool forceToShowWebView = true,
  }) {
    setState(() {
      _loginPageWidth = 0.0;
      if (forceToShowWebView) {
        GlobalState.noteDetailWidgetState.currentState
            .showWebView(forceToSyncWithShouldHideWebViewVar: true);
      } else {
        // Timer(const Duration(seconds: 3), () {
        //   GlobalState.noteDetailWidgetState.currentState
        //       .hideWebView(forceToSyncWithShouldHideWebViewVar: false);
        // });

        GlobalState.noteDetailWidgetState.currentState
            .hideWebView(forceToSyncWithShouldHideWebViewVar: true);
      }
    });
  }

  void showErrorPanel({
    int millisecondToHide = 2000,
    bool shouldTriggerSetState = true,
  }) {
    _shouldShowErrorPanel = true;

    Timer(Duration(milliseconds: millisecondToHide), () {
      // Don't trigger the method to hide error panel when View Agreement Page is being shown
      // So that no duplicate calls are made
      if (!GlobalState
          .viewAgreementPageChangeNotifier.shouldShowViewAgreementPage) {
        hideErrorPanel(shouldTriggerSetState: shouldTriggerSetState);
      }
    });

    if (shouldTriggerSetState) {
      setState(() {});
    }
  }

  void hideErrorPanel({
    bool shouldTriggerSetState = true,
  }) {
    _shouldShowErrorPanel = false;

    if (shouldTriggerSetState) {
      setState(() {});
    }
  }

  // Private methods
  void _checkLoginCheckBox({
    @required bool hasCheckedAgreement,
  }) {
    var isLoginButtonDisabled = true;

    if (hasCheckedAgreement) {
      isLoginButtonDisabled = false;
    }

    triggerSetState(
      isLoginButtonDisabled: isLoginButtonDisabled,
      hasCheckedAgreement: hasCheckedAgreement,
    );
  }

  Widget _getAgreementTitle({
    @required String title,
    bool clickable = false,
  }) {
    // agreement title control // agreement title widget

    Widget theText = Text(
      title,
      overflow: TextOverflow.ellipsis,
      style: TextStyle(
        fontSize: 13.0,
        color: (clickable)
            ? GlobalState.themeBlueColor
            : GlobalState.themeBlackColor87ForFontForeColor,
      ),
    );

    if (clickable) {
      return GestureDetector(
        child: theText,
        onTap: () async {
          // click on agreement title // click agreement title
          // show agreement page event // show view agreement page

          GlobalState.viewAgreementPageChangeNotifier
              .shouldAvoidTransitionEffect = false;

          GlobalState.viewAgreementPageChangeNotifier.title = title;

          GlobalState.viewAgreementPageChangeNotifier.showViewAgreementPage();

          // GlobalState.masterDetailPageState.currentState
          //     .triggerToShowReusablePage(
          //   title: '用户协议',
          //   child: ViewAgreementPage(),
          // );
          //
          // hideLoginPage(forceToShowWebView: false);
        },
      );
    } else {
      return theText;
    }
  }
}
