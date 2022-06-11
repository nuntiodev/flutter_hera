import 'dart:async';

import 'package:dart_blocks/dart_blocks/nuntio_client.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nuntio_blocks/block_user.pb.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uuid/uuid.dart';

class UserAnalytics extends StatefulWidget {
  final Widget child;

  UserAnalytics({required this.child});

  @override
  State<UserAnalytics> createState() => _UserAnalyticsState();
}

class _UserAnalyticsState extends State<UserAnalytics>
    with WidgetsBindingObserver {

  // init
  late Future<void> initializeAnalyticsFuture;
  late Timer? _timer;
  final String _activeKeySeconds = "nuntio-blocks-active-seconds";
  final String _activeKeyId = "nuntio-blocks-active-id";
  final String _activeKeyUserId = "nuntio-blocks-active-user-id";
  late final SharedPreferences? _prefs;

  // _activeId is used to record how long user is active
  String _activeId = "";

  Future<void> initializeAnalytics() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<void> _measureUserTime() async {
    try {
      if (_timer != null && _timer!.isActive) {
        _timer!.cancel();
      }
      if (_prefs != null) {
        await _prefs!.remove(_activeId);
        await _prefs!.remove(_activeKeyUserId);
        await _prefs!.remove(_activeKeyId);
      }
    } catch (e) {
      print(e);
    }
    // init new values
    const int _interval = 2;
    int _current = 0;
    _activeId = Uuid().v4();
    // every 1 seconds record time time. Send average of these every 5 minute to server.
    _timer = Timer.periodic(Duration(seconds: _interval), (timer) async {
      // make sure shared prefs is available
      if (_prefs != null) {
        User _currentUser = await NuntioClient.userBlock.getCurrentUser();
        if (_currentUser.id != "" && _activeId != "") {
          if ((_prefs!.getString(_activeKeyUserId) ?? "") == "") {
            await _prefs!.setString(_activeKeyUserId, _currentUser.id);
            await _prefs!.setString(_activeKeyId, _activeId);
          }
          _current += _interval;
          await _prefs!.setInt(_activeKeySeconds, _current);
        }
      }
    });
  }

  _UserAnalyticsState() {
    initializeAnalyticsFuture = initializeAnalytics();
  }

  @override
  void initState() {
    WidgetsBinding.instance.addObserver(this);
    _measureUserTime();
    super.initState();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) async {
    if (state == AppLifecycleState.paused) {
      // check if previous session has id
      if (_prefs != null) {
        try {
          final _prevTotalSeconds = _prefs!.getInt(_activeKeySeconds) ?? 0;
          final _prevActiveId = _prefs!.getString(_activeKeyId) ?? "";
          final _prevActiveUserId = _prefs!.getString(_activeKeyUserId) ?? "";
          if (_prevTotalSeconds > 0 &&
              _prevActiveId != "" &&
              _prevActiveUserId != "") {
            await NuntioClient.userBlock.recordActiveMeasurement(
                _prevTotalSeconds, _prevActiveId, _prevActiveUserId);
          }
        } catch (e) {
          print(e);
        }
        if (_timer != null && _timer!.isActive) {
          _timer!.cancel();
        }
      }
    } else if (state == AppLifecycleState.resumed) {
      await _measureUserTime();
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: Colors.white,
      child: FutureBuilder<void>(
          future: initializeAnalyticsFuture,
          builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
            switch (snapshot.connectionState) {
              case ConnectionState.waiting:
                return const Center(
                  child: CupertinoActivityIndicator(),
                );
              case ConnectionState.done:
                return widget.child;
              default:
                return Text("Error");
            }
          }),
    );
  }
}
