import 'package:flutter/material.dart';

class ChipText extends StatelessWidget {
  final String text;
  final Color color;
  final Color borderColor;
  final Color backgroundColor;

  const ChipText({
    super.key, 
    required this.text,
    required this.color,
    required this.borderColor,
    Color? backgroundColor
  }) : 
    backgroundColor = backgroundColor ?? Colors.transparent;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 8),
      decoration: BoxDecoration(
        color: backgroundColor,
        border: Border.all(
          color: borderColor,
          width: 2
        ),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Text(
        text,
        style: TextStyle(
          color: color,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}