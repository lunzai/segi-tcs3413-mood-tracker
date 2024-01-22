import 'package:flutter/material.dart';

class MoodCalendarMonthButton extends StatelessWidget {
  final String text;
  const MoodCalendarMonthButton({
    super.key,
    required this.text
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {}, 
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(text),
          const Icon(Icons.arrow_drop_down_outlined),
        ],
      ) 
    );
  }
}