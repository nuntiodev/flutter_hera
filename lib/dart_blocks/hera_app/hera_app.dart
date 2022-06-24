import 'dart:async';
import 'package:dart_blocks/dart_blocks/hera_app/AuthPage/LoginPage/login_page.dart';
import 'package:dart_blocks/dart_blocks/hera_app/NoConnection/no_connection.dart';
import 'package:dart_blocks/dart_blocks/models/auth.dart';
import 'package:dart_blocks/dart_blocks/nuntio_client.dart';
import 'package:dart_blocks/dart_blocks/user_analytics/nuntio_user_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:nuntio_blocks/block_user.pb.dart';
import '../components/nuntio_indicator.dart';
import '../hera_app/models.dart';

class HeraApp extends StatefulWidget {
  HeraApp({
    Key? key,
    required BuildContext context,
    this.identifierInputType,
    required this.child,
    NuntioText? nuntioText,
    NuntioColor? nuntioColor,
    NuntioTextStyle? nuntioTextStyle,
    NuntioStyle? nuntioStyle,
    NuntioFooter? nuntioFooter,
    this.logo,
    this.background,
  }) {
    if (identifierInputType != null &&
        identifierInputType != TextInputType.emailAddress &&
        identifierInputType != TextInputType.phone &&
        identifierInputType != TextInputType.text) {
      throw Exception(
          "invalid identifierInputType, value must equal TextInputType.emailAddress (email), TextInputType.phone (phone) or TextInputType.text (username)");
    }
    this.nuntioStyle = nuntioStyle ?? NuntioStyle();
    this.nuntioText = nuntioText ?? NuntioText();
    this.nuntioColor = nuntioColor ?? NuntioColor();
    this.nuntioTextStyle = nuntioTextStyle ?? NuntioTextStyle(context: context);
    this.nuntioFooter = nuntioFooter ?? NuntioFooter();
  }

  // style and text config
  late final NuntioStyle nuntioStyle;
  late final NuntioText nuntioText;
  late final NuntioColor nuntioColor;
  late final NuntioTextStyle nuntioTextStyle;
  late final NuntioFooter nuntioFooter;

  // general
  final Widget child;
  final Widget? logo;
  final TextInputType? identifierInputType;

  // style
  final BoxDecoration? background;

  // on authenticated go to child;
  @override
  State<HeraApp> createState() => _HeraAppState();
}

class _HeraAppState extends State<HeraApp> {
  // init
  late Future<AuthState> initializeNuntioUIFuture;
  late Config _config;

  Future<void> initializeConfig() async {
    _config = await NuntioClient.userBlock.initializeApplication();
    return;
  }

  Future<AuthState> initializeAuthStatus() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.none) {
      //  no data connection
      return AuthState.noConnection;
    }
    bool isAuthenticated = await NuntioClient.userBlock.isAuthenticated();
    if (isAuthenticated) {
      return AuthState.authenticated;
    }
    return AuthState.notAuthenticated;
  }

  Future<AuthState> initializeNuntioUI() async {
    await initializeConfig();
    return await initializeAuthStatus();
  }

  _HeraAppState() {
    initializeNuntioUIFuture = initializeNuntioUI();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<AuthState>(
      future: initializeNuntioUIFuture,
      builder: (BuildContext context, AsyncSnapshot<AuthState> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.waiting:
            return Center(
              child: NuntioIndicator(),
            );
          case ConnectionState.done:
            if (snapshot.data == AuthState.authenticated) {
              return NuntioUserAnalytics(
                child: widget.child,
              );
            }
            if (snapshot.data == null ||
                snapshot.data == AuthState.notAuthenticated) {
              return Theme(
                data: ThemeData(
                  textTheme: GoogleFonts.interTextTheme(Theme.of(context).textTheme),
                ),
                child: CupertinoApp(
                  debugShowCheckedModeBanner: false,
                  home: LoginPage(
                    identifierInputType:
                        widget.identifierInputType ?? TextInputType.emailAddress,
                    nuntioFooter: widget.nuntioFooter,
                    logo: widget.logo ??
                        SvgPicture.network(
                          _config.logo,
                          height: widget.nuntioStyle.logoHeight,
                          placeholderBuilder: (context) {
                            return Image(
                              image: NetworkImage(_config.logo),
                              height: widget.nuntioStyle.logoHeight,
                            );
                          },
                        ),
                    nuntioText: widget.nuntioText,
                    nuntioColor: widget.nuntioColor,
                    nuntioStyle: widget.nuntioStyle,
                    nuntioTextStyle: widget.nuntioTextStyle,
                    onLogin: (BuildContext buildContext) {
                      Navigator.of(buildContext).pushReplacement(
                        CupertinoPageRoute(builder: (context) => widget.child),
                      );
                    },
                    onRegister: (BuildContext buildContext) {
                      Navigator.of(buildContext).pushReplacement(
                        CupertinoPageRoute(builder: (context) => widget.child),
                      );
                    },
                    background: widget.background ??
                        BoxDecoration(color: CupertinoColors.white),
                    config: _config,
                  ),
                ),
              );
            } else {
              return CupertinoApp(
                debugShowCheckedModeBanner: false,
                home: NoConnection(
                  background: widget.background ??
                      BoxDecoration(color: CupertinoColors.white),
                  logo: widget.logo ??
                      Image(
                        image: NetworkImage(_config.logo),
                        height: widget.nuntioStyle.logoHeight,
                      ),
                  nuntioText: widget.nuntioText,
                  nuntioTextStyle: widget.nuntioTextStyle,
                  nuntioColor: widget.nuntioColor,
                ),
              );
            }
          default:
            return Text("Error");
        }
      },
    );
  }
}
