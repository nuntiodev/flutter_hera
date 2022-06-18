import 'dart:ui';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NuntioText {
  // general
  late String passwordHint;
  late String identifierHint;
  late String missingIdentifierTitle;
  late String missingIdentifierDescription;
  late String missingPasswordTitle;
  late String missingPasswordDescription;
  late String errorTitle;
  late String errorDescription;
  late String noWifiTitle;
  late String noWifiDescription;

  // welcome
  late String welcomeTitle;
  late String welcomeDetails;

  // register
  late String registerTitle;
  late String registerDetails;
  late String registerButton;
  late String repeatPasswordHint;
  late String passwordDoNotMatchTitle;
  late String passwordDoNotMatchDescription;
  late String passwordContainsEightCharsHint;
  late String passwordContainsSpecialHint;
  late String passwordContainsNumberHint;
  late String passwordsMustMatchHint;
  late String alreadyHaveAccountDescription;
  late String registerDisabledTipNoteMessage;

  // login
  late String loginTitle;
  late String loginDetails;
  late String loginButton;
  late String forgotPasswordDetails;
  late String verificationCodeTitle;

  NuntioText({
    String? passwordHint,
    String? identifierHint,
    String? missingIdentifierTitle,
    String? missingIdentifierDescription,
    String? missingPasswordTitle,
    String? missingPasswordDescription,
    String? errorTitle,
    String? errorDescription,
    String? noWifiTitle,
    String? noWifiDescription,
    String? welcomeTitle,
    String? welcomeDetails,
    String? registerTitle,
    String? registerDetails,
    String? registerButton,
    String? repeatPasswordHint,
    String? passwordDoNotMatchTitle,
    String? passwordDoNotMatchDescription,
    String? passwordContainsEightCharsHint,
    String? passwordContainsSpecialHint,
    String? passwordContainsNumberHint,
    String? passwordsMustMatchHint,
    String? loginTitle,
    String? loginDetails,
    String? loginButton,
    String? forgotPasswordDetails,
    String? verificationCodeTitle,
    String? alreadyHaveAccountDescription,
    String? registerDisabledTipNoteMessage,
  }) {
    this.passwordHint = passwordHint ?? "Enter your password";
    this.identifierHint = identifierHint ?? "Enter your email";
    this.missingIdentifierTitle =
        missingIdentifierTitle ?? "Missing required email";
    this.missingIdentifierDescription = missingIdentifierDescription ??
        "Please enter your email to login/register your account";
    this.missingPasswordTitle =
        missingPasswordTitle ?? "Missing required password";
    this.missingPasswordDescription = missingPasswordDescription ??
        "Please enter your password to login/register your account";
    this.errorTitle = errorTitle ?? "Something went wrong";
    this.errorDescription =
        errorDescription ?? "We encountered an error. Please try again.";
    this.noWifiTitle = noWifiTitle ?? "No wifi connection";
    this.noWifiDescription = noWifiDescription ??
        "We cannot authenticate your credentials without a valid wifi or data connection";
    this.welcomeTitle = welcomeTitle ?? "Welcome";
    this.welcomeDetails =
        welcomeDetails ?? "Register for an account or sign in below";
    this.registerTitle = registerTitle ?? "Register";
    this.registerDetails = registerDetails ??
        "Fill in the details below to register for an account";
    this.registerButton = registerButton ?? "Register";
    this.repeatPasswordHint = repeatPasswordHint ?? "Repeat your password";
    this.passwordDoNotMatchTitle =
        passwordDoNotMatchTitle ?? "Passwords do not match";
    this.passwordDoNotMatchDescription = passwordDoNotMatchDescription ??
        "The entered password and repeat password do not match";
    this.passwordContainsEightCharsHint =
        passwordContainsEightCharsHint ?? "Password must contain 8 chars";
    this.passwordContainsSpecialHint =
        passwordContainsSpecialHint ?? "Password must contain special char";
    this.passwordContainsNumberHint =
        passwordContainsNumberHint ?? "Password must contain number";
    this.passwordsMustMatchHint =
        passwordsMustMatchHint ?? "The two passwords must match";
    this.loginTitle = loginTitle ?? "Login";
    this.loginDetails =
        loginDetails ?? "Fill in the details below to login to your account";
    this.loginButton = loginButton ?? "Login";
    this.forgotPasswordDetails = forgotPasswordDetails ?? "Forgot password?";
    this.verificationCodeTitle =
        verificationCodeTitle ?? "Enter provided verification code";
    this.alreadyHaveAccountDescription =
        alreadyHaveAccountDescription ?? "Already have an account?";
    this.registerDisabledTipNoteMessage = registerDisabledTipNoteMessage ??
        "Enter a valid password to create account";
  }
}

