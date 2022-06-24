import 'package:dart_blocks/dart_blocks/user_analytics/user_analytics_native.dart'
    if (dart.library.html) 'package:dart_blocks/dart_blocks/user_analytics/user_analytics_web.dart';
import 'package:flutter/cupertino.dart';

class NuntioUserAnalytics extends StatelessWidget {
  final Widget child;

  const NuntioUserAnalytics({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return UserAnalytics(child: child);
  }
}
