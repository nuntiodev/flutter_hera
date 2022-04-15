import 'package:dart_blocks/dart_blocks/softcorp_client.dart';
import 'package:dart_blocks/dart_blocks/user_block_with_ui/user_block_with_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await SoftcorpClient.initialize(
    apiKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJwcm9qZWN0SWQiOiJzb2Z0Y29ycC1jbG91ZC1pZCIsInBhc3N3b3JkIjoiYnp3bkc4ZHslLm0yWEd0XHUwMDNlYTdcdTAwMjZBT2NRNVFqQWFyMWo9bXR1XVVoc3QjIS5oTilbOmlVNXVcdTAwMjZERlwiWzJ5TlkqOC0iLCJqdGkiOiI3Yzk3NzhlNS00MTBjLTQyNGYtYmQ0MC00MGYyNWRiNDEzOGQiLCJpc3MiOiJTb2Z0Y29ycCBDbG91ZCJ9.m_Qe8isPMW7J6fzoQHDpI440Jv3V6POYwkpw_gwOyK8",
    apiUrl: "https://stage.api.softcorp.io:443",
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
        textFieldBorder: Border.all(
          color: Colors.black12,
          width: 0.5,
        ),
      ),
    );
  }
}
