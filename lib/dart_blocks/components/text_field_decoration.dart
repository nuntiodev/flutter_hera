import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

import '../hera_app/models.dart';

BoxDecoration textFieldDecoration({
  Border? border,
  Color? color,
  bool? isActive,
  Color? activeColor,
}) =>
    BoxDecoration(
      color: color,
      border: border,
      boxShadow: isActive == true
          ? [
              BoxShadow(
                color: activeColor?.withOpacity(0.3) ?? blue.withOpacity(0.4),
                spreadRadius: 1,
                blurRadius: 2,
              ),
            ]
          : null,
      borderRadius: BorderRadius.all(
        Radius.circular(5),
      ),
    );
