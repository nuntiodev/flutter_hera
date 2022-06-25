import 'dart:async';
import 'package:dart_blocks/dart_blocks/hera_app/AuthPage/LoginPage/login_page.dart';
import 'package:dart_blocks/dart_blocks/hera_app/NoConnection/no_connection.dart';
import 'package:dart_blocks/dart_blocks/models/auth.dart';
import 'package:dart_blocks/dart_blocks/nuntio_client.dart';
import 'package:dart_blocks/dart_blocks/user_analytics/nuntio_user_analytics.dart';
import 'package:flutter/cupertino.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:nuntio_blocks/block_user.pb.dart';
import '../components/nuntio_indicator.dart';
import '../hera_app/models.dart';

class HeraApp extends StatefulWidget {
  HeraApp({
    Key? key,
    required this.child,
    required this.loginType,
    this.nuntioText,
    this.nuntioColor,
    this.nuntioTextStyle,
    this.nuntioStyle,
    NuntioFooter? nuntioFooter,
    this.logo,
  }) {
    if (loginType == LoginType.LOGIN_TYPE_INVALID) {
      identifierInputType = TextInputType.none;
    } else if (loginType == LoginType.LOGIN_TYPE_EMAIL_PASSWORD ||
        loginType == LoginType.LOGIN_TYPE_EMAIL_VERIFICATION_CODE) {
      identifierInputType = TextInputType.emailAddress;
    } else if (loginType == LoginType.LOGIN_TYPE_PHONE_PASSWORD ||
        loginType == LoginType.LOGIN_TYPE_PHONE_VERIFICATION_CODE) {
      identifierInputType = TextInputType.phone;
    } else {
      // todo: throw error hera and match on username
      identifierInputType = TextInputType.text;
    }
    this.nuntioFooter = nuntioFooter ?? NuntioFooter();
  }

  // style and text config
  final NuntioStyle? nuntioStyle;
  final NuntioText? nuntioText;
  final NuntioColor? nuntioColor;
  final NuntioTextStyle? nuntioTextStyle;
  late final NuntioFooter nuntioFooter;
  late TextInputType identifierInputType;

  // general
  final Widget child;
  final Widget? logo;
  final LoginType loginType;

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
    NuntioStyle nuntioStyle =
        widget.nuntioStyle ?? NuntioStyle(context: context);
    NuntioText nuntioText = widget.nuntioText ?? NuntioText();
    NuntioColor nuntioColor =
        widget.nuntioColor ?? NuntioColor(context: context);
    NuntioTextStyle nuntioTextStyle =
        widget.nuntioTextStyle ?? NuntioTextStyle(context: context);
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
              return CupertinoApp(
                debugShowCheckedModeBanner: false,
                home: LoginPage(
                  identifierInputType: widget.identifierInputType,
                  nuntioFooter: widget.nuntioFooter,
                  logo: widget.logo ??
                      SvgPicture.network(
                        _config.logo,
                        height: nuntioStyle.logoHeight,
                        placeholderBuilder: (context) {
                          return Image(
                            image: NetworkImage(_config.logo),
                            height: nuntioStyle.logoHeight,
                          );
                        },
                      ),
                  nuntioText: nuntioText,
                  nuntioColor: nuntioColor,
                  nuntioStyle: nuntioStyle,
                  nuntioTextStyle: nuntioTextStyle,
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
                  background: nuntioStyle.background,
                  config: _config,
                ),
              );
            } else {
              return CupertinoApp(
                debugShowCheckedModeBanner: false,
                home: NoConnection(
                  background: nuntioStyle.background,
                  logo: widget.logo ??
                      Image(
                        image: NetworkImage(_config.logo),
                        height: nuntioStyle.logoHeight,
                      ),
                  nuntioText: nuntioText,
                  nuntioTextStyle: nuntioTextStyle,
                  nuntioColor: nuntioColor,
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
