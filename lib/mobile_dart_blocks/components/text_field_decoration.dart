import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

BoxDecoration textFieldDecoration(Border? border, Color? color,) => BoxDecoration(
      color: color,
      border: border,
      borderRadius: BorderRadius.all(
        Radius.circular(5),
      ),
    );
