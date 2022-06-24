import 'dart:async';
import 'package:dart_blocks/dart_blocks/nuntio_client.dart';
import 'package:flutter/cupertino.dart';
import 'package:nuntio_blocks/block_user.pb.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';
import 'dart:html' as html;

import '../components/nuntio_indicator.dart';

class UserAnalytics extends StatefulWidget {
  final Widget child;

  UserAnalytics({required this.child}) {
    print("using Nuntio Hera web analytics");
  }

  @override
  State<UserAnalytics> createState() => _UserAnalyticsState();
}

class _UserAnalyticsState extends State<UserAnalytics> {
  // init
  late Future<void> initializeAnalyticsFuture;
  Timer? _timer;
  final String _activeKeySeconds = "nuntio-blocks-active-seconds";
  final String _activeKeyId = "nuntio-blocks-active-id";
  final String _activeKeyUserId = "nuntio-blocks-active-user-id";

  // _activeId is used to record how long user is active
  String _activeId = "";

  Future<void> _measureUserTime() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    try {
      if (_timer != null && _timer?.isActive == true) {
        _timer!.cancel();
      }
    } catch (e) {
      print(e);
    }
    // init new values
    const int _interval = 2;
    int _current = prefs.getInt(_activeKeySeconds) ?? 0;
    _activeId = prefs.getString(_activeId) ?? Uuid().v4();
    // every 1 seconds record time time. Send average of these every 5 minute to server.
    _timer = Timer.periodic(Duration(seconds: _interval), (timer) async {
      // make sure shared prefs is available
      User _currentUser = await NuntioClient.userBlock.getCurrentUser();
      if (_currentUser.id != "" && _activeId != "") {
        if ((prefs.getString(_activeKeyUserId) ?? "") == "") {
          await prefs.setString(_activeKeyUserId, _currentUser.id);
          await prefs.setString(_activeKeyId, _activeId);
        }
        //todo: only add when tab is active
        _current += _interval;
        await prefs.setInt(_activeKeySeconds, _current);
      }
    });
  }

  Future<void> initializeAnalytics() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final _prevTotalSeconds = prefs.getInt(_activeKeySeconds) ?? 0;
      final _prevActiveId = prefs.getString(_activeKeyId) ?? "";
      final _prevActiveUserId = prefs.getString(_activeKeyUserId) ?? "";
      if (_prevTotalSeconds > 0 &&
          _prevActiveId != "" &&
          _prevActiveUserId != "") {
        // remove old shared preferences
        await prefs.remove(_activeKeySeconds);
        await prefs.remove(_activeId);
        await prefs.remove(_activeKeyUserId);
        print("s:" +
            _prevTotalSeconds.toString() +
            " " +
            "active ID:" +
            _prevActiveId +
            " " +
            "user ID:" +
            _prevActiveUserId);
        await NuntioClient.userBlock.recordActiveMeasurement(
            _prevTotalSeconds, _prevActiveId, _prevActiveUserId);
        print("done sending data");
      }
    } catch (e) {
      print("an error occured");
      print(e);
      print("an error occurred");
    }
    _measureUserTime();
  }

  @override
  void initState() {
    initializeAnalyticsFuture = initializeAnalytics();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<void>(
        future: initializeAnalyticsFuture,
        builder: (context, snapshot) {
          switch (snapshot.connectionState) {
            case ConnectionState.waiting:
              return NuntioIndicator();
            case ConnectionState.done:
              return widget.child;
            default:
              return Text("Error");
          }
        });
  }
}
