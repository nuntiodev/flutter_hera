import 'dart:async';

import 'package:dart_blocks/dart_blocks/models/auth.dart';
import 'package:dart_blocks/dart_blocks/nuntio_client.dart';
import 'package:dart_blocks/dart_blocks/user_block_with_ui/NoConnection/no_connection.dart';
import 'package:dart_blocks/dart_blocks/user_block_with_ui/WelcomePage/welcome_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:nuntio_blocks/block_user.pb.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class UserBlockWithUI extends StatefulWidget {
  UserBlockWithUI({
    Key? key,
    required this.child,
    this.createdBy,
    this.welcomeTitle,
    this.welcomeDetails,
    this.loginButtonText,
    this.registerButtonText,
    this.onLogin,
    this.emailLoginHint,
    this.passwordLoginHint,
    this.emailRegisterHint,
    this.passwordRegisterHint,
    this.loginDetails,
    this.registerDetails,
    this.primaryColor,
    this.secondaryColor,
    this.onRegister,
    this.repeatPasswordRegisterHint,
    this.loginTitle,
    this.registerTitle,
    this.textFieldBorder,
    this.textFieldColor,
    this.logo,
    this.background,
    this.validatePassword,
    this.disableRegistration,
    this.missingEmailTitle,
    this.missingEmailDetails,
    this.missingPasswordTitle,
    this.missingPasswordDetails,
    this.passwordDoNotMatchTitle,
    this.passwordDoNotMatchDetails,
    this.invalidTitle,
    this.invalidDetails,
    this.errorColor,
    this.successColor,
    this.containsEightCharactersText,
    this.containsNumberText,
    this.passwordMatchText,
    this.containsSpecialText,
    this.noConnectionTitle,
    this.noConnectionDetails,
    this.forgotPasswordText,
    this.buttonHeight,
    this.buttonWidth,
  }) : super(key: key);

  // general
  final Widget child;
  final Widget? logo;
  final Widget? createdBy;
  final Color? primaryColor;
  final Color? secondaryColor;
  final BoxDecoration? background;
  final Border? textFieldBorder;
  final Color? textFieldColor;
  final double? buttonHeight;
  final double? buttonWidth;

  // error messages
  final String? missingEmailTitle;
  final String? missingEmailDetails;
  final String? missingPasswordTitle;
  final String? missingPasswordDetails;
  final String? invalidTitle;
  final String? invalidDetails;
  final String? passwordDoNotMatchTitle;
  final String? passwordDoNotMatchDetails;

  // no connection
  final Widget? noConnectionTitle;
  final Widget? noConnectionDetails;

  // welcome
  final Widget? welcomeTitle;
  final Widget? welcomeDetails;

  // login
  final Widget? loginButtonText;
  final Widget? loginDetails;
  final Function? onLogin;
  final String? emailLoginHint;
  final String? passwordLoginHint;
  final Widget? loginTitle;
  final Widget? forgotPasswordText;

  // register
  final bool? disableRegistration;
  final bool? validatePassword;
  final Widget? registerButtonText;
  final Widget? registerDetails;
  final Function? onRegister;
  final String? emailRegisterHint;
  final String? passwordRegisterHint;
  final String? repeatPasswordRegisterHint;
  final Widget? registerTitle;
  final Widget? containsEightCharactersText;
  final Widget? containsNumberText;
  final Widget? containsSpecialText;
  final Widget? passwordMatchText;
  final Color? successColor;
  final Color? errorColor;

  // on authenticated go to child;
  @override
  State<UserBlockWithUI> createState() => _UserBlockWithUIState();
}

