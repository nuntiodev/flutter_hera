import 'package:flutter/cupertino.dart';

import '../../../helpers/validate_email.dart';
import '../../../nuntio_client.dart';

class UpdateEmailDialog extends StatefulWidget {
  UpdateEmailDialog({
    Key? key,
    required this.newEmailHint,
    required this.changeEmailText,
    required this.changeEmailDescription,
    required this.userId,
    required this.emailErrorText
  }) : super(key: key);

  final String newEmailHint;
  final Widget changeEmailText;
  final Widget changeEmailDescription;
  final Widget emailErrorText;
  final String userId;

  @override
  State<UpdateEmailDialog> createState() => _UpdateEmailDialogState();
}

class _UpdateEmailDialogState extends State<UpdateEmailDialog> {
  TextEditingController emailController = TextEditingController();
  bool isLoading = false;
  bool hasError = false;

  Widget build(BuildContext context) {
    return CupertinoAlertDialog(
      title: widget.changeEmailText,
      content: Column(
        children: [
          widget.changeEmailDescription,
          SizedBox(
            height: 10,
          ),
          if (hasError) widget.emailErrorText,
          if (hasError)
            SizedBox(
              height: 10,
            ),
          CupertinoTextField(
            placeholder: widget.newEmailHint,
            controller: emailController,
            keyboardType: TextInputType.emailAddress,
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
              if (isLoading == false && validateEmail(emailController.text)) {
                setState(() {
                  isLoading = true;
                });
                NuntioClient.userBlock
                    .updateEmail(
                  newEmail: emailController.text,
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
