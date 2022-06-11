import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserAnalyticsWeb extends StatefulWidget {
  final Widget child;

  UserAnalyticsWeb({required this.child});

  @override
  State<UserAnalyticsWeb> createState() => _UserAnalyticsWebState();
}

class _UserAnalyticsWebState extends State<UserAnalyticsWeb> {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Colors.white,
      child: widget.child,
    );
  }
}
