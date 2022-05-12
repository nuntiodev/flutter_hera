import 'package:dart_blocks/dart_blocks/models/auth.dart';
import 'package:dart_blocks/dart_blocks/user_block_with_ui/AuthPage/LoginPage/login_page.dart';
import 'package:dart_blocks/dart_blocks/user_block_with_ui/AuthPage/RegisterPage/register_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class WelcomePage extends StatelessWidget {
  WelcomePage({
    Key? key,
    required this.createdBy,
    required this.welcomeTitle,
    required this.welcomeDetails,
    required this.loginButtonText,
    required this.registerButtonText,
    required this.onLogin,
    required this.emailLoginHint,
    required this.passwordLoginHint,
    required this.emailRegisterHint,
    required this.passwordRegisterHint,
    required this.loginDetailsTitle,
    required this.registerDetails,
    required this.onRegister,
    required this.loginButtonColor,
    required this.registerButtonColor,
    required this.loginTitle,
    required this.registerTitle,
    required this.logo,
    required this.repeatPasswordRegisterHint,
    required this.background,
    required this.textFieldBorder,
    required this.textFieldColor,
    required this.disableRegistration,
    required this.validatePassword,
    required this.missingEmailTitle,
    required this.missingEmailDetails,
    required this.missingPasswordTitle,
    required this.missingPasswordDetails,
    required this.passwordDoNotMatchTitle,
    required this.passwordDoNotMatchDetails,
    required this.invalidTitle,
    required this.invalidDetails,
    required this.errorColor,
    required this.successColor,
    required this.containsEightCharactersText,
    required this.containsNumberText,
    required this.passwordMatchText,
    required this.containsSpecialText,
    required this.forgotPasswordText,
    required this.buttonHeight,
    required this.buttonWidth,
    required this.infoColor,
    required this.disableLogin,
    required this.disableConnect,
    required this.arrowBackColor,
    required this.forgotPasswordColor,
    required this.verifyCodeTitle,
  });

  // general
  final Widget createdBy;
  final Color loginButtonColor;
  final Color registerButtonColor;
  final BoxDecoration background;
  final Border textFieldBorder;
  final Color textFieldColor;
  final Widget logo;
  final double buttonHeight;
  final double buttonWidth;
  final Color infoColor;
  final Color arrowBackColor;
  final Color forgotPasswordColor;

  // connect
  final bool disableConnect;

  // error messages
  final String missingEmailTitle;
  final String missingEmailDetails;
  final String missingPasswordTitle;
  final String missingPasswordDetails;
  final String invalidTitle;
  final String invalidDetails;
  final String passwordDoNotMatchTitle;
  final String passwordDoNotMatchDetails;

  // welcome
  final Widget welcomeTitle;
  final Widget welcomeDetails;

  // login
  final bool disableLogin;
  final Widget loginButtonText;
  final Widget loginDetailsTitle;
  final Widget loginTitle;
  final Function onLogin;
  final String emailLoginHint;
  final String passwordLoginHint;
  final Widget forgotPasswordText;

  // verify email
  final Widget verifyCodeTitle;

  // register
  final bool disableRegistration;
  final bool validatePassword;
  final Widget registerButtonText;
  final Widget registerDetails;
  final Function onRegister;
  final String emailRegisterHint;
  final String passwordRegisterHint;
  final String repeatPasswordRegisterHint;
  final Widget registerTitle;
  final Widget containsEightCharactersText;
  final Widget containsNumberText;
  final Widget passwordMatchText;
  final Widget containsSpecialText;
  final Color successColor;
  final Color errorColor;

  AuthEnum auth = AuthEnum.signIn;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: false,
      child: Container(
        height: MediaQuery.of(context).size.height,
        decoration: background,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Align(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                const Spacer(),
                logo,
                const SizedBox(
                  height: 30,
                ),
                welcomeTitle,
                const SizedBox(
                  height: 15,
                ),
                welcomeDetails,
                const Spacer(),
                if (!disableConnect)
                  SizedBox(
                    width: buttonWidth,
                    height: buttonHeight,
                    child: CupertinoButton(
                      color: MediaQuery.of(context).platformBrightness ==
                              Brightness.light
                          ? CupertinoColors.black
                          : CupertinoColors.white,
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
                            style: MediaQuery.of(context).platformBrightness ==
                                    Brightness.light
                                ? TextStyle(
                                    color: CupertinoColors.white,
                                    fontWeight: FontWeight.w500,
                                  )
                                : TextStyle(
                                    color: CupertinoColors.black,
                                    fontWeight: FontWeight.w500,
                                  ),
                          ),
                        ],
                      ),
                    ),
                  ),
                if (!disableConnect)
                  SizedBox(
                    height: 15,
                  ),
                if (!disableLogin)
                  SizedBox(
                    width: buttonWidth,
                    height: buttonHeight,
                    child: CupertinoButton(
                      color: loginButtonColor,
                      onPressed: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => LoginPage(
                              verifyCodeTitle: verifyCodeTitle,
                              arrowBackColor: arrowBackColor,
                              buttonWidth: buttonWidth,
                              buttonHeight: buttonHeight,
                              textFieldBorder: textFieldBorder,
                              forgotPasswordText: forgotPasswordText,
                              textFieldColor: textFieldColor,
                              emailHint: emailLoginHint,
                              createdBy: createdBy,
                              background: background,
                              primaryColor: loginButtonColor,
                              secondaryColor: registerButtonColor,
                              title: loginTitle,
                              logo: logo,
                              passwordHint: passwordLoginHint,
                              onLogin: onLogin,
                              details: loginDetailsTitle,
                              loginButtonText: loginButtonText,
                              missingPasswordTitle: missingPasswordTitle,
                              missingEmailDetails: missingEmailDetails,
                              missingEmailTitle: missingEmailTitle,
                              missingPasswordDetails: missingPasswordDetails,
                              invalidDetails: invalidDetails,
                              invalidTitle: invalidTitle,
                            ),
                          ),
                        );
                      },
                      child: loginButtonText,
                    ),
                  ),
                if (!disableLogin)
                  SizedBox(
                    height: 15,
                  ),
                if (!disableRegistration)
                  SizedBox(
                    width: buttonWidth,
                    height: buttonHeight,
                    child: CupertinoButton(
                      color: registerButtonColor,
                      onPressed: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => RegisterPage(
                              buttonWidth: buttonWidth,
                              buttonHeight: buttonHeight,
                              errorColor: errorColor,
                              arrowBackColor: arrowBackColor,
                              successColor: successColor,
                              validatePassword: validatePassword,
                              textFieldBorder: textFieldBorder,
                              textFieldColor: textFieldColor,
                              secondaryColor: registerButtonColor,
                              primaryColor: loginButtonColor,
                              buttonText: registerButtonText,
                              emailHint: emailRegisterHint,
                              background: background,
                              passwordHint: passwordRegisterHint,
                              repeatPasswordHint: repeatPasswordRegisterHint,
                              details: registerDetails,
                              missingPasswordTitle: missingPasswordTitle,
                              missingEmailDetails: missingEmailDetails,
                              missingEmailTitle: missingEmailTitle,
                              missingPasswordDetails: missingPasswordDetails,
                              invalidDetails: invalidDetails,
                              verifyCodeTitle: verifyCodeTitle,
                              invalidTitle: invalidTitle,
                              passwordDoNotMatchDetails:
                                  passwordDoNotMatchDetails,
                              passwordDoNotMatchTitle: passwordDoNotMatchTitle,
                              onRegister: onRegister,
                              title: registerTitle,
                              logo: logo,
                              createdBy: createdBy,
                              containsNumberText: containsNumberText,
                              passwordMatchText: passwordMatchText,
                              containsEightCharactersText:
                                  containsEightCharactersText,
                              containsSpecialText: containsSpecialText,
                            ),
                          ),
                        );
                      },
                      child: registerButtonText,
                    ),
                  ),
                Spacer(),
                createdBy,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
