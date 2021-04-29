import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:seal_note/data/appstate/GlobalState.dart';
import 'package:seal_note/data/appstate/LoadingWidgetChangeNotifier.dart';
import 'package:seal_note/data/appstate/ViewAgreementPageChangeNotifier.dart';
import 'package:seal_note/ui/authentications/ViewAgreementPage.dart';
import 'package:seal_note/ui/common/RoundCornerButtonWidget.dart';
import 'package:seal_note/ui/common/checkboxs/RoundCheckBoxWidget.dart';
import 'package:seal_note/util/dialog/AlertDialogHandler.dart';
import 'package:seal_note/util/networks/NetworkHandler.dart';

import 'package:after_layout/after_layout.dart';
import 'package:seal_note/util/tcb/TCBLoginHandler.dart';

class LoginPage extends StatefulWidget {
  LoginPage({
    Key key,
    this.shouldShow,
  }) : super(key: key);

  final bool shouldShow;

  @override
  LoginPageState createState() => LoginPageState();
}

class LoginPageState extends State<LoginPage> with AfterLayoutMixin<LoginPage> {
  bool _isLoginButtonDisabled = false;
  bool _hasCheckedAgreement = true;
  bool _shouldShowErrorPanel = false;

  double _loginPageWidth = 0.0;
  double _fontSizeForErrorPanel = 14.0;
  double _defaultLoginPageWidth = double.infinity;
  int _durationMillisecondsToShowViewAgreementPage = 250;

  String _errorInfo = '';
  String _errorInfoForNotSelectAgreement = '请选择同意协议';
  String _errorInfoForNetworkProblem = '请打开网络';
  String _errorInfoForLoginFailure = '登录失败，请重试';
  bool _isWaitingNetworkToBecomeNormal = false;

  bool _isLoginPageReady = false;

  // Timer _timer;

  @override
  void initState() {
    // _hasNetwork = widget.hasNetwork;

    // Timer(const Duration(seconds: 5), () {
    //   GlobalState.loginPageState.currentState.showErrorPanel(
    //     errorInfo: '网络',
    //     autoHide: false,
    //   );
    // });

    if (widget.shouldShow) {
      _loginPageWidth = _defaultLoginPageWidth;
    } else {
      _loginPageWidth = 0.0;
    }

    // _loginPageWidth = _defaultLoginPageWidth;
    super.initState();
  }

