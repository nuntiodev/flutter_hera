import 'dart:async';
import 'package:dart_blocks/dart_blocks/nuntio_client.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pin_code_fields/pin_code_fields.dart';

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
    return SizedBox(
      height: 600,
      child: Scaffold(
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
              PinCodeTextField(
                length: 6,
                obscureText: false,
                animationType: AnimationType.fade,
                enabled: true,
                // set this based on expiration
                cursorColor: CupertinoColors.white,
                enablePinAutofill: true,
                useHapticFeedback: true,
                hapticFeedbackTypes: HapticFeedbackTypes.medium,
                keyboardType: TextInputType.number,
                pinTheme: PinTheme(
                  activeColor: Colors.grey[300],
                  shape: PinCodeFieldShape.box,
                  borderRadius: BorderRadius.circular(5),
                  fieldHeight: 50,
                  fieldWidth: 40,
                  activeFillColor: CupertinoColors.white,
                  selectedFillColor: CupertinoColors.white,
                  errorBorderColor: CupertinoColors.systemRed,
                  inactiveColor: CupertinoColors.lightBackgroundGray,
                  inactiveFillColor: CupertinoColors.lightBackgroundGray,
                  selectedColor: _hasError
                      ? CupertinoColors.systemRed
                      : CupertinoColors.activeBlue,
                ),
                animationDuration: Duration(milliseconds: 300),
                enableActiveFill: true,
                controller: verifyCodeController,
                beforeTextPaste: (text) {
                  print("Allowing to paste $text");
                  //if you return true then it will show the paste confirmation dialog. Otherwise if false, then nothing will happen.
                  //but you can show anything you want here, like your pop up saying wrong paste format or etc
                  return true;
                },
                appContext: context,
                onChanged: (String value) {},
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
                        print("could not verify email with err: " +
                            err.toString());
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
      ),
    );
  }
}
