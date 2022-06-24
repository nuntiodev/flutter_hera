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
  late String identifierName;
  late String passwordName;
  late String repeatPasswordName;

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

  // verify page
  late String verifyIdentifierTitle;
  late String verifyIdentifierDescription;
  late String verifyButton;
  late String invalidCodeTitle;
  late String invalidCodeDescription;

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
    String? verifyIdentifierTitle,
    String? verifyIdentifierDescription,
    String? verifyButton,
    String? invalidCodeTitle,
    String? invalidCodeDescription,
    String? identifierName,
    String? passwordName,
    String? repeatPasswordName,
  }) {
    this.passwordHint = passwordHint ?? "JohnDoe1234!";
    this.identifierHint = identifierHint ?? "your@email.io";
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
    this.verifyIdentifierTitle = verifyIdentifierTitle ?? "Verify your account";
    this.verifyIdentifierDescription = verifyIdentifierDescription ??
        "We have sent you a verification code. Please enter the code below.";
    this.verifyButton = verifyButton ?? "Verify account";
    this.invalidCodeTitle = invalidCodeTitle ?? "Invalid code";
    this.invalidCodeDescription =
        invalidCodeDescription ?? "The code that you have provided is invalid";
    this.identifierName = identifierName ?? "Email";
    this.passwordName = passwordName ?? "Password";
    this.repeatPasswordName = repeatPasswordName ?? "Repeat password";
  }
}

class NuntioTextStyle {
  late TextStyle titleStyle;
  late TextStyle descriptionStyle;
  late TextStyle bodyTextStyle;
  late TextStyle loginButtonTextStyle;
  late TextStyle registerButtonTextStyle;
  late TextStyle labelStyle;

  NuntioTextStyle({
    TextStyle? titleStyle,
    TextStyle? descriptionStyle,
    TextStyle? bodyTextStyle,
    TextStyle? loginButtonTextStyle,
    TextStyle? registerButtonTextStyle,
    TextStyle? labelStyle,
    required BuildContext context,
  }) {
    this.titleStyle = titleStyle ??
        Theme.of(context)
            .textTheme
            .titleLarge
            ?.copyWith(fontWeight: FontWeight.bold, fontSize: 32) ??
        TextStyle();
    this.descriptionStyle = descriptionStyle ??
        Theme.of(context).textTheme.titleMedium?.copyWith(
              color: CupertinoColors.systemGrey,
              fontSize: 18,
            ) ??
        TextStyle();
    this.bodyTextStyle = bodyTextStyle ??
        Theme.of(context)
            .textTheme
            .bodyText1
            ?.copyWith(color: CupertinoColors.black) ??
        TextStyle();
    this.loginButtonTextStyle = loginButtonTextStyle ??
        Theme.of(context).textTheme.titleMedium?.copyWith(
            color: CupertinoColors.white, fontWeight: FontWeight.w500) ??
        TextStyle();
    this.registerButtonTextStyle = registerButtonTextStyle ??
        Theme.of(context)
            .textTheme
            .titleMedium
            ?.copyWith(fontWeight: FontWeight.w500) ??
        TextStyle();
    this.labelStyle = labelStyle ??
        Theme.of(context)
            .textTheme
            .labelLarge
            ?.copyWith(fontWeight: FontWeight.bold) ??
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
    this.primaryColor = primaryColor ?? CupertinoColors.black;
    this.secondaryColor = secondaryColor ?? CupertinoColors.systemGrey6;
    this.successColor = successColor ?? CupertinoColors.systemBlue;
    this.errorColor = errorColor ?? CupertinoColors.systemRed;
    this.disabledColor = disabledColor ?? CupertinoColors.lightBackgroundGray;
  }
}

class NuntioStyle {
  late Color borderColor;
  late Color textFieldColor;
  late double buttonWidth;
  late double buttonHeight;
  late double logoHeight;
  NuntioStyle({
    Border? border,
    Color? borderColor,
    Color? textFieldColor,
    double? buttonWidth,
    double? buttonHeight,
    double? logoHeight,
  }) {
    this.borderColor = borderColor ?? CupertinoColors.systemGrey5;
    this.textFieldColor = textFieldColor ?? CupertinoColors.white;
    this.buttonWidth = buttonWidth ?? double.infinity;
    this.buttonHeight = buttonHeight ?? 50;
    this.logoHeight = logoHeight ?? 120;
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