class _UserBlockWithUIState extends State<UserBlockWithUI>
    with WidgetsBindingObserver {
  // todo: use Extended() to make better use of space

  // init
  late Future<AuthState> isAuthenticatedFuture;
  late Timer? _timer;
  final String _activeKeySeconds = "nuntio-blocks-active-seconds";
  final String _activeKeyId = "nuntio-blocks-active-id";
  final String _activeKeyUserId = "nuntio-blocks-active-user-id";

  // _activeId is used to record how long user is active
  String _activeId = "";

  Future<AuthState> getIsAuthenticated() async {
    final _prefs = await SharedPreferences.getInstance();
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

  void _measureUserTime() async {
    SharedPreferences _prefs = await SharedPreferences.getInstance();
    // init new values
    const int _interval = 2;
    int _current = 0;
    _activeId = Uuid().v4();
    // every 1 seconds record time time. Send average of these every 5 minute to server.
    _timer = Timer.periodic(Duration(seconds: _interval), (timer) async {
      User _currentUser = await NuntioClient.userBlock.getCurrentUser();
      if (_currentUser.id != "" && _activeId != "") {
        if ((_prefs.getString(_activeKeyUserId) ?? "") == "") {
          await _prefs.setString(_activeKeyUserId, _currentUser.id);
          await _prefs.setString(_activeKeyId, _activeId);
        }
        _current += _interval;
        await _prefs.setInt(_activeKeySeconds, _current);
      }
    });
  }

  _UserBlockWithUIState() {
    isAuthenticatedFuture = getIsAuthenticated();
  }

  @override
  void initState() {
    WidgetsBinding.instance?.addObserver(this);
    _measureUserTime();
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance?.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.paused) {
      SharedPreferences _prefs = await SharedPreferences.getInstance();
      // check if previous session has id
      final _prevTotalSeconds = _prefs.getInt(_activeKeySeconds) ?? 0;
      final _prevActiveId = _prefs.getString(_activeKeyId) ?? "";
      final _prevActiveUserId = _prefs.getString(_activeKeyUserId) ?? "";
      await NuntioClient.userBlock.recordActiveMeasurement(
          _prevTotalSeconds, _prevActiveId, _prevActiveUserId);
      await _prefs.remove(_activeKeySeconds);
      await _prefs.remove(_activeKeyId);
      await _prefs.remove(_activeKeyUserId);
      if(_timer != null){
        _timer?.cancel();
      }
    } else if (state == AppLifecycleState.resumed) {
      _measureUserTime();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Colors.white,
      child: FutureBuilder<AuthState>(
          future: isAuthenticatedFuture,
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
                    disableRegistration: widget.disableRegistration ?? false,
                    validatePassword: widget.validatePassword ?? true,
                    textFieldColor: widget.textFieldColor ?? Colors.white,
                    textFieldBorder: widget.textFieldBorder ??
                        Border.all(
                          color: Colors.black26,
                          width: 0.5,
                        ),
                    forgotPasswordText: widget.forgotPasswordText ??
                        Text(
                          "Forgot your password?",
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
                    background:
                        widget.background ?? BoxDecoration(color: Colors.white),
                    primaryColor: widget.primaryColor ?? Colors.black,
                    secondaryColor: widget.secondaryColor ?? Color(0xff2862FF),
                    welcomeDetails: widget.welcomeDetails ??
                        Text(
                          "Already have an account? Awesome, come on in. Else, Create one below and let's get you started.",
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(color: Colors.black),
                          textAlign: TextAlign.center,
                        ),
                    createdBy: widget.createdBy ??
                        Text(
                          "Powered by Nuntio",
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(color: Colors.black),
                        ),
                    welcomeTitle: widget.welcomeTitle ??
                        Text(
                          "Welcome to Nuntio",
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(color: Colors.black),
                        ),
                    loginButtonText: widget.loginButtonText ?? Text("Login"),
                    registerButtonText: widget.registerButtonText ??
                        Text(
                          "Register",
                        ),
                    loginDetailsTitle: widget.loginDetails ??
                        Text(
                          "Fill in the details below to sign in",
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(color: Colors.black),
                          textAlign: TextAlign.center,
                        ),
                    onLogin: () => {
                      if (widget.onLogin != null) {widget.onLogin!()},
                      setState(() {
                        isAuthenticatedFuture =
                            getIsAuthenticated().then((isAuthenticated) {
                          if (isAuthenticated == AuthState.authenticated) {
                            Navigator.pop(context);
                          }
                          return isAuthenticated;
                        });
                      }),
                    },
                    loginTitle: widget.loginTitle ??
                        Text(
                          "Login",
                          style: TextStyle(color: Colors.black),
                        ),
                    registerTitle: widget.registerTitle ??
                        Text(
                          "Register",
                          style: TextStyle(color: Colors.black),
                        ),
                    passwordLoginHint:
                        widget.passwordLoginHint ?? "Enter your password",
                    emailLoginHint: widget.emailLoginHint ?? "Enter your email",
                    onRegister: () => {
                      if (widget.onRegister != null) {widget.onRegister!()},
                      setState(() {
                        isAuthenticatedFuture =
                            getIsAuthenticated().then((isAuthenticated) {
                          if (isAuthenticated == AuthState.authenticated) {
                            Navigator.pop(context);
                          }
                          return isAuthenticated;
                        });
                      }),
                    },
                    registerDetails: widget.registerDetails ??
                        Text(
                          "Fill in the details below to create an account",
                          style: Theme.of(context)
                              .textTheme
                              .titleMedium
                              ?.copyWith(color: Colors.black),
                        ),
                    passwordRegisterHint: widget.passwordRegisterHint ??
                        "Enter a password for your account",
                    repeatPasswordRegisterHint:
                        widget.repeatPasswordRegisterHint ??
                            "Repeat your password",
                    emailRegisterHint: widget.emailRegisterHint ??
                        "Enter an email for your account",
                    missingPasswordTitle:
                        widget.missingPasswordTitle ?? 'Missing password',
                    missingPasswordDetails: widget.missingPasswordTitle ??
                        'Please enter a password to login or register.',
                    missingEmailTitle: "Missing email",
                    missingEmailDetails:
                        'Please enter an email to login or register.',
                    invalidTitle: "Something went wrong",
                    invalidDetails:
                        "Please make sure that you have entered a valid email and password.",
                    passwordDoNotMatchTitle: "Password do not match",
                    passwordDoNotMatchDetails:
                        "Password and reapet-password do not match.",
                    errorColor: widget.errorColor ?? Colors.redAccent,
                    successColor: widget.successColor ?? Color(0xff2862FF),
                    containsEightCharactersText:
                        widget.containsEightCharactersText ??
                            Text(
                              "Password must contain at least 8 chars",
                              style: Theme.of(context)
                                  .textTheme
                                  .bodyText1
                                  ?.copyWith(color: Colors.black),
                            ),
                    containsSpecialText: widget.containsSpecialText ??
                        Text(
                          "Password must contain a special char",
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              ?.copyWith(color: Colors.black),
                        ),
                    containsNumberText: widget.containsNumberText ??
                        Text(
                          "Password must contain a number",
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              ?.copyWith(color: Colors.black),
                        ),
                    passwordMatchText: widget.passwordMatchText ??
                        Text(
                          "The two passwords match",
                          style: Theme.of(context)
                              .textTheme
                              .bodyText1
                              ?.copyWith(color: Colors.black),
                        ),
                  );
                } else {
                  print(snapshot.data);
                  return NoConnection(
                    createdBy: widget.createdBy ??
                        Text(
                          "Powered by Nuntio",
                          style: Theme.of(context)
                              .textTheme
                              .titleSmall
                              ?.copyWith(color: Colors.black),
                        ),
                    title: widget.noConnectionTitle ??
                        Text(
                          "No wifi or cellular connection",
                          style: Theme.of(context)
                              .textTheme
                              .titleLarge
                              ?.copyWith(color: Colors.black),
                          textAlign: TextAlign.center,
                        ),
                    details: widget.noConnectionDetails ??
                        Text(
                          "We cannot authenticate you without a connection",
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
                    background:
                        widget.background ?? BoxDecoration(color: Colors.white),
                    primaryColor: widget.primaryColor ?? Colors.black,
                  );
                }
              default:
                return Text("Error");
            }
          }),
    );
  }
}
