import 'package:dart_blocks/dart_blocks/nuntio_client.dart';
import 'package:dart_blocks/dart_blocks/user_block_with_ui/models.dart';
import 'package:dart_blocks/dart_blocks/user_block_with_ui/user_block_with_ui.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../main.dart';

class Home extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      backgroundColor: CupertinoColors.white,
      child: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Du er logget ind på SPVB",
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(
              height: 30,
            ),
            CupertinoButton.filled(
              onPressed: () {
                NuntioClient.userBlock.logout().then((value) => {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => MyApp()),
                  ),
                    });
              },
              child: const Text("Logout"),
            ),
          ],
        ),
      ),
    );
  }
}
