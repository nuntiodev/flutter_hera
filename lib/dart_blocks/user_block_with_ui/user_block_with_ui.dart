import 'dart:async';
import 'package:dart_blocks/dart_blocks/models/auth.dart';
import 'package:dart_blocks/dart_blocks/nuntio_client.dart';
import 'package:dart_blocks/dart_blocks/user_block_with_ui/AuthPage/LoginPage/login_page.dart';
import 'package:dart_blocks/dart_blocks/user_block_with_ui/NoConnection/no_connection.dart';
import 'package:dart_blocks/dart_blocks/user_block_with_ui/models.dart';
import 'package:flutter/cupertino.dart';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/foundation.dart';
import 'package:nuntio_blocks/block_user.pb.dart';

class UserBlockWithUI extends StatefulWidget {
  UserBlockWithUI({
    Key? key,
    required this.child,
    required BuildContext context,
    NuntioText? nuntioText,
    NuntioColor? nuntioColor,
    NuntioTextStyle? nuntioTextStyle,
    NuntioStyle? nuntioStyle,
    this.onRegister,
    this.onLogin,
    this.logo,
    this.background,
  }) {
    this.nuntioStyle = nuntioStyle ?? NuntioStyle();
    this.nuntioText = nuntioText ?? NuntioText();
    this.nuntioColor = nuntioColor ?? NuntioColor();
    this.nuntioTextStyle = nuntioTextStyle ?? NuntioTextStyle(context: context);
  }

  // style and text config
  late final NuntioStyle nuntioStyle;
  late final NuntioText nuntioText;
  late final NuntioColor nuntioColor;
  late final NuntioTextStyle nuntioTextStyle;

  // general
  final Widget child;
  final Widget? logo;

  // style
  final BoxDecoration? background;

  // functions
  final Function? onRegister;
  final Function? onLogin;

  // on authenticated go to child;
  @override
  State<UserBlockWithUI> createState() => _UserBlockWithUIState();
}

class _UserBlockWithUIState extends State<UserBlockWithUI> {
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

  _UserBlockWithUIState() {
    initializeNuntioUIFuture = initializeNuntioUI();
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      resizeToAvoidBottomInset: false,
      backgroundColor: CupertinoColors.systemBackground,
      child: FutureBuilder<AuthState>(
        future: initializeNuntioUIFuture,
        builder: (BuildContext context, AsyncSnapshot<AuthState> snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return const Center(
                child: CupertinoActivityIndicator(),
              );
            case ConnectionState.done:
              if (snapshot.data == AuthState.authenticated) {
                return widget.child;
              } else if (snapshot.data == null ||
                  snapshot.data == AuthState.notAuthenticated) {
                return LoginPage(
                  logo: widget.logo ??
                      Image(
                        image: NetworkImage(_config.logo),
                        width: 150,
                      ),
                  nuntioText: widget.nuntioText,
                  nuntioColor: widget.nuntioColor,
                  nuntioStyle: widget.nuntioStyle,
                  nuntioTextStyle: widget.nuntioTextStyle,
                  onLogin: widget.onLogin ?? () => {},
                  onRegister: widget.onRegister ?? () => {},
                  background: widget.background ??
                      BoxDecoration(color: CupertinoColors.white),
                  config: _config,
                );
              } else {
                print(snapshot.data);
                return NoConnection(
                  background: widget.background ??
                      BoxDecoration(color: CupertinoColors.white),
                  logo: widget.logo ??
                      Image(
                        image: NetworkImage(_config.logo),
                        width: 150,
                      ),
                  nuntioText: widget.nuntioText,
                  nuntioTextStyle: widget.nuntioTextStyle,
                  nuntioColor: widget.nuntioColor,
                );
              }
            default:
              return Text("Error");
          }
        },
      ),
    );
  }
}