  @override
  void dispose() {
    // _timer?.cancel();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  @override
  void didUpdateWidget(covariant LoginPage oldWidget) {
    // TODO: implement didUpdateWidget
    if (_isLoginPageReady && !GlobalState.isLoggedIn) {
      var s = 'd';
      showErrorPanelWhenNetworkProblem();
    }

    super.didUpdateWidget(oldWidget);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: _loginPageWidth,
      // width: 0.0,
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
                                '让学习不遗忘',
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
                      // show error info // show wx login info

                      _errorInfo,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        fontSize: _fontSizeForErrorPanel,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),

                // login loading widget // loading widget
                // Container(color: Colors.red,width: 50,height: 50,),
                Consumer<LoadingWidgetChangeNotifier>(
                    builder: (cxt, loadingWidgetChangeNotifier, child) {
                  var shouldShowLoading =
                      loadingWidgetChangeNotifier.shouldShowLoadingWidget;

                  if (shouldShowLoading) {
                    return Padding(
                      padding: const EdgeInsets.only(
                        bottom: GlobalState.defaultVerticalMarginBetweenItems,
                      ),
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return Container();
                  }
                }),

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
                    // click on wx login button // click login button
                    // click on wx button // click wx button

                    // var login = await TCBLoginHandler.login();

                    // await Future.delayed(Duration(seconds: 3));

                    // Check network connection
                    GlobalState.hasNetwork =
                        await NetworkHandler.hasNetworkConnection();

                    if (!_hasCheckedAgreement) {
                      showErrorPanel(
                        errorInfo: _errorInfoForNotSelectAgreement,
                        autoHide: true,
                        shouldTriggerSetState: true,
                      );
                    } else if (!GlobalState.hasNetwork) {
                      // Check if it has network // has network or not

                      await showErrorPanelWhenNetworkProblem(
                          forceToCheckNetwork: false);
                    } else {
                      // All login checks pass

                      GlobalState.loadingWidgetChangeNotifier
                          .shouldShowLoadingWidget = true;

                      var responseModel = await TCBLoginHandler.login(
                        autoUseAnonymousWayToLoginInSimulator: true,
                      );

                      if (responseModel.code == 0) {
                        GlobalState.loadingWidgetChangeNotifier
                            .shouldShowLoadingWidget = false;

                        hideLoginPage(forceToShowWebView: true);

                        _shouldShowErrorPanel = false;

                        GlobalState.isLoggedIn = true;

                        GlobalState.masterDetailPageState.currentState
                            .triggerSetState();
                      } else {
                        showErrorPanel(
                          errorInfo: _errorInfoForLoginFailure,
                          autoHide: true,
                        );
                      }

                      // if (GlobalState.isLoggedIn) {
                      //   // GlobalState.loadingWidgetChangeNotifier
                      //   //     .shouldShowLoadingWidget = false;
                      //   //
                      //   // hideLoginPage(forceToShowWebView: true);
                      //   //
                      //   // _shouldShowErrorPanel = false;
                      //   //
                      //   // GlobalState.isLoggedIn = true;
                      //   //
                      //   // GlobalState.masterDetailPageState.currentState
                      //   //     .triggerSetState();
                      // } else {
                      //   showErrorPanel(
                      //     errorInfo: GlobalState.errorMsg,
                      //     autoHide: true,
                      //   );
                      // }
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
                // GestureDetector(
                //   child: Container(
                //     color: Colors.red,
                //     width: 50,
                //     height: 50,
                //   ),
                //   onTap: () async {
                //     hideErrorPanel();
                //   },
                // ),
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

  Future<void> showLoginPage() async {
    var isReviewApp = await GlobalState.checkIfReviewApp();

    setState(() {
      // If it is a review app, don't show login page any way
      if (isReviewApp) {
        _loginPageWidth = 0.0;
      } else {
        _loginPageWidth = _defaultLoginPageWidth;
      }

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
        GlobalState.noteDetailWidgetState.currentState
            .hideWebView(forceToSyncWithShouldHideWebViewVar: true);
      }
    });
  }

  void showErrorPanel({
    @required String errorInfo,
    bool autoHide = true,
    bool shouldTriggerSetState = true,
  }) {
    _shouldShowErrorPanel = true;
    _errorInfo = errorInfo;

    GlobalState.viewAgreementPageChangeNotifier.shouldAvoidTransitionEffect =
        true;

    if (autoHide) {
      Timer(Duration(milliseconds: 2000), () {
        // Don't trigger the method to hide error panel when View Agreement Page is being shown
        // So that no duplicate calls are made
        if (!GlobalState
            .viewAgreementPageChangeNotifier.shouldShowViewAgreementPage) {
          hideErrorPanel(shouldTriggerSetState: shouldTriggerSetState);
        }
      });
    }

    if (shouldTriggerSetState) {
      setState(() {});
    }
  }

  Future<void> showErrorPanelWhenNetworkProblem({
    bool forceToCheckNetwork = true,
    bool checkNetworkPeriodically = true,
  }) async {
    if (forceToCheckNetwork) {
      GlobalState.hasNetwork = await NetworkHandler.hasNetworkConnection();
    }

    var s = 's';

    if (!GlobalState.hasNetwork) {
      showErrorPanel(
        errorInfo: _errorInfoForNetworkProblem,
        autoHide: false,
        shouldTriggerSetState: true,
      );

      if (!_isWaitingNetworkToBecomeNormal) {
        _isWaitingNetworkToBecomeNormal = true;

        if (checkNetworkPeriodically) {
          NetworkHandler.checkNetworkPeriodically(
              callbackWhenHasNetwork: () async {
            _isWaitingNetworkToBecomeNormal = false;
            hideErrorPanel();
          });
        }
      }
    }
  }

  // void showErrorPanelForNetworkProblemAndCheckNetworkPeriodically() {
  //   if (!_isWaitingNetworkToBecomeNormal) {
  //     _isWaitingNetworkToBecomeNormal = true;
  //
  //     showErrorPanel(
  //       errorInfo: _errorInfoForNetworkProblem,
  //       autoHide: false,
  //       shouldTriggerSetState: true,
  //     );
  //
  //     NetworkHandler.checkNetworkPeriodically(callbackWhenHasNetwork: () async {
  //       _isWaitingNetworkToBecomeNormal = false;
  //       hideErrorPanel();
  //     });
  //   }
  // }

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
        },
      );
    } else {
      return theText;
    }
  }

  // Future<void> _executeLogin()async{
  //   await Future.delayed(Duration(seconds: 3));
  //
  //   var s ='s';
  // }

  @override
  void afterFirstLayout(BuildContext context) {
    _isLoginPageReady = true;
  }
}
