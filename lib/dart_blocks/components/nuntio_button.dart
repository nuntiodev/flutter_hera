import 'package:flutter/cupertino.dart';

class NuntioButton extends StatefulWidget {
  final bool? filled;
  final Color color;
  final Widget child;
  final void Function()? onPressed;

  NuntioButton({
    required this.color,
    required this.child,
    required this.onPressed,
    this.filled,
  });

  @override
  State<NuntioButton> createState() {
    return _NuntioButtonState(
      color: color,
      enterColor: color.withOpacity(0.85),
      exitColor: color,
    );
  }
}

class _NuntioButtonState extends State<NuntioButton> {
  Color enterColor;
  Color exitColor;
  Color color;

  _NuntioButtonState(
      {required this.color, required this.enterColor, required this.exitColor});

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      onHover: (_) {
        setState(() {
          color = enterColor;
        });
      },
      onExit: (_) {
        setState(() {
          color = exitColor;
        });
      },
      child: CupertinoButton(
        child: widget.child,
        onPressed: widget.onPressed,
        color: widget.filled == true ? color : null,
      ),
    );
  }
}
