import 'package:cached_network_image/cached_network_image.dart';
import 'package:dart_blocks/dart_blocks/helpers/validate_email.dart';
import 'package:dart_blocks/dart_blocks/nuntio_client.dart';
import 'package:dart_blocks/dart_blocks/user_block_with_ui/ProfilePage/profile_avatar/profile_avatar.dart';
import 'package:dart_blocks/dart_blocks/user_block_with_ui/ProfilePage/update_email_dialog/update_email_dialog.dart';
import 'package:dart_blocks/dart_blocks/user_block_with_ui/ProfilePage/update_password_dialog/update_password_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nuntio_blocks/block_user.pb.dart';

import 'button_card/button_card.dart';

class UserProfile extends StatefulWidget {
  UserProfile({
    Key? key,
    required this.profileTitle,
    required this.changePasswordText,
    required this.changeEmailText,
    required this.logoutText,
    required this.onLogout,
    required this.changeEmailDescription,
    required this.newEmailHint,
    required this.changePasswordDescription,
    required this.newPasswordHint,
    this.child,
    this.profileCardDecoration,
  }) : super(key: key);

  final Widget profileTitle;
  final Widget changePasswordText;
  final Widget changePasswordDescription;
  final Widget changeEmailText;
  final Widget changeEmailDescription;
  final String newPasswordHint;
  final String newEmailHint;
  final Widget logoutText;
  final Function onLogout;
  final Widget? child;
  final BoxDecoration? profileCardDecoration;

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  late Future<User> currentUserFuture;

  TextEditingController passwordController = TextEditingController();

  _UserProfileState() {
    currentUserFuture = NuntioClient.userBlock.getCurrentUser();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<User>(
      future: currentUserFuture,
      builder: (BuildContext context, AsyncSnapshot<User> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return const Center(
              child: CupertinoActivityIndicator(),
            );
          case ConnectionState.done:
            return SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.only(left: 10, right: 10),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 10,
                    ),
                    SizedBox(
                      height: 150,
                      child: Container(
                        padding: EdgeInsets.all(10),
                        decoration: widget.profileCardDecoration ??
                            BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Color(0xff686FFF),
                                  Color(0xff0512FF),
                                ],
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                              ),
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            ProfileAvatar(
                              imageUrl: (snapshot.data ?? User()).image,
                              background: BoxDecoration(
                                color: CupertinoColors.white.withOpacity(0.2),
                              ),
                              border: Border.all(
                                width: 2,
                                color: CupertinoColors.white,
                              ),
                              radius: 44,
                            ),
                            SizedBox(
                              width: 20,
                            ),
                            Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  "Nuntio Profile",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleSmall
                                      ?.copyWith(
                                        color: CupertinoColors.white,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                                SizedBox(
                                  height: 3,
                                ),
                                Text(
                                  (snapshot.data ?? User()).email,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                        color: CupertinoColors.white,
                                        fontSize: 22,
                                      ),
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  (snapshot.data ?? User()).firstName +
                                      " " +
                                      (snapshot.data ?? User()).lastName,
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        color: CupertinoColors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                ),
                                SizedBox(
                                  height: 5,
                                ),
                                Text(
                                  (snapshot.data ?? User()).birthdate.isFrozen
                                      ? (snapshot.data ?? User())
                                          .birthdate
                                          .toDateTime()
                                          .toLocal()
                                          .toIso8601String()
                                      : "",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium
                                      ?.copyWith(
                                        color: CupertinoColors.white,
                                        fontWeight: FontWeight.w500,
                                      ),
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  maxLines: 2,
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    const SizedBox(
                      height: 20,
                    ),
                    ButtonCard(
                      onClick: () {
                        showCupertinoDialog(
                          context: context,
                          builder: (context) => UpdateEmailDialog(
                            newEmailHint: widget.newEmailHint,
                            changeEmailText: widget.changeEmailText,
                            changeEmailDescription:
                                widget.changeEmailDescription,
                            userId: (snapshot.data ?? User()).id, emailErrorText: Text(
                            "Something went wrong. Please make sure that you have provided a correct email.",
                            style:
                            TextStyle(color: CupertinoColors.systemRed),
                          ),
                          ),
                        ).then((value) {
                          if (value == true) {
                            setState(() {
                              currentUserFuture =
                                  NuntioClient.userBlock.getCurrentUser();
                            });
                          }
                        });
                      },
                      text: widget.changeEmailText,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ButtonCard(
                      onClick: () {
                        showCupertinoDialog(
                          context: context,
                          builder: (context) => UpdatePasswordDialog(
                            passwordErrorText: Text(
                              "Something went wrong. Please make sure that you have provided a valid password. That is, a password that contains a number, special character and is longer than 8 chars.",
                              style:
                                  TextStyle(color: CupertinoColors.systemRed),
                            ),
                            newPasswordHint: widget.newPasswordHint,
                            changePasswordText: widget.changePasswordText,
                            changePasswordDescription:
                                widget.changePasswordDescription,
                            userId: (snapshot.data ?? User()).id,
                          ),
                        );
                      },
                      text: widget.changePasswordText,
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    ButtonCard(
                      onClick: () {
                        NuntioClient.userBlock.logout().then((value) {
                          widget.onLogout();
                        });
                      },
                      text: widget.logoutText,
                    ),
                    SizedBox(
                      height: 20,
                    ),
                    widget.child ?? SizedBox(),
                  ],
                ),
              ),
            );
          default:
            return Text("Error");
        }
      },
    );
  }
}
