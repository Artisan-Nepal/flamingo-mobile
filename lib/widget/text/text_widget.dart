import 'package:flutter/material.dart';

class TextWidget extends StatelessWidget {
  final String text;
  final bool isBold;
  final double size;

  const TextWidget({
    super.key,
    required this.text,
    this.isBold = false,
    this.size = 14,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontWeight: isBold ? FontWeight.bold : FontWeight.normal,
        fontSize: size,
      ),
    );
  }
}
