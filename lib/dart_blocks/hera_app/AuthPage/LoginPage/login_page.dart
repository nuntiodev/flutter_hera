import 'package:animate_do/animate_do.dart';
import 'package:dart_blocks/dart_blocks/components/nuntio_button.dart';
import 'package:dart_blocks/dart_blocks/components/nuntio_text_field.dart';
import 'package:dart_blocks/dart_blocks/components/text_field_decoration.dart';
import 'package:dart_blocks/dart_blocks/hera_app/AuthPage/RegisterPage/register_page.dart';
import 'package:dart_blocks/dart_blocks/hera_app/AuthPage/VerifyCodePage/verify_code_page.dart';
import 'package:dart_blocks/dart_blocks/nuntio_client.dart';
import 'package:flutter/cupertino.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import 'package:nuntio_blocks/block_user.pb.dart';
import '../../../components/nuntio_indicator.dart';
import '../../models.dart';

class LoginPage extends StatefulWidget {
  LoginPage({
    Key? key,
    required this.identifierInputType,
    required this.nuntioFooter,
    required this.nuntioStyle,
    required this.nuntioText,
    required this.nuntioColor,
    required this.nuntioTextStyle,
    required this.logo,
    required this.config,
    required this.background,
    required this.onLogin,
    required this.onRegister,
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
  final TextInputType identifierInputType;

  // style
  final BoxDecoration background;

  // functions
  final Function(BuildContext context) onLogin;
  final Function(BuildContext context) onRegister;

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
    widget.onLogin(context);
  }

  loginFailure() {
    setState(() {
      isLoading = false;
    });
    passwordController.text = "";
    emailController.text = "";
  }

  onLogin() {
    if (isLoading) {
      return;
    }
    if (emailController.text.isEmpty) {
      showCupertinoDialog(
          context: context,
          builder: (context) {
            return CupertinoAlertDialog(
              title: Text(
                widget.nuntioText.missingIdentifierTitle,
              ),
              content: Text(
                widget.nuntioText.missingIdentifierDescription,
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
                widget.nuntioText.missingPasswordTitle,
              ),
              content: Text(
                widget.nuntioText.missingPasswordDescription,
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
        .login(
      password: passwordController.text,
      email: emailController.text,
    )
        .catchError((err) {
      print(err);
      loginFailure();
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
    }).then((loginSession) {
      if (loginSession.loginStatus == LoginStatus.EMAIL_IS_NOT_VERIFIED) {
        Navigator.of(context)
            .push(
          CupertinoPageRoute(
            builder: (context) => VerifyCodePage(
              identifier: emailController.text,
              emailExpiresAt: loginSession.emailExpiresAt.toDateTime().toUtc(),
              config: widget.config,
              onLogin: widget.onLogin,
              nuntioStyle: widget.nuntioStyle,
              nuntioColor: widget.nuntioColor,
              background: widget.background,
              nuntioText: widget.nuntioText,
              nuntioFooter: widget.nuntioFooter,
              nuntioTextStyle: widget.nuntioTextStyle,
              password: passwordController.text,
              logo: widget.logo,
            ),
          ),
        )
            .then((_) {
          setState(() {
            isLoading = false;
          });
          passwordController.text = "";
          emailController.text = "";
        });
      } else {
        loginSuccess();
      }
    });
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
                  constraints: BoxConstraints(maxWidth: 450),
                  margin: const EdgeInsets.only(
                      left: 25, right: 25, bottom: 20, top: 0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      FadeInUp(
                        delay: Duration(milliseconds: 0),
                        child: widget.logo,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      FadeInUp(
                        delay: Duration(milliseconds: 500),
                        child: Text(
                          widget.nuntioText.loginTitle,
                          style: widget.nuntioTextStyle.titleStyle,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      FadeInUp(
                        delay: Duration(milliseconds: 600),
                        child: Text(
                          widget.nuntioText.loginDetails,
                          style: widget.nuntioTextStyle.descriptionStyle,
                          textAlign: TextAlign.center,
                        ),
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      if (!widget.config.disableDefaultLogin)
                        FadeInUp(
                          delay: Duration(milliseconds: 700),
                          child: NuntioTextField(
                            nuntioTextStyle: widget.nuntioTextStyle,
                            nuntioStyle: widget.nuntioStyle,
                            nuntioColor: widget.nuntioColor,
                            controller: emailController,
                            hint: widget.nuntioText.identifierHint,
                            textInputType: widget.identifierInputType,
                            label: widget.nuntioText.identifierName,
                            prefix: FontAwesomeIcons.fingerprint,
                            textInputAction: TextInputAction.next,
                          ),
                        ),
                      if (!widget.config.disableDefaultLogin)
                        const SizedBox(
                          height: 15,
                        ),
                      if (!widget.config.disableDefaultLogin)
                        FadeInUp(
                          delay: Duration(milliseconds: 800),
                          child: NuntioTextField(
                            nuntioTextStyle: widget.nuntioTextStyle,
                            nuntioStyle: widget.nuntioStyle,
                            nuntioColor: widget.nuntioColor,
                            controller: passwordController,
                            hint: widget.nuntioText.passwordHint,
                            textInputType: TextInputType.text,
                            label: widget.nuntioText.passwordName,
                            textInputAction: TextInputAction.done,
                            prefix: FontAwesomeIcons.key,
                            obscureText: true,
                            onSubmitted: (_) {
                              onLogin();
                            },
                          ),
                        ),
                      if (!widget.config.disableDefaultLogin)
                        const SizedBox(
                          height: 5,
                        ),
                      if (!widget.config.disableDefaultLogin)
                        FadeInUp(
                          delay: Duration(milliseconds: 900),
                          child: Align(
                            alignment: Alignment.centerRight,
                            child: NuntioButton(
                              padding: EdgeInsets.all(0),
                              child: Text(
                                widget.nuntioText.forgotPasswordDetails,
                                textAlign: TextAlign.center,
                              ),
                              onPressed: () {},
                              color: CupertinoTheme.brightnessOf(context) ==
                                      Brightness.light
                                  ? CupertinoColors.black
                                  : CupertinoColors.white,
                            ),
                          ),
                        ),
                      if (!widget.config.disableDefaultLogin)
                        const SizedBox(
                          height: 20,
                        ),
                      if (!widget.config.disableDefaultLogin)
                        FadeInUp(
                          delay: Duration(milliseconds: 1000),
                          child: SizedBox(
                            width: widget.nuntioStyle.buttonWidth,
                            height: widget.nuntioStyle.buttonHeight,
                            child: NuntioButton(
                              color: widget.nuntioColor.primaryColor,
                              filled: true,
                              onPressed: onLogin,
                              child: isLoading
                                  ? NuntioIndicator(
                                      color: widget.nuntioTextStyle
                                          .loginButtonTextStyle.color)
                                  : Row(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.center,
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: [
                                        Text(
                                          widget.nuntioText.loginButton,
                                          style: widget.nuntioTextStyle
                                              .loginButtonTextStyle,
                                          textAlign: TextAlign.center,
                                        ),
                                        SizedBox(width: 8),
                                        FaIcon(
                                          FontAwesomeIcons.arrowRight,
                                          size: 15,
                                          color: widget.nuntioTextStyle
                                              .loginButtonTextStyle.color,
                                        ),
                                      ],
                                    ),
                            ),
                          ),
                        ),
                      SizedBox(
                        height: 10,
                      ),
                      if (widget.config.enableNuntioConnect)
                        FadeInUp(
                          delay: Duration(milliseconds: 1000),
                          child: SizedBox(
                            width: widget.nuntioStyle.buttonWidth,
                            height: widget.nuntioStyle.buttonHeight,
                            child: CupertinoButton(
                              color: CupertinoColors.darkBackgroundGray,
                              padding: EdgeInsets.all(5),
                              alignment: Alignment.center,
                              onPressed: () {},
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Image.network(
                                    "https://nuntiodev.github.io/website/nuntio/nuntio.png",
                                    width: 22,
                                  ),
                                  SizedBox(
                                    width: 5,
                                  ),
                                  Text(
                                    "Continue with Nuntio",
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: CupertinoColors.white,
                                      fontWeight: FontWeight.w400,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      if (widget.config.enableNuntioConnect)
                        SizedBox(
                          height: 10,
                        ),
                      if (!widget.config.disableDefaultSignup)
                        FadeInUp(
                          delay: Duration(milliseconds: 1000),
                          child: SizedBox(
                            width: widget.nuntioStyle.buttonWidth,
                            height: widget.nuntioStyle.buttonHeight,
                            child: NuntioButton(
                              color: widget.nuntioColor.secondaryColor,
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  CupertinoPageRoute(
                                    builder: (context) => RegisterPage(
                                      nuntioText: widget.nuntioText,
                                      logo: widget.logo,
                                      nuntioStyle: widget.nuntioStyle,
                                      nuntioColor: widget.nuntioColor,
                                      background: widget.background,
                                      onRegister: widget.onRegister,
                                      config: widget.config,
                                      nuntioTextStyle: widget.nuntioTextStyle,
                                      nuntioFooter: widget.nuntioFooter,
                                      onLogin: widget.onLogin,
                                    ),
                                  ),
                                );
                              },
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Text(
                                    widget.nuntioText.registerButton,
                                    style: widget.nuntioTextStyle
                                        .registerButtonTextStyle,
                                    textAlign: TextAlign.center,
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
              SizedBox(
                height: widget.nuntioFooter.height,
                child: widget.nuntioFooter.footer,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
