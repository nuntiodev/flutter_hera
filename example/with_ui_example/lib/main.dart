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
        "",
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
            MaterialPageRoute(builder: (context) => MyApp()),
          );
        },
        child: Home(),
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
      ),
    );
  }
}
