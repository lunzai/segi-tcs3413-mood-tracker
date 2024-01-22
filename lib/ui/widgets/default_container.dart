import 'package:flutter/material.dart';
import 'package:mood_tracker/core/utils/colors.dart';

class DefaultContainer extends StatelessWidget {
  final double paddingTop;
  final double paddingBottom;
  final double paddingLeft;
  final double paddingRight;
  final Widget child;

  const DefaultContainer({
    super.key,
    required this.child,
    this.paddingTop = 100,
    this.paddingBottom = 50,
    this.paddingLeft = 15,
    this.paddingRight = 15,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          stops: [0.05, 0.15, 0.9],
          colors: [
            AppColors.red100,
            AppColors.indigo100,
            AppColors.violet50,
          ]
        ),
      ),
      padding: const EdgeInsets.only(
        left: 15,
        right: 15,
        top: 100,
        bottom: 50,
      ),
      child: child,
    );
  }
}