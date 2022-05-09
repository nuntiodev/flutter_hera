import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class ButtonCard extends StatelessWidget {
  ButtonCard({Key? key, required this.onClick, required this.text})
      : super(key: key);

  final Function onClick;
  final Widget text;

  Widget build(BuildContext context) {
    return SizedBox(
      height: 65,
      child: TextButton(
        style: ElevatedButton.styleFrom(
          primary: Colors.grey[100],
          elevation: 0,
          shadowColor: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
        onPressed: () => onClick(),
        child: Padding(
          padding: const EdgeInsets.all(15),
          child: Row(
            children: [
              text,
              const Spacer(),
              const Icon(
                CupertinoIcons.right_chevron,
                color: CupertinoColors.black,
                size: 22,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
