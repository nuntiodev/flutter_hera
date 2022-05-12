import 'package:dart_blocks/dart_blocks/components/text_field_decoration.dart';
import 'package:dart_blocks/dart_blocks/nuntio_client.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nuntio_blocks/block_user.pb.dart';

import '../verify_code_sheet/verify_code_sheet.dart';

class LoginPage extends StatefulWidget {
  LoginPage({
    Key? key,
    required this.loginButtonText,
    required this.emailHint,
    required this.passwordHint,
    required this.details,
    required this.onLogin,
    required this.logo,
    required this.title,
    required this.primaryColor,
    required this.secondaryColor,
    required this.createdBy,
    required this.background,
    required this.textFieldBorder,
    required this.textFieldColor,
    required this.missingEmailTitle,
    required this.missingEmailDetails,
    required this.missingPasswordTitle,
    required this.missingPasswordDetails,
    required this.invalidTitle,
    required this.invalidDetails,
    required this.forgotPasswordText,
    required this.buttonHeight,
    required this.buttonWidth,
    required this.arrowBackColor,
    required this.verifyCodeTitle,
  }) : super(key: key);

  final Widget loginButtonText;
  final Widget verifyCodeTitle;
  final BoxDecoration background;
  final Color primaryColor;
  final Color secondaryColor;
  final Color arrowBackColor;
  final String emailHint;
  final String passwordHint;
  final Widget details;
  final Widget logo;
  final Widget createdBy;
  final Widget title;
  final Function onLogin;
  final Border textFieldBorder;
  final Color textFieldColor;
  final Widget forgotPasswordText;
  final double buttonHeight;
  final double buttonWidth;

  final String missingEmailTitle;
  final String missingEmailDetails;
  final String missingPasswordTitle;
  final String missingPasswordDetails;
  final String invalidTitle;
  final String invalidDetails;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final verifyCodeController = TextEditingController();

  bool isLoading = false;

  loginSuccess() {
    setState(() {
      isLoading = false;
    });
    passwordController.text = "";
    emailController.text = "";
    widget.onLogin();
  }

  loginFailure() {
    setState(() {
      isLoading = false;
    });
    passwordController.text = "";
    emailController.text = "";
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: false,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: Colors.transparent,
        leading: CupertinoButton(
          child: Icon(
            Icons.arrow_back_ios,
            color: widget.arrowBackColor,
          ),
          onPressed: () => Navigator.pop(context),
        ),
        border: null,
        middle: widget.title,
      ),
      child: Container(
        decoration: widget.background,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 4,
                child: Align(
                  alignment: Alignment.center,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      widget.details,
                      const SizedBox(
                        height: 30,
                      ),
                      SizedBox(
                        height: 40,
                        child: CupertinoTextField(
                          decoration: textFieldDecoration(
                              widget.textFieldBorder, widget.textFieldColor),
                          controller: emailController,
                          placeholder: widget.emailHint,
                          keyboardType: TextInputType.emailAddress,
                        ),
                      ),
                      const SizedBox(
                        height: 15,
                      ),
                      SizedBox(
                        height: 40,
                        child: CupertinoTextField(
                          decoration: textFieldDecoration(
                              widget.textFieldBorder, widget.textFieldColor),
                          controller: passwordController,
                          obscureText: true,
                          placeholder: widget.passwordHint,
                          keyboardType: TextInputType.text,
                          maxLength: 80,
                        ),
                      ),
                      const SizedBox(
                        height: 30,
                      ),
                      SizedBox(
                        width: widget.buttonWidth,
                        height: widget.buttonHeight,
                        child: CupertinoButton(
                          color: widget.primaryColor,
                          onPressed: () {
                            if (isLoading) {
                              return;
                            }
                            if (emailController.text.isEmpty) {
                              showCupertinoDialog(
                                  context: context,
                                  builder: (context) {
                                    return CupertinoAlertDialog(
                                      title: Text(
                                        widget.missingEmailTitle,
                                      ),
                                      content: Text(
                                        widget.missingEmailDetails,
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('okay'))
                                      ],
                                    );
                                  });
                              return;
                            } else if (passwordController.text.isEmpty) {
                              showCupertinoDialog(
                                  context: context,
                                  builder: (context) {
                                    return CupertinoAlertDialog(
                                      title: Text(widget.missingPasswordTitle),
                                      content: Text(
                                        widget.missingPasswordDetails,
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('okay'))
                                      ],
                                    );
                                  });
                              return;
                            }
                            setState(() {
                              isLoading = true;
                            });
                            NuntioClient.userBlock
                                .login(
                              password: passwordController.text,
                              email: emailController.text,
                            )
                                .catchError((_) {
                              loginFailure();
                              showCupertinoDialog(
                                  context: context,
                                  builder: (context) {
                                    return CupertinoAlertDialog(
                                      title: Text(
                                        widget.invalidTitle,
                                      ),
                                      content: Text(
                                        widget.invalidDetails,
                                      ),
                                      actions: <Widget>[
                                        TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('okay'))
                                      ],
                                    );
                                  });
                            }).then((loginSession) {
                              if (loginSession.loginStatus ==
                                  LoginStatus.EMAIL_IS_NOT_VERIFIED) {
                                showCupertinoModalPopup(
                                  context: context,
                                  builder: (context) => VerifyCodeSheet(
                                    buttonHeight: widget.buttonHeight,
                                    buttonWidth: widget.buttonWidth,
                                    verifyCodeTitle: widget.verifyCodeTitle,
                                    userEmail: emailController.text,
                                    emailExpiresAt: loginSession.emailExpiresAt
                                        .toDateTime().toUtc(),
                                  ),
                                ).catchError((err) {
                                  loginFailure();
                                }).then((value) {
                                  // login again
                                  NuntioClient.userBlock
                                      .login(
                                          password: passwordController.text,
                                          email: emailController.text)
                                      .catchError((err) {
                                    loginFailure();
                                  }).then((value) {
                                    loginSuccess();
                                  });
                                });
                              } else {
                                loginSuccess();
                              }
                            });
                          },
                          child: isLoading
                              ? CupertinoActivityIndicator()
                              : widget.loginButtonText,
                        ),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      CupertinoButton(
                        child: widget.forgotPasswordText,
                        onPressed: () {},
                      ),
                    ],
                  ),
                ),
              ),
              Expanded(
                flex: 1,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: widget.createdBy,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
