import 'package:flutter/material.dart';
import 'package:mood_tracker/core/utils/colors.dart';

class AppText extends StatelessWidget {
  final String text;
  final double size;
  final FontWeight weight;
  final Color color;
  final TextAlign align;

  const AppText({
    super.key,
    required this.text,
    this.size = 13,
    this.weight = FontWeight.normal,
    this.color = AppColors.gray950,
    this.align = TextAlign.start,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      textAlign: align,
      style: TextStyle(
        fontSize: size,
        fontWeight: weight,
        color: color,        
      ),
    );
  }
}