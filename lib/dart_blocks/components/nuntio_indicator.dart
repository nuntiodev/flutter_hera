import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class NuntioIndicator extends StatelessWidget {
  final Color? color;
  late final double size;

  NuntioIndicator({this.color, double? size}){
    this.size = size ?? 23;
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: CircularProgressIndicator(
        color: color ?? Colors.black,
        strokeWidth: size <= 20 ? 3 : size <= 23 ? 3.5 : size <= 30 ? 4 : 6,
      ),
      height: size,
      width: size,
    );
  }
}
