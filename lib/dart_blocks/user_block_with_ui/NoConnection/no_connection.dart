import 'package:dart_blocks/dart_blocks/models/auth.dart';
import 'package:dart_blocks/dart_blocks/user_block_with_ui/AuthPage/LoginPage/login_page.dart';
import 'package:dart_blocks/dart_blocks/user_block_with_ui/AuthPage/RegisterPage/register_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NoConnection extends StatelessWidget {
  NoConnection({
    Key? key,
    required this.createdBy,
    required this.title,
    required this.details,
    required this.logo,
    required this.background,
    required this.primaryColor,
  });

  final Widget createdBy;
  final BoxDecoration background;
  final Widget logo;
  final Widget title;
  final Widget details;
  final Color primaryColor;

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
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
                title,
                const SizedBox(
                  height: 15,
                ),
                details,
                const Spacer(),
                SizedBox(),
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
