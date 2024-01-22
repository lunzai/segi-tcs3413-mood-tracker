import 'package:flutter/material.dart';
import 'package:mood_tracker/core/utils/colors.dart';

class AppCard extends StatelessWidget {
  final Widget child;
  const AppCard({
    super.key,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: Durations.medium1,
      padding: const EdgeInsets.all(15),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.black.withOpacity(0.15),
            blurRadius: 2,
            spreadRadius: 0,
            offset: const Offset(0, 2),
          )
        ]
      ),
      child: child,
    );
  }
}