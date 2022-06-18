import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class UserAnalytics extends StatefulWidget {
  final Widget child;

  UserAnalytics({required this.child});

  @override
  State<UserAnalytics> createState() => _UserAnalyticsState();
}

class _UserAnalyticsState extends State<UserAnalytics> {
  @override
  Widget build(BuildContext context) {
    return widget.child;
  }
}
