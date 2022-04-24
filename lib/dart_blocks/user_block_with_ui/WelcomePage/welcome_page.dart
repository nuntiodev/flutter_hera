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
    required this.primaryColor,
    required this.secondaryColor,
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
  });

  // general
  final Widget createdBy;
  final Color primaryColor;
  final Color secondaryColor;
  final BoxDecoration background;
  final Border textFieldBorder;
  final Color textFieldColor;
  final Widget logo;
  final double buttonHeight;
  final double buttonWidth;

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
  final Widget loginButtonText;
  final Widget loginDetailsTitle;
  final Widget loginTitle;
  final Function onLogin;
  final String emailLoginHint;
  final String passwordLoginHint;
  final Widget forgotPasswordText;

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
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
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
                SizedBox(
                  width: buttonWidth,
                  height: buttonHeight,
                  child: CupertinoButton(
                    color: primaryColor,
                    onPressed: () {
                      Navigator.push(
                        context,
                        CupertinoPageRoute(
                          builder: (context) => LoginPage(
                            buttonWidth: buttonWidth,
                            buttonHeight: buttonHeight,
                            textFieldBorder: textFieldBorder,
                            forgotPasswordText: forgotPasswordText,
                            textFieldColor: textFieldColor,
                            emailHint: emailLoginHint,
                            createdBy: createdBy,
                            background: background,
                            primaryColor: primaryColor,
                            secondaryColor: secondaryColor,
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
                SizedBox(
                  height: 20,
                ),
                if (!disableRegistration)
                  SizedBox(
                    width: buttonWidth,
                    height: buttonHeight,
                    child: CupertinoButton(
                      color: secondaryColor,
                      onPressed: () {
                        Navigator.push(
                          context,
                          CupertinoPageRoute(
                            builder: (context) => RegisterPage(
                              buttonWidth: buttonWidth,
                              buttonHeight: buttonHeight,
                              errorColor: errorColor,
                              successColor: successColor,
                              validatePassword: validatePassword,
                              textFieldBorder: textFieldBorder,
                              textFieldColor: textFieldColor,
                              secondaryColor: secondaryColor,
                              primaryColor: primaryColor,
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
                const SizedBox(
                  height: 50,
                ),
                createdBy,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
