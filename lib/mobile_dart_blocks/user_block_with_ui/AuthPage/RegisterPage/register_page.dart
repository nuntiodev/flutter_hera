import 'package:dart_blocks/mobile_dart_blocks/softcorp_client.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../../../components/text_field_decoration.dart';

class RegisterPage extends StatelessWidget {
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
  }) : super(key: key);

  final bool validatePassword;
  final Widget buttonText;
  final BoxDecoration background;
  final Color secondaryColor;
  final Color primaryColor;
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

  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final repeatPasswordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: false,
      navigationBar: CupertinoNavigationBar(
        automaticallyImplyMiddle: true,
        backgroundColor: Colors.transparent,
        border: null,
        middle: title,
        leading: CupertinoButton(
          child: Icon(
            Icons.arrow_back_ios,
            color: primaryColor,
          ),
          onPressed: () => Navigator.pop(context),
        ),
      ),
      child: Container(
        decoration: background,
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: <Widget>[
              const SizedBox(
                height: 100,
              ),
              details,
              const SizedBox(
                height: 30,
              ),
              logo,
              const SizedBox(
                height: 30,
              ),
              SizedBox(
                height: 40,
                child: CupertinoTextField(
                  decoration:
                      textFieldDecoration(textFieldBorder, textFieldColor),
                  controller: emailController,
                  placeholder: emailHint,
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              SizedBox(
                height: 40,
                child: CupertinoTextField(
                  decoration:
                      textFieldDecoration(textFieldBorder, textFieldColor),
                  controller: passwordController,
                  obscureText: true,
                  placeholder: passwordHint,
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
                  decoration:
                      textFieldDecoration(textFieldBorder, textFieldColor),
                  controller: repeatPasswordController,
                  obscureText: true,
                  placeholder: repeatPasswordHint,
                  keyboardType: TextInputType.text,
                  maxLength: 80,
                ),
              ),
              const SizedBox(
                height: 50,
              ),
              SizedBox(
                width: 250,
                child: CupertinoButton(
                  color: secondaryColor,
                  onPressed: () {
                    if (emailController.text.isEmpty) {
                      showCupertinoDialog(
                          context: context,
                          builder: (context) {
                            return CupertinoAlertDialog(
                              title: Text(missingEmailTitle),
                              content: Text(missingPasswordDetails),
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
                              title: Text(missingPasswordTitle),
                              content: Text(missingPasswordDetails),
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
                              title: Text(passwordDoNotMatchTitle),
                              content: Text(passwordDoNotMatchDetails),
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
                    SoftcorpClient.userBlock
                        .login(
                            password: passwordController.text,
                            email: emailController.text)
                        .catchError((err) => {
                              passwordController.text = "",
                              emailController.text = "",
                              showCupertinoDialog(
                                  context: context,
                                  builder: (context) {
                                    return CupertinoAlertDialog(
                                      title: Text(invalidTitle),
                                      content: Text(invalidDetails),
                                      actions: <Widget>[
                                        TextButton(
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: const Text('okay'))
                                      ],
                                    );
                                  })
                            })
                        .then((user) => {onRegister()});
                  },
                  child: buttonText,
                ),
              ),
              const Spacer(),
              createdBy,
            ],
          ),
        ),
      ),
    );
  }
}
