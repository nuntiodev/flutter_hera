import 'dart:async';
import 'package:dart_blocks/dart_blocks/models/auth.dart';
import 'package:dart_blocks/dart_blocks/nuntio_client.dart';
import 'package:dart_blocks/dart_blocks/user_analytics/user_analytics.dart';
import 'package:dart_blocks/dart_blocks/user_block_with_ui/NoConnection/no_connection.dart';
import 'package:dart_blocks/dart_blocks/user_block_with_ui/WelcomePage/welcome_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:nuntio_blocks/block_user.pb.dart';

class UserBlockWithUI extends StatefulWidget {
  UserBlockWithUI({
    Key? key,
    required this.child,
    this.primaryColor,
    this.secondaryColor,
    this.onRegister,
    this.onLogin,
    this.textFieldBorder,
    this.textFieldColor,
    this.logo,
    this.background,
    this.errorColor,
    this.successColor,
    this.buttonHeight,
    this.buttonWidth,
  }) : super(key: key);

  // general
  final Widget child;
  final Widget? logo;

  // colors
  final Color? primaryColor;
  final Color? secondaryColor;
  final Color? successColor;
  final Color? errorColor;
  final Color? textFieldColor;

  // sizes
  final double? buttonHeight;
  final double? buttonWidth;

  // style
  final BoxDecoration? background;
  final Border? textFieldBorder;

  // functions
  final Function? onRegister;
  final Function? onLogin;


  // on authenticated go to child;
  @override
  State<UserBlockWithUI> createState() => _UserBlockWithUIState();
}

class _UserBlockWithUIState extends State<UserBlockWithUI> {
  // init
  late Future<AuthState> initializeNuntioUIFuture;
  late final Config _config;

