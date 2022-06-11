import 'package:dart_blocks/dart_blocks/nuntio_client.dart';
import 'package:dart_blocks/dart_blocks/user_block_with_ui/ProfilePage/profile_card/profile_card.dart';
import 'package:dart_blocks/dart_blocks/user_block_with_ui/ProfilePage/update_email_dialog/update_email_dialog.dart';
import 'package:dart_blocks/dart_blocks/user_block_with_ui/ProfilePage/update_password_dialog/update_password_dialog.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nuntio_blocks/block_user.pb.dart';
import 'package:nuntio_blocks/google/protobuf/timestamp.pb.dart';

import 'button_card/button_card.dart';

class UserProfile extends StatefulWidget {
  UserProfile({
    Key? key,
    required this.changePasswordText,
    required this.changeEmailText,
    required this.logoutText,
    required this.onLogout,
    required this.changeEmailDescription,
    required this.newEmailHint,
    required this.changePasswordDescription,
    required this.newPasswordHint,
    required this.companyLogo,
    this.child,
    this.profileCardDecoration,
  }) : super(key: key);

  final Widget changePasswordText;
  final Widget changePasswordDescription;
  final Widget changeEmailText;
  final Widget changeEmailDescription;
  final String newPasswordHint;
  final String newEmailHint;
  final Widget logoutText;
  final Widget companyLogo;
  final Function onLogout;
  final Widget? child;
  final BoxDecoration? profileCardDecoration;

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile> {
  late Future<User> currentUserFuture;

  TextEditingController passwordController = TextEditingController();

  bool isLoading = false;

  Future<User> initializeProfile() async {
    User _user = await NuntioClient.userBlock.getCurrentUser();
    return _user;
  }

  _UserProfileState() {
    currentUserFuture = initializeProfile();
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
                padding: const EdgeInsets.only(left: 14, right: 14),
                child: Column(
                  children: [
                    const SizedBox(
                      height: 20,
                    ),
                    ProfileCard(
                      companyLogo: widget.companyLogo,
                      profileCardDecoration: widget.profileCardDecoration,
                      image: snapshot.data?.image,
                      name: snapshot.data?.firstName != null
                          ? (snapshot.data?.firstName ?? "") +
                              " " +
                              (snapshot.data?.lastName ?? "")
                          : "",
                      email: snapshot.data?.email,
                      dateTime: snapshot.data?.birthdate != null &&
                              snapshot.data?.birthdate != Timestamp()
                          ? snapshot.data?.birthdate.toDateTime()
                          : null,
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
                            userId: (snapshot.data ?? User()).id,
                            emailErrorText: Text(
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
