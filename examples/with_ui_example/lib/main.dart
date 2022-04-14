import 'package:dart_blocks/os_mobile_blocks/softcorp_client.dart';
import 'package:dart_blocks/os_mobile_blocks/user_block_with_ui/user_block_with_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SoftcorpClient.initialize(
    apiKey:
        "Enter your api key here",
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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Nuntio Example',
      home: UserBlockWithUI(
        child: const Text("test"),
        background: BoxDecoration(
          color: Colors.white,
        ),
        secondaryColor: Colors.blueAccent[700],
        textFieldBorder:                               Border.all(
          color: Colors.black12,
          width: 0.5,
        ),
      ),
    );
  }
}
