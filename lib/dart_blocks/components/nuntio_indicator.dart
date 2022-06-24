import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NuntioIndicator extends StatelessWidget {
  final Color? color;
  final double? size;

  NuntioIndicator({this.color, this.size});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: CircularProgressIndicator(
        color: color ?? Colors.black,
        strokeWidth: (size ?? 23 ) <= 23 ? 3.5 : (size ?? 22) <= 30 ? 4 : 6,
      ),
      height: size ?? 23,
      width: size ?? 23,
    );
  }
}
