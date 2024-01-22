import 'package:flutter/widgets.dart';
import 'package:mood_tracker/core/utils/colors.dart';

class AppGradientContainer extends StatelessWidget {
  final Widget child;
  const AppGradientContainer({
    super.key,
    required this.child,
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
      ),
      child: SafeArea(
        child: child
      ),
    );
  }
}