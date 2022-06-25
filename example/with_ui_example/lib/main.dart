import 'package:dart_blocks/dart_blocks/hera_app/hera_app.dart';
import 'package:dart_blocks/dart_blocks/hera_app/models.dart';
import 'package:dart_blocks/dart_blocks/nuntio_client.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:with_ui_example/home/home.dart';
import 'package:nuntio_blocks/block_user.pb.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await NuntioClient.initialize(
    apiKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJwcm9qZWN0SWQiOiJudW50aW8tY2xvdWQtaWQiLCJwYXNzd29yZCI6Ilx1MDAyNjd5TFhmNlVyNjhZMHcjTnleflF4bzlNW2FrYW1yZlJiMz0rUGVWTyh9QH0tYHRJKz1adWc1bi1AXmVbM0JcdTAwM2NZIiwidHlwZSI6MSwianRpIjoiODY3YmU4MGQtOGI2YS00ZWJkLTkxOGEtZmE0NDY4ZWNmOTM1IiwiaXNzIjoiTnVudGlvIENsb3VkIn0.kDEsyoM3yvtSih-taStB9zuMkxYjIxNRCq_zbh7zV9s",
    encryptionKey:
        "42704c6e6667447363325744384632714e66484b356138346a6a4a6b777a446b",
    debug: true,
  );
  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return CupertinoApp(
      debugShowCheckedModeBanner: false,
      home: Builder(builder: (_context) {
        return HeraApp(
          nuntioFooter: NuntioFooter(
            height: 100,
          ),
          loginType: LoginType.LOGIN_TYPE_EMAIL_PASSWORD,
          child: Home(),
        );
      }),
    );
  }
}