  Future<AuthState> initializeNuntioUI() async {
    _config = await NuntioClient.userBlock.getConfiguration();
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      //  no data connection
      return AuthState.noConnection;
    }
    bool isAuthenticated = await NuntioClient.userBlock.isAuthenticated();
    if (isAuthenticated) {
      return AuthState.authenticated;
    }
    return AuthState.notAuthenticated;
  }

  _UserBlockWithUIState() {
    initializeNuntioUIFuture = initializeNuntioUI();
  }


  @override
  Widget build(BuildContext context) {
    return UserAnalytics(
      child: CupertinoPageScaffold(
        backgroundColor: Colors.white,
        child: FutureBuilder<AuthState>(
            future: initializeNuntioUIFuture,
            builder: (BuildContext context, AsyncSnapshot<AuthState> snapshot) {
              switch (snapshot.connectionState) {
                case ConnectionState.waiting:
                  return const Center(
                    child: CupertinoActivityIndicator(),
                  );
                case ConnectionState.done:
                  if (snapshot.data == AuthState.authenticated) {
                    return widget.child;
                  } else if (snapshot.data == null ||
                      snapshot.data == AuthState.notAuthenticated) {
                    return WelcomePage(
                      buttonHeight: widget.buttonHeight ?? 50,
                      buttonWidth: widget.buttonWidth ?? 250,
                      disableRegistration: _config.disableDefaultSignup,
                      validatePassword: _config.validatePassword,
                      textFieldColor: widget.textFieldColor ?? Colors.white,
                      textFieldBorder: widget.textFieldBorder ??
                          Border.all(
                            color: Colors.black26,
                            width: 0.5,
                          ),
                      forgotPasswordText: Text(
                        _config.loginText.forgotPassword,
                            style: TextStyle(
                              color: widget.primaryColor,
                            ),
                          ),
                      logo: widget.logo ??
                          Padding(
                            padding: EdgeInsets.only(top: 20, bottom: 30),
                            child: Text(
                              "Move fast. Stay in control.",
                              style: Theme.of(context)
                                  .textTheme
                                  .titleLarge
                                  ?.copyWith(color: Colors.black),
                            ),
                          ),
                      background: widget.background ??
                          BoxDecoration(color: Colors.white),
                      primaryColor: widget.primaryColor ?? Colors.black,
                      secondaryColor:
                          widget.secondaryColor ?? Color(0xff2862FF),
                      welcomeDetails: Text(
                            _config.welcomeText.welcomeDetails,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(color: Colors.black),
                            textAlign: TextAlign.center,
                          ),
                      createdBy:Text(
                            _config.generalText.createdBy,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(color: Colors.black),
                          ),
                      welcomeTitle:Text(
                            _config.welcomeText.welcomeTitle,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(color: Colors.black),
                          ),
                      loginButtonText: Text(_config.loginText.loginButton),
                      registerButtonText:Text(
                            _config.registerText.registerButton,
                          ),
                      loginDetailsTitle:Text(
                            _config.loginText.loginDetails,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(color: Colors.black),
                            textAlign: TextAlign.center,
                          ),
                      onLogin: () => {
                        if (widget.onLogin != null) {widget.onLogin!()},
                        setState(() {
                          initializeNuntioUIFuture =
                              initializeNuntioUI().then((isAuthenticated) {
                            if (isAuthenticated == AuthState.authenticated) {
                              Navigator.pop(context);
                            }
                            return isAuthenticated;
                          });
                        }),
                      },
                      loginTitle:Text(
                            _config.loginText.loginTitle,
                            style: TextStyle(color: Colors.black),
                          ),
                      registerTitle:Text(
                            _config.registerText.registerTitle,
                            style: TextStyle(color: Colors.black),
                          ),
                      passwordLoginHint: _config.generalText.passwordHint,
                      emailLoginHint:_config.generalText.emailHint,
                      onRegister: () => {
                        if (widget.onRegister != null) {widget.onRegister!()},
                        setState(() {
                          initializeNuntioUIFuture =
                              initializeNuntioUI().then((isAuthenticated) {
                            if (isAuthenticated == AuthState.authenticated) {
                              Navigator.pop(context);
                            }
                            return isAuthenticated;
                          });
                        }),
                      },
                      registerDetails:Text(
                            _config.registerText.registerDetails,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(color: Colors.black),
                          ),
                      passwordRegisterHint: _config.generalText.passwordHint,
                      repeatPasswordRegisterHint: _config.registerText.repeatPasswordHint,
                      emailRegisterHint: _config.generalText.emailHint,
                      missingPasswordTitle: _config.generalText.missingPasswordTitle,
                      missingPasswordDetails: _config.generalText.missingPasswordDetails,
                      missingEmailTitle: _config.generalText.missingEmailTitle,
                      missingEmailDetails: _config.generalText.missingEmailDetails,
                      invalidTitle: _config.generalText.errorTitle,
                      invalidDetails: _config.generalText.errorDescription,
                      passwordDoNotMatchTitle: _config.registerText.passwordDoNotMatchTitle,
                      passwordDoNotMatchDetails:_config.registerText.passwordDoNotMatchDetails,
                      errorColor: widget.errorColor ?? Colors.redAccent,
                      successColor: widget.successColor ?? Color(0xff2862FF),
                      containsEightCharactersText: Text(
                                _config.registerText.containsEightChars,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyText1
                                    ?.copyWith(color: Colors.black),
                              ),
                      containsSpecialText: Text(
                            _config.registerText.containsSpecialChar,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                ?.copyWith(color: Colors.black),
                          ),
                      containsNumberText:
                          Text(
                            _config.registerText.containsNumberChar,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                ?.copyWith(color: Colors.black),
                          ),
                      passwordMatchText:
                          Text(
                            _config.registerText.passwordMustMatch,
                            style: Theme.of(context)
                                .textTheme
                                .bodyText1
                                ?.copyWith(color: Colors.black),
                          ),
                    );
                  } else {
                    print(snapshot.data);
                    return NoConnection(
                      createdBy:
                          Text(
                            _config.generalText.createdBy,
                            style: Theme.of(context)
                                .textTheme
                                .titleSmall
                                ?.copyWith(color: Colors.black),
                          ),
                      title: Text(
                            _config.generalText.noWifiTitle,
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(color: Colors.black),
                            textAlign: TextAlign.center,
                          ),
                      details: Text(
                        _config.generalText.noWifiDescription,
                            style: Theme.of(context)
                                .textTheme
                                .titleMedium
                                ?.copyWith(color: Colors.black),
                            textAlign: TextAlign.center,
                          ),
                      logo: widget.logo ??
                          Text(
                            "Move fast. Stay in control.",
                            style: Theme.of(context)
                                .textTheme
                                .titleLarge
                                ?.copyWith(color: Colors.black),
                          ),
                      background: widget.background ??
                          BoxDecoration(color: Colors.white),
                      primaryColor: widget.primaryColor ?? Colors.black,
                    );
                  }
                default:
                  return Text("Error");
              }
            }),
      ),
    );
  }
}
