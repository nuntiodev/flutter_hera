import 'package:dart_blocks/dart_blocks/components/text_field_decoration.dart';
import 'package:dart_blocks/dart_blocks/hera_app/models.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NuntioTextField extends StatefulWidget {
  final String? label;
  final String? hint;
  final TextInputType? textInputType;
  final TextEditingController? controller;
  final NuntioTextStyle nuntioTextStyle;
  final NuntioStyle nuntioStyle;
  final NuntioColor nuntioColor;
  final bool? obscureText;
  final TextInputAction? textInputAction;
  final Function(String)? onSubmitted;
  final Function(String)? onChanged;

  NuntioTextField({
    required this.nuntioTextStyle,
    required this.nuntioStyle,
    required this.nuntioColor,
    this.controller,
    this.label,
    this.hint,
    this.textInputType,
    this.obscureText,
    this.textInputAction,
    this.onSubmitted,
    this.onChanged,
  });

  @override
  State<NuntioTextField> createState() => _NuntioTextFieldState();
}

class _NuntioTextFieldState extends State<NuntioTextField> {
  FocusNode focusNode = FocusNode();
  Color? activeColor;
  Color? inactiveColor;
  Color? currentColor;

  @override
  void initState() {
    activeColor = widget.nuntioColor.successColor;
    inactiveColor = widget.nuntioStyle.borderColor;
    currentColor = inactiveColor;
    focusNode.addListener(() {
      if (focusNode.hasFocus) {
        setState(() {
          currentColor = activeColor;
        });
      } else {
        setState(() {
          currentColor = inactiveColor;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (widget.label != null && widget.label != "")
          Padding(
            padding: EdgeInsets.only(bottom: 5),
            child: Align(
              alignment: Alignment.centerLeft,
              child: Text(
                widget.label!,
                style: widget.nuntioTextStyle.labelStyle,
                textAlign: TextAlign.left,
              ),
            ),
          ),
        SizedBox(
          height: widget.nuntioStyle.buttonHeight,
          child: CupertinoTextField(
            focusNode: focusNode,
            obscureText: widget.obscureText ?? false,
            onTap: () {},
            decoration: textFieldDecoration(
              Border.all(
                color: currentColor ?? Colors.white,
                width: 0.7,
              ),
              widget.nuntioStyle.textFieldColor,
            ),
            textInputAction: widget.textInputAction,
            // Moves focus to next.
            controller: widget.controller,
            placeholder: widget.hint,
            keyboardType: widget.textInputType,
            onSubmitted: widget.onSubmitted,
            onChanged: widget.onChanged,
          ),
        ),
      ],
    );
  }
}
