import 'dart:async';
import 'package:dart_blocks/dart_blocks/nuntio_client.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:pinput/pinput.dart';

class VerifyCodeSheet extends StatefulWidget {
  VerifyCodeSheet({
    Key? key,
    required this.verifyCodeTitle,
    required this.buttonHeight,
    required this.buttonWidth,
    required this.userEmail,
    required this.emailExpiresAt,
  }) : super(key: key);

  final String userEmail;
  final DateTime emailExpiresAt;
  final Widget verifyCodeTitle;
  final double buttonWidth;
  final double buttonHeight;

  @override
  State<VerifyCodeSheet> createState() => _VerifyCodeSheetState();
}

class _VerifyCodeSheetState extends State<VerifyCodeSheet> {
  final verifyCodeController = TextEditingController();
  DateTime _now = DateTime.now();
  bool _isLoading = false;
  bool _hasError = false;
  late Timer _timer;

  _VerifyCodeSheetState() {
    _timer = Timer.periodic(Duration(seconds: 1), (Timer t) {
      setState(() {
        _now = DateTime.now();
      });
      if (widget.emailExpiresAt.difference(_now).inSeconds <= 0) {
        Navigator.of(context).pop();
      }
    });
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  String formatTime(int totalSeconds) {
    final duration = Duration(seconds: totalSeconds);
    final minutes = duration.inMinutes;
    final seconds = totalSeconds % 60;

    final minutesString = '$minutes'.padLeft(2, '0');
    final secondsString = '$seconds'.padLeft(2, '0');
    return '$minutesString:$secondsString';
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoScaffold(
      transitionBackgroundColor: CupertinoColors.white,
      body: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          children: [
            widget.verifyCodeTitle,
            SizedBox(
              height: 50,
            ),
            Text(
              formatTime(widget.emailExpiresAt.difference(_now).inSeconds),
              style: Theme.of(context)
                  .textTheme
                  .displaySmall
                  ?.copyWith(color: CupertinoColors.black),
            ),
            SizedBox(
              height: 50,
            ),
            Card(
              elevation: 0,
              child: Pinput(
                length: 6,
                obscureText: false,
                enabled: true,
                hapticFeedbackType: HapticFeedbackType.mediumImpact,
                // set this based on expiration
                keyboardType: TextInputType.number,
                animationDuration: Duration(milliseconds: 300),
                controller: verifyCodeController,
                androidSmsAutofillMethod:
                    AndroidSmsAutofillMethod.smsRetrieverApi,
              ),
            ),
            if (!_hasError)
              SizedBox(
                height: 50,
              ),
            if (_hasError)
              SizedBox(
                height: 25,
              ),
            if (_hasError)
              Text(
                "Something went wrong. Please try again and make sure your code is valid.",
                style: TextStyle(color: CupertinoColors.systemRed),
              ),
            if (_hasError)
              SizedBox(
                height: 25,
              ),
            SizedBox(
              width: widget.buttonWidth,
              height: widget.buttonHeight,
              child: CupertinoButton(
                child: _isLoading
                    ? CupertinoActivityIndicator()
                    : Text(
                        "Verify your email",
                        style: TextStyle(color: Colors.white),
                      ),
                color: CupertinoColors.black,
                onPressed: () {
                  if (verifyCodeController.text.length == 6) {
                    setState(() {
                      _isLoading = true;
                    });
                    NuntioClient.userBlock
                        .verifyEmailCode(
                            code: verifyCodeController.text,
                            email: widget.userEmail)
                        .then((value) {
                      verifyCodeController.clear();
                      setState(() {
                        _isLoading = false;
                      });
                      Navigator.of(context).pop();
                    }).catchError((err) {
                      verifyCodeController.clear();
                      print(
                          "could not verify email with err: " + err.toString());
                      setState(() {
                        _hasError = true;
                        _isLoading = false;
                      });
                    });
                  }
                  if (_isLoading) {
                    return;
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
