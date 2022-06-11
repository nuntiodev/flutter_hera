import 'package:dart_blocks/dart_blocks/models/auth.dart';
import 'package:dart_blocks/dart_blocks/user_block_with_ui/AuthPage/LoginPage/login_page.dart';
import 'package:dart_blocks/dart_blocks/user_block_with_ui/AuthPage/RegisterPage/register_page.dart';
import 'package:dart_blocks/dart_blocks/user_block_with_ui/models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NoConnection extends StatelessWidget {
  NoConnection({
    Key? key,
    required this.logo,
    required this.background,
    required this.nuntioText,
    required this.nuntioTextStyle,
    required this.nuntioColor,
  });

  final BoxDecoration background;
  final Widget logo;
  final NuntioText nuntioText;
  final NuntioTextStyle nuntioTextStyle;
  final NuntioColor nuntioColor;

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
                Text(
                  nuntioText.noWifiTitle,
                  style: nuntioTextStyle.titleStyle,
                ),
                const SizedBox(
                  height: 15,
                ),
                Text(
                  nuntioText.noWifiDescription,
                  style: nuntioTextStyle.descriptionStyle,
                ),
                const Spacer(),
                SizedBox(),
                Spacer(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
