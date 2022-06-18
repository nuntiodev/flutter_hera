import 'package:dart_blocks/dart_blocks/components/nuntio_button.dart';
import 'package:dart_blocks/dart_blocks/nuntio_client.dart';
import 'package:dart_blocks/dart_blocks/user_block_with_ui/AuthPage/VerifyCodePage/verify_code_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:nuntio_blocks/block_user.pb.dart';
import '../../../components/text_field_decoration.dart';
import '../../models.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({
    Key? key,
    required this.nuntioStyle,
    required this.nuntioText,
    required this.nuntioColor,
    required this.nuntioTextStyle,
    required this.logo,
    required this.config,
    required this.background,
    required this.onRegister,
    required this.nuntioFooter,
  }) : super(key: key);

  // style and text config
  final NuntioStyle nuntioStyle;
  final NuntioText nuntioText;
  final NuntioColor nuntioColor;
  final NuntioTextStyle nuntioTextStyle;
  final NuntioFooter nuntioFooter;

  // general
  final Widget logo;
  final Config config;

  // style
  final BoxDecoration background;

  // functions
  final Function onRegister;

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

  onPasswordChange() {
    if (!widget.config.validatePassword) {
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
    } else {
      setState(() {
        containsEightCharacters = false;
        containsNumber = false;
        passwordMatch = false;
      });
    }
  }

  afterLoginFailure() {
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
  }

  afterLoginSuccess() {
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
  }

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: false,
      child: SingleChildScrollView(
        child: Container(
          decoration: widget.background,
          constraints: BoxConstraints(minHeight: size.height),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              SizedBox(),
              Center(
                  child: Container(
                    constraints: BoxConstraints(maxWidth: 400),
                    margin: const EdgeInsets.only(
                        left: 20, right: 20, bottom: 20, top: 0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        widget.logo,
                        SizedBox(
                          height: 20,
                        ),
                        Text(
                          widget.nuntioText.registerTitle,
                          style: widget.nuntioTextStyle.titleStyle,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text(
                          widget.nuntioText.registerDetails,
                          style: widget.nuntioTextStyle.descriptionStyle,
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(
                          height: 30,
                        ),
                        SizedBox(
                          height: 40,
                          child: CupertinoTextField(
                            decoration: textFieldDecoration(
                              widget.nuntioStyle.border,
                              widget.nuntioStyle.borderColor,
                            ),
                            controller: emailController,
                            placeholder: widget.nuntioText.identifierHint,
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
                              widget.nuntioStyle.border,
                              widget.nuntioStyle.borderColor,
                            ),
                            controller: passwordController,
                            onChanged: (_) => onPasswordChange(),
                            obscureText: true,
                            placeholder: widget.nuntioText.passwordHint,
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
                              widget.nuntioStyle.border,
                              widget.nuntioStyle.borderColor,
                            ),
                            controller: repeatPasswordController,
                            onChanged: (_) => onPasswordChange(),
                            obscureText: true,
                            placeholder: widget.nuntioText.repeatPasswordHint,
                            keyboardType: TextInputType.text,
                            maxLength: 80,
                          ),
                        ),
                        if (widget.config.validatePassword)
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
                                        ? widget.nuntioColor.successColor
                                        : widget.nuntioColor.errorColor,
                                    size: 15,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    widget.nuntioText
                                        .passwordContainsEightCharsHint,
                                    style: widget.nuntioTextStyle.bodyTextStyle,
                                  )
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
                                        ? widget.nuntioColor.successColor
                                        : widget.nuntioColor.errorColor,
                                    size: 15,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    widget
                                        .nuntioText.passwordContainsNumberHint,
                                    style: widget.nuntioTextStyle.bodyTextStyle,
                                  )
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
                                        ? widget.nuntioColor.successColor
                                        : widget.nuntioColor.errorColor,
                                    size: 15,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    widget
                                        .nuntioText.passwordContainsSpecialHint,
                                    style: widget.nuntioTextStyle.bodyTextStyle,
                                  )
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
                                        ? widget.nuntioColor.successColor
                                        : widget.nuntioColor.errorColor,
                                    size: 15,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    widget.nuntioText.passwordsMustMatchHint,
                                    style: widget.nuntioTextStyle.bodyTextStyle,
                                  )
                                ],
                              ),
                            ],
                          ),
                        const SizedBox(
                          height: 30,
                        ),
                        SizedBox(
                          width: widget.nuntioStyle.buttonWidth,
                          height: widget.nuntioStyle.buttonHeight,
                          child: NuntioButton(
                              color: widget.nuntioColor.secondaryColor,
                              filled: true,
                              disabledTipnote: widget
                                  .nuntioText.registerDisabledTipNoteMessage,
                              disabled: (!passwordMatch ||
                                  !containsSpecial ||
                                  !containsNumber ||
                                  !containsEightCharacters),
                              onPressed: () {
                                if (emailController.text.isEmpty) {
                                  showCupertinoDialog(
                                      context: context,
                                      builder: (context) {
                                        return CupertinoAlertDialog(
                                          title: Text(
                                            widget.nuntioText
                                                .missingIdentifierTitle,
                                          ),
                                          content: Text(
                                            widget.nuntioText
                                                .missingIdentifierDescription,
                                          ),
                                          actions: <Widget>[
                                            CupertinoButton(
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
                                          title: Text(
                                            widget.nuntioText
                                                .missingPasswordTitle,
                                            style: widget
                                                .nuntioTextStyle.titleStyle,
                                          ),
                                          content: Text(
                                            widget.nuntioText
                                                .missingPasswordDescription,
                                          ),
                                          actions: <Widget>[
                                            CupertinoButton(
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
                                          title: Text(
                                            widget.nuntioText
                                                .passwordDoNotMatchTitle,
                                          ),
                                          content: Text(
                                            widget.nuntioText
                                                .passwordDoNotMatchDescription,
                                          ),
                                          actions: <Widget>[
                                            CupertinoButton(
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
                                          title: Text(
                                            widget.nuntioText.errorTitle,
                                          ),
                                          content: Text(
                                            widget.nuntioText.errorDescription,
                                          ),
                                          actions: <Widget>[
                                            CupertinoButton(
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
                                      .then((loginSession) {
                                    if (loginSession.loginStatus ==
                                        LoginStatus.EMAIL_IS_NOT_VERIFIED) {
                                      /*
                                      Navigator.of(context).push(
                                          CupertinoPageRoute(builder: (context) =>
                                              VerifyCodePage(
                                                buttonWidth:
                                                widget.nuntioStyle.buttonWidth,
                                                buttonHeight:
                                                widget.nuntioStyle.buttonHeight,
                                                verifyCodeTitle: Text(
                                                  widget.nuntioText
                                                      .verificationCodeTitle,
                                                  style: widget
                                                      .nuntioTextStyle.titleStyle,
                                                ),
                                                userEmail: emailController.text,
                                                emailExpiresAt: loginSession
                                                    .emailExpiresAt
                                                    .toDateTime()
                                                    .toUtc(),
                                              )));
                                       */
                                      showCupertinoModalBottomSheet(
                                        context: context,
                                        useRootNavigator: true,
                                        builder: (context) => VerifyCodePage(
                                          buttonWidth:
                                              widget.nuntioStyle.buttonWidth,
                                          buttonHeight:
                                              widget.nuntioStyle.buttonHeight,
                                          verifyCodeTitle: Text(
                                            widget.nuntioText
                                                .verificationCodeTitle,
                                            style: widget
                                                .nuntioTextStyle.titleStyle,
                                          ),
                                          userEmail: emailController.text,
                                          emailExpiresAt: loginSession
                                              .emailExpiresAt
                                              .toDateTime()
                                              .toUtc(),
                                        ),
                                      ).catchError((err) {
                                        print(err);
                                        afterLoginFailure();
                                        return err;
                                        //todo show error message with user created;
                                      }).then((value) {
                                        // login again
                                        NuntioClient.userBlock
                                            .login(
                                                password:
                                                    passwordController.text,
                                                email: emailController.text)
                                            .catchError((err) {
                                          afterLoginFailure();
                                          //todo: show error message with user created;
                                        }).then((value) {
                                          afterLoginSuccess();
                                        });
                                      });
                                    } else {
                                      afterLoginSuccess();
                                    }
                                  });
                                });
                              },
                              child: isLoading
                                  ? CupertinoActivityIndicator()
                                  : Text(
                                      widget.nuntioText.registerButton,
                                      style: widget.nuntioTextStyle
                                          .registerButtonTextStyle,
                                    )),
                        ),
                        NuntioButton(
                          child: Text(
                            widget.nuntioText.alreadyHaveAccountDescription,
                          ),
                          onPressed: () => {
                            Navigator.of(context).pop(),
                          },
                          color: widget.nuntioColor.primaryColor,
                        ),
                      ],
                    ),
                  ),
                ),
              SizedBox(
                height: widget.nuntioFooter.height,
                child: widget.nuntioFooter.footer,
              )
            ],
          ),
        ),
      ),
    );
  }
}
