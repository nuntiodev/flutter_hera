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
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJwcm9qZWN0SWQiOiJhOTM4ZDYyMC1mYjAxLTRhM2EtOWNlNy02NjQyNDY1MDk4NTAiLCJwYXNzd29yZCI6Ii40TXk2VzVhLVUqLXFWZH1jNzdBOkd-L05BTnlwVTh9NlRSazRSQ0lcdTAwM2VoQStgXHUwMDI2XHUwMDNjRyEtTDBzQnM2UT9CeF5cIjdwIiwidHlwZSI6MSwianRpIjoiYTU5MmE0YzMtYTAxZi00NTQ2LWJjZGUtZjBiMTJiMjUwNzYwIiwiaXNzIjoiTnVudGlvIENsb3VkIn0.6NucPMRGEhzHOZ43aVpC7PsvOKldMLbO9VXcP3p6oAo",
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
        ),
      ),
    );
  }
}
