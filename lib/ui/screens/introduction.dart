import 'package:flutter/material.dart';
import 'package:introduction_screen/introduction_screen.dart' as intro;
import 'package:mood_tracker/core/models/info_content.dart';
import 'package:mood_tracker/core/services/hive.dart';
import 'package:mood_tracker/core/utils/colors.dart';
import 'package:mood_tracker/core/utils/routes.dart';

class IntroductionScreen extends StatefulWidget {
  const IntroductionScreen({super.key});

  @override
  State<IntroductionScreen> createState() => _IntroductionScreenState();
}
class _IntroductionScreenState extends State<IntroductionScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: intro.IntroductionScreen(
        pages: InfoContent.list.map((e) {
          bool isLast = InfoContent.list.indexOf(e) == InfoContent.list.length - 1;
          return intro.PageViewModel(
            title: e['title'],
            body: e['content'],
            image: Center(
              child: Image.asset(
                e['image']!,
                height: 285,
              ),
            ),
            footer: !isLast ? null : ElevatedButton(
              onPressed: () async {
                final settings = HiveService.getSettings()..skipIntroduction = true;
                HiveService.saveSettings(settings);
                await AppNavigator.replaceWith(Routes.main);
              },
              
              style: ButtonStyle(
                shape: MaterialStateProperty.all<OutlinedBorder>(
                  RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(15.0), // Add border radius here
                  ),
                ),
                padding: MaterialStateProperty.all<EdgeInsetsGeometry>(
                  const EdgeInsets.symmetric(
                    vertical: 12,
                    horizontal: 20,
                  )
                ),
                backgroundColor: MaterialStateProperty.resolveWith<Color>(
                  (Set<MaterialState> states) {
                    if (states.contains(MaterialState.pressed)) {
                      return AppColors.indigo400; // Change color when pressed
                    }
                    return AppColors.indigo500; // Default color
                  },
                ),
              ),
              child: const Text(
                "Let's Go!",
                style: TextStyle(
                  color: AppColors.white,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ),
            decoration: const intro.PageDecoration(
              imageFlex: 0,
              bodyFlex: 0,
              footerFlex: 0,
              footerFit: FlexFit.tight,
              imagePadding: EdgeInsets.only(bottom: 15),
              bodyPadding: EdgeInsets.only(bottom: 15),
              titlePadding: EdgeInsets.only(bottom: 15),
              footerPadding: EdgeInsets.all(0),
            )
          );
        }).toList(),
        showDoneButton: false,
        showNextButton: false,
        dotsFlex: 2,        
        bodyPadding: const EdgeInsets.only(
          top: 20,
          left: 15,
          right: 15,
        ),
        safeAreaList: const [true, true, true, true],
      ),
    );
  }
}