class NuntioTextStyle {
  late TextStyle titleStyle;
  late TextStyle descriptionStyle;
  late TextStyle bodyTextStyle;
  late TextStyle loginButtonTextStyle;
  late TextStyle registerButtonTextStyle;

  NuntioTextStyle({
    TextStyle? titleStyle,
    TextStyle? descriptionStyle,
    TextStyle? bodyTextStyle,
    TextStyle? loginButtonTextStyle,
    TextStyle? registerButtonTextStyle,
    required BuildContext context,
  }) {
    this.titleStyle =
        titleStyle ?? Theme.of(context).textTheme.titleLarge ?? TextStyle();
    this.descriptionStyle = descriptionStyle ??
        Theme.of(context)
            .textTheme
            .titleMedium
            ?.copyWith(color: CupertinoColors.black) ??
        TextStyle();
    this.bodyTextStyle = bodyTextStyle ??
        Theme.of(context)
            .textTheme
            .bodyText1
            ?.copyWith(color: CupertinoColors.black) ??
        TextStyle();
    this.loginButtonTextStyle = loginButtonTextStyle ??
        Theme.of(context)
            .textTheme
            .titleMedium
            ?.copyWith(color: CupertinoColors.white) ??
        TextStyle();
    this.registerButtonTextStyle = registerButtonTextStyle ??
        Theme.of(context).textTheme.titleMedium ??
        TextStyle();
  }
}

class NuntioColor {
  late Color primaryColor;
  late Color secondaryColor;
  late Color successColor;
  late Color errorColor;
  late Color disabledColor;

  NuntioColor({
    Color? primaryColor,
    Color? secondaryColor,
    Color? successColor,
    Color? errorColor,
    Color? disabledColor,
  }) {
    this.primaryColor = primaryColor ?? CupertinoColors.systemBlue;
    this.secondaryColor = secondaryColor ?? CupertinoColors.systemGrey6;
    this.successColor = successColor ?? CupertinoColors.systemBlue;
    this.errorColor = errorColor ?? CupertinoColors.systemRed;
    this.disabledColor = disabledColor ?? CupertinoColors.lightBackgroundGray;
  }
}

class NuntioStyle {
  late Border border;
  late Color borderColor;
  late double buttonWidth;
  late double buttonHeight;
  late double logoWidth;

  NuntioStyle({
    Border? border,
    Color? borderColor,
    double? buttonWidth,
    double? buttonHeight,
    double? logoWidth,
  }) {
    this.border = border ??
        Border.all(
          color: Color(0xffe2e2e2),
          width: 0.5,
        );
    this.borderColor = borderColor ?? CupertinoColors.white;
    this.buttonWidth = buttonWidth ?? 250;
    this.buttonHeight = buttonHeight ?? 55;
    this.logoWidth = logoWidth ?? 150;
  }
}

class NuntioFooter {
  late Widget footer;
  late double height;

  NuntioFooter({Widget? footer, double? height}) {
    this.footer = footer ?? SizedBox();
    this.height = height ?? 0.0;
  }
}
