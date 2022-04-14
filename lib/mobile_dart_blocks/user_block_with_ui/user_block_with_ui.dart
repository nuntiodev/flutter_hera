import 'package:dart_blocks/mobile_dart_blocks/softcorp_client.dart';
import 'package:dart_blocks/mobile_dart_blocks/user_block_with_ui/WelcomePage/welcome_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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

  // error messages
  final String? missingEmailTitle;
  final String? missingEmailDetails;
  final String? missingPasswordTitle;
  final String? missingPasswordDetails;
  final String? invalidTitle;
  final String? invalidDetails;
  final String? passwordDoNotMatchTitle;
  final String? passwordDoNotMatchDetails;

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

  // on authenticated go to child;
  @override
  State<UserBlockWithUI> createState() => _UserBlockWithUIState();
}

class _UserBlockWithUIState extends State<UserBlockWithUI> {
  // init
  late Future<bool> isAuthenticatedFuture;

  Future<bool> getIsAuthenticated() async {
    return await SoftcorpClient.userBlock.isAuthenticated();
  }

  _UserBlockWithUIState() {
    isAuthenticatedFuture = getIsAuthenticated();
  }

  // todo: implement no wifi connection
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      child: FutureBuilder<bool>(
          future: isAuthenticatedFuture,
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const Center(
                  child: CupertinoActivityIndicator(),
                );
              case ConnectionState.done:
                return AnimatedSwitcher(
                  duration: const Duration(milliseconds: 500),
                  child: snapshot.data ?? false
                      ? widget.child
                      : WelcomePage(
                          disableRegistration:
                              widget.disableRegistration ?? false,
                          validatePassword: widget.validatePassword ?? true,
                          textFieldColor: widget.textFieldColor ?? Colors.white,
                          textFieldBorder: widget.textFieldBorder ??
                              Border.all(
                                color: Colors.black26,
                                width: 0.5,
                              ),
                          logo: widget.logo ??
                              Padding(
                                padding: EdgeInsets.only(top: 20, bottom: 80),
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
                          loginButtonText:
                              widget.loginButtonText ?? Text("Login"),
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
                                if (isAuthenticated == true) {
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
                          emailLoginHint:
                              widget.emailLoginHint ?? "Enter your email",
                          onRegister: widget.onRegister ?? () => {},
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
                              "You might have entered an invalid email or password.",
                          passwordDoNotMatchTitle: "Password do not match",
                          passwordDoNotMatchDetails:
                              "Password and reapet-password do not match.",
                        ),
                );
              default:
                return Text('Error: ${snapshot.error}');
            }
          }),
    );
  }
}
