import 'package:dart_blocks/dart_blocks/nuntio_client.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../components/text_field_decoration.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({
    Key? key,
    required this.logo,
    required this.title,
    required this.buttonText,
    required this.emailHint,
    required this.passwordHint,
    required this.details,
    required this.onRegister,
    required this.createdBy,
    required this.secondaryColor,
    required this.repeatPasswordHint,
    required this.background,
    required this.primaryColor,
    required this.textFieldBorder,
    required this.textFieldColor,
    required this.validatePassword,
    required this.missingEmailTitle,
    required this.missingEmailDetails,
    required this.missingPasswordTitle,
    required this.missingPasswordDetails,
    required this.invalidTitle,
    required this.invalidDetails,
    required this.passwordDoNotMatchTitle,
    required this.passwordDoNotMatchDetails,
    required this.errorColor,
    required this.successColor,
    required this.containsEightCharactersText,
    required this.containsNumberText,
    required this.containsSpecialText,
    required this.passwordMatchText,
  }) : super(key: key);

  final bool validatePassword;
  final Widget buttonText;
  final BoxDecoration background;
  final Color secondaryColor;
  final Color primaryColor;
  final Color errorColor;
  final Color successColor;
  final Widget title;
  final Widget logo;
  final Widget createdBy;
  final String emailHint;
  final String passwordHint;
  final String repeatPasswordHint;
  final Widget details;
  final Function onRegister;
  final Border textFieldBorder;
  final Color textFieldColor;
  final String missingEmailTitle;
  final String missingEmailDetails;
  final String missingPasswordTitle;
  final String missingPasswordDetails;
  final String invalidTitle;
  final String invalidDetails;
  final String passwordDoNotMatchTitle;
  final String passwordDoNotMatchDetails;
  final Widget containsEightCharactersText;
  final Widget containsSpecialText;
  final Widget containsNumberText;
  final Widget passwordMatchText;

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final repeatPasswordController = TextEditingController();

  bool isLoading = false;

  bool containsEightCharacters = false;
  bool containsNumber = false;
  bool containsSpecial = false;
  bool passwordMatch = false;

  onRepeatPasswordChange() {
    if (!widget.validatePassword) {
      return;
    }
    if (repeatPasswordController.text != "" &&
        passwordController.text != "" &&
        repeatPasswordController.text == passwordController.text) {
      setState(() {
        passwordMatch = true;
      });
    } else {
      setState(() {
        passwordMatch = false;
      });
    }
  }

  onPasswordChange() {
    if (!widget.validatePassword) {
      return;
    }
    if (passwordController.text != "") {
      if (passwordController.text.contains(RegExp(r'[0-9]'))) {
        if (!containsNumber) {
          setState(() {
            containsNumber = true;
          });
        }
      } else {
        setState(() {
          containsNumber = false;
        });
      }
      if (passwordController.text.contains(RegExp(r'[!@#$%^&*(),.?":{}|<>]'))) {
        if (!containsSpecial) {
          setState(() {
            containsSpecial = true;
          });
        }
      } else {
        setState(() {
          containsSpecial = false;
        });
      }
      if (passwordController.text.length > 8) {
        if (!containsEightCharacters) {
          setState(() {
            containsEightCharacters = true;
          });
        }
      } else {
        setState(() {
          containsEightCharacters = false;
        });
      }
    } else {
      setState(() {
        containsEightCharacters = false;
        containsNumber = false;
        passwordMatch = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: false,
      navigationBar: CupertinoNavigationBar(
        backgroundColor: Colors.transparent,
        border: null,
        middle: widget.title,
        leading: CupertinoButton(
          child: Icon(
            Icons.arrow_back_ios,
            color: widget.primaryColor,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      child: Container(
        decoration: widget.background,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              Expanded(
                flex: 5,
                child: Align(
                  alignment: Alignment.center,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      SizedBox(
                        height: 30,
                      ),
                      widget.details,
                      SizedBox(
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
                          onChanged: (_) => onPasswordChange(),
                          obscureText: true,
                          placeholder: widget.passwordHint,
                          keyboardType: TextInputType.text,
                          maxLength: 80,
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
                          controller: repeatPasswordController,
                          onChanged: (_) => onRepeatPasswordChange(),
                          obscureText: true,
                          placeholder: widget.repeatPasswordHint,
                          keyboardType: TextInputType.text,
                          maxLength: 80,
                        ),
                      ),
                      if (widget.validatePassword)
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const SizedBox(
                              height: 30,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  containsEightCharacters
                                      ? CupertinoIcons.check_mark_circled
                                      : CupertinoIcons.xmark_circle,
                                  color: containsEightCharacters
                                      ? widget.successColor
                                      : widget.errorColor,
                                  size: 15,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                widget.containsEightCharactersText,
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  containsNumber
                                      ? CupertinoIcons.check_mark_circled
                                      : CupertinoIcons.xmark_circle,
                                  color: containsNumber
                                      ? widget.successColor
                                      : widget.errorColor,
                                  size: 15,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                widget.containsNumberText
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  containsSpecial
                                      ? CupertinoIcons.check_mark_circled
                                      : CupertinoIcons.xmark_circle,
                                  color: containsSpecial
                                      ? widget.successColor
                                      : widget.errorColor,
                                  size: 15,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                widget.containsSpecialText,
                              ],
                            ),
                            SizedBox(
                              height: 10,
                            ),
                            Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: <Widget>[
                                Icon(
                                  passwordMatch
                                      ? CupertinoIcons.check_mark_circled
                                      : CupertinoIcons.xmark_circle,
                                  color: passwordMatch
                                      ? widget.successColor
                                      : widget.errorColor,
                                  size: 15,
                                ),
                                SizedBox(
                                  width: 5,
                                ),
                                widget.passwordMatchText,
                              ],
                            ),
                          ],
                        ),
                      const SizedBox(
                        height: 30,
                      ),
                      SizedBox(
                        width: 250,
                        child: CupertinoButton(
                          color: widget.secondaryColor,
                          onPressed: () {
                            if (!passwordMatch ||
                                !containsSpecial ||
                                !containsNumber ||
                                !containsEightCharacters) {
                              return;
                            }
                            if (emailController.text.isEmpty) {
                              showCupertinoDialog(
                                  context: context,
                                  builder: (context) {
                                    return CupertinoAlertDialog(
                                      title: Text(widget.missingEmailTitle),
                                      content:
                                          Text(widget.missingPasswordDetails),
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
                                      content:
                                          Text(widget.missingPasswordDetails),
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
                            } else if (passwordController.text !=
                                repeatPasswordController.text) {
                              showCupertinoDialog(
                                  context: context,
                                  builder: (context) {
                                    return CupertinoAlertDialog(
                                      title:
                                          Text(widget.passwordDoNotMatchTitle),
                                      content: Text(
                                          widget.passwordDoNotMatchDetails),
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
                                .create(
                              password: passwordController.text,
                              email: emailController.text,
                              validatePassword: widget.validatePassword,
                            )
                                .catchError((err) {
                              passwordController.text = "";
                              emailController.text = "";
                              repeatPasswordController.text = "";
                              setState(() {
                                isLoading = false;
                                containsEightCharacters = false;
                                containsNumber = false;
                                containsSpecial = false;
                                passwordMatch = false;
                              });
                              showCupertinoDialog(
                                  context: context,
                                  builder: (context) {
                                    return CupertinoAlertDialog(
                                      title: Text(widget.invalidTitle),
                                      content: Text(widget.invalidDetails),
                                      actions: <Widget>[
                                        TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('okay'))
                                      ],
                                    );
                                  });
                              return err;
                            }).then((user) {
                              // todo: handle error
                              NuntioClient.userBlock
                                  .login(
                                      password: passwordController.text,
                                      email: emailController.text)
                                  .then((value) {
                                passwordController.text = "";
                                emailController.text = "";
                                repeatPasswordController.text = "";
                                setState(() {
                                  isLoading = false;
                                  containsEightCharacters = false;
                                  containsNumber = false;
                                  containsSpecial = false;
                                  passwordMatch = false;
                                });
                                widget.onRegister();
                              });
                            });
                          },
                          child: isLoading
                              ? CupertinoActivityIndicator()
                              : widget.buttonText,
                        ),
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
