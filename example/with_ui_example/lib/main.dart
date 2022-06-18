import 'package:dart_blocks/dart_blocks/nuntio_client.dart';
import 'package:dart_blocks/dart_blocks/user_block_with_ui/models.dart';
import 'package:dart_blocks/dart_blocks/user_block_with_ui/user_block_with_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:with_ui_example/home/home.dart';
import 'dart:html' as html;

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
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: UserBlockWithUI(
        context: context,
        onLogin: () {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => Home()),
          );
        },
        nuntioColor: NuntioColor(
          primaryColor: const Color(0xffF63737),
        ),
        nuntioText: NuntioText(
            loginTitle: "Velkommen til SPVB",
            loginDetails: "Udfyld nedenstående felter for at logge ind",
            registerTitle: "Opret konto",
            registerDetails:
                "Udfylde nedenstående felter for at oprette en konto",
            repeatPasswordHint: "Skriv dit kodeord igen",
            passwordContainsEightCharsHint: "Kodeord indeholder otte tegn",
            passwordContainsNumberHint: "Kodeord indeholder et tal",
            passwordContainsSpecialHint: "Kodeord indeholder et specielt tegn",
            passwordsMustMatchHint: "De to kodeord er ens",
            passwordHint: "Skriv dit password",
            identifierHint: "Skriv din email",
            loginButton: "Log ind",
            forgotPasswordDetails: "Glemt kodeord?",
            registerButton: "Opret konto",
            welcomeTitle: "Velkommen",
            errorTitle: "Der er sket en fejl.",
            errorDescription: "Prøv igen",
            welcomeDetails:
                "SPVB har fra start anlagt en virksomhedsstrategi, baseret på at handlen først er god når alle parter er tilfredse, kunde – vikar – SPVB.",
            alreadyHaveAccountDescription: "Har du allerede en konto?"),
        background: const BoxDecoration(
          color: CupertinoColors.white,
        ),
        nuntioFooter: NuntioFooter(
          footer: Container(
            height: 100,
            width: double.infinity,
            color: CupertinoColors.darkBackgroundGray,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                Text(
                  "Ⓒ Sygeplejerskernes Vikarbureau ApS",
                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                        color: CupertinoColors.white,
                      ),
                ),
              ],
            ),
          ),
          height: 100,
        ), onRegister: () => {},
      ),
    );
  }
}
