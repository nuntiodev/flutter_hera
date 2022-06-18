import 'package:dart_blocks/dart_blocks/components/nuntio_button.dart';
import 'package:dart_blocks/dart_blocks/components/text_field_decoration.dart';
import 'package:dart_blocks/dart_blocks/nuntio_client.dart';
import 'package:dart_blocks/dart_blocks/user_block_with_ui/AuthPage/RegisterPage/register_page.dart';
import 'package:dart_blocks/dart_blocks/user_block_with_ui/AuthPage/VerifyCodePage/verify_code_sheet.dart';
import 'package:flutter/cupertino.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:nuntio_blocks/block_user.pb.dart';
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
  final Function onLogin;
  final Function onRegister;

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
                    children: [
                      widget.logo,
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        widget.nuntioText.loginTitle,
                        style: widget.nuntioTextStyle.titleStyle,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        widget.nuntioText.loginDetails,
                        style: widget.nuntioTextStyle.descriptionStyle,
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(
                        height: 30,
                      ),
                      if (!widget.config.disableDefaultLogin)
                        SizedBox(
                          height: 40,
                          child: CupertinoTextField(
                            decoration: textFieldDecoration(
                              widget.nuntioStyle.border,
                              widget.nuntioStyle.borderColor,
                            ),
                            controller: emailController,
                            placeholder: widget.nuntioText.identifierHint,
                            keyboardType: widget.identifierInputType,
                          ),
                        ),
                      if (!widget.config.disableDefaultLogin)
                        const SizedBox(
                          height: 15,
                        ),
                      if (!widget.config.disableDefaultLogin)
                        SizedBox(
                          height: 40,
                          child: CupertinoTextField(
                            decoration: textFieldDecoration(
                              widget.nuntioStyle.border,
                              widget.nuntioStyle.borderColor,
                            ),
                            controller: passwordController,
                            obscureText: true,
                            placeholder: widget.nuntioText.passwordHint,
                            keyboardType: TextInputType.text,
                            maxLength: 80,
                          ),
                        ),
                      if (!widget.config.disableDefaultLogin)
                        const SizedBox(
                          height: 5,
                        ),
                      if (!widget.config.disableDefaultLogin)
                        Align(
                          alignment: Alignment.centerRight,
                          child: NuntioButton(
                            padding: EdgeInsets.all(0),
                            child: Text(
                              widget.nuntioText.forgotPasswordDetails,
                              textAlign: TextAlign.center,
                            ),
                            onPressed: () {},
                            color: CupertinoColors.black,
                          ),
                        ),
                      if (!widget.config.disableDefaultLogin)
                        const SizedBox(
                          height: 20,
                        ),
                      if (!widget.config.disableDefaultLogin)
                        SizedBox(
                          width: widget.nuntioStyle.buttonWidth,
                          height: widget.nuntioStyle.buttonHeight,
                          child: NuntioButton(
                            color: widget.nuntioColor.primaryColor,
                            filled: true,
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
                                          widget
                                              .nuntioText.missingPasswordTitle,
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
                                if (loginSession.loginStatus ==
                                    LoginStatus.EMAIL_IS_NOT_VERIFIED) {
                                  showCupertinoModalBottomSheet(
                                    context: context,
                                    useRootNavigator: true,
                                    builder: (context) => VerifyCodePage(
                                      buttonHeight:
                                          widget.nuntioStyle.buttonWidth,
                                      buttonWidth:
                                          widget.nuntioStyle.buttonHeight,
                                      verifyCodeTitle: Text(
                                        widget.nuntioText.verificationCodeTitle,
                                        style:
                                            widget.nuntioTextStyle.titleStyle,
                                        textAlign: TextAlign.center,
                                      ),
                                      userEmail: emailController.text,
                                      emailExpiresAt: loginSession
                                          .emailExpiresAt
                                          .toDateTime()
                                          .toUtc(),
                                    ),
                                  ).catchError((err) {
                                    print(err);
                                    loginFailure();
                                    return err;
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
                                : Text(
                                    widget.nuntioText.loginButton,
                                    style: widget
                                        .nuntioTextStyle.loginButtonTextStyle,
                                    textAlign: TextAlign.center,
                                  ),
                          ),
                        ),
                      SizedBox(
                        height: 10,
                      ),
                      if (widget.config.enableNuntioConnect)
                        SizedBox(
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
                      if (widget.config.enableNuntioConnect)
                        SizedBox(
                          height: 10,
                        ),
                      if (!widget.config.disableDefaultSignup)
                        SizedBox(
                          width: widget.nuntioStyle.buttonWidth,
                          height: widget.nuntioStyle.buttonHeight,
                          child: NuntioButton(
                            filled: true,
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
                                  ),
                                ),
                              );
                            },
                            child: Text(
                              widget.nuntioText.registerButton,
                              style: widget
                                  .nuntioTextStyle.registerButtonTextStyle,
                              textAlign: TextAlign.center,
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
