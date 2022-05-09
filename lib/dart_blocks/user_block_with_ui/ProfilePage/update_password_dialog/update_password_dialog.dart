import 'package:flutter/cupertino.dart';

import '../../../helpers/validate_email.dart';
import '../../../nuntio_client.dart';

class UpdatePasswordDialog extends StatefulWidget {
  UpdatePasswordDialog({
    Key? key,
    required this.newPasswordHint,
    required this.changePasswordText,
    required this.changePasswordDescription,
    required this.userId,
    required this.passwordErrorText,
  }) : super(key: key);

  final String newPasswordHint;
  final Widget changePasswordText;
  final Widget changePasswordDescription;
  final String userId;
  final Widget passwordErrorText;

  @override
  State<UpdatePasswordDialog> createState() => _UpdatePasswordDialogState();
}

class _UpdatePasswordDialogState extends State<UpdatePasswordDialog> {
  TextEditingController passwordController = TextEditingController();
  bool isLoading = false;
  bool hasError = false;

  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: widget.changePasswordText,
      content: Column(
        children: [
          widget.changePasswordDescription,
          SizedBox(
            height: 10,
          ),
          if (hasError) widget.passwordErrorText,
          if (hasError)
            SizedBox(
              height: 10,
            ),
          CupertinoTextField(
            placeholder: widget.newPasswordHint,
            controller: passwordController,
            keyboardType: TextInputType.text,
            obscureText: true,
          ),
        ],
      ),
      actions: <Widget>[
        CupertinoDialogAction(
          child: isLoading
              ? CupertinoActivityIndicator()
              : Text(
                  "Cancel",
                  style: TextStyle(color: CupertinoColors.systemRed),
                ),
          onPressed: () {
            if (isLoading == false) Navigator.of(context).pop(false);
          },
        ),
        CupertinoDialogAction(
            child: isLoading ? CupertinoActivityIndicator() : Text("Update"),
            onPressed: () {
              if (isLoading == false) {
                setState(() {
                  isLoading = true;
                });
                NuntioClient.userBlock
                    .updatePassword(
                  newPassword: passwordController.text,
                  userId: widget.userId,
                )
                    .catchError((err) {
                  print("could not update email with err: " + err.toString());
                  setState(() {
                    isLoading = false;
                    hasError = true;
                  });
                  return err;
                }).then((value) {
                  setState(() {
                    isLoading = false;
                  });
                  Navigator.of(context).pop(true);
                });
              }
            }),
      ],
    );
  }
}
