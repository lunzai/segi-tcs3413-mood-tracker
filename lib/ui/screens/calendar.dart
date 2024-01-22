// ignore_for_file: library_private_types_in_public_api, use_build_context_synchronously

import 'package:flutter/material.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:intl/intl.dart';
import 'package:mood_tracker/core/helpers/utils.dart';
import 'package:mood_tracker/core/models/mood.dart';
import 'package:mood_tracker/core/utils/colors.dart';
import 'package:mood_tracker/ui/widgets/mood_calendar.dart';
import 'package:mood_tracker/core/enums/mood_value.dart';
import 'package:mood_tracker/core/services/db.dart';
import 'package:mood_tracker/core/models/attribute.dart';
import 'package:mood_tracker/ui/widgets/app_text.dart';
import 'package:mood_tracker/ui/widgets/attribute_chip.dart';
import 'package:mood_tracker/ui/widgets/mood_slider.dart';

class CalendarScreen extends StatefulWidget {
  const CalendarScreen({
    super.key,
  });

  @override
  State<CalendarScreen> createState() => _CalendarScreenState();

  _CalendarScreenState getState() {
    return _CalendarScreenState();
  }
}

class _CalendarScreenState extends State<CalendarScreen> {

  Map<String, Mood> moodMap = {};
  List<Attribute> activityList = [];
  List<Attribute> emotionList = [];
  bool isMoodLoaded = false;

  @override
  void initState() {
    EasyLoading.show(status: 'Loading...');
    super.initState();
    getMoods();
    getActivities();
    getEmotions();
    EasyLoading.dismiss();
  }
  
  Future<void> getMoods() async {    
    final List<Mood> data = await Mood.findAll();
    setState(() {
      moodMap = { for (var item in data) Utils.formatDate(item.date) : item };
      isMoodLoaded = true;
    });
  }

  void getActivities() async {
    final data = await DbService.getActivities();
    setState(() {
      activityList = data;
    });
  }

  void getEmotions() async {
    final data = await DbService.getEmotions();
    setState(() {
      emotionList = data;
    });
  }

  EdgeInsets getPadding() {
    return const EdgeInsets.only(
      top: 30,
      bottom: 15,
      left: 15,
      right: 15,
    );
  }

  Future<bool> handleSubmit(Mood mood) async {
    EasyLoading.show(status: 'Loading...');
    bool result = await mood.save();
    if (result) {
      await getMoods();
    }
    EasyLoading.dismiss();
    return result;
  }

  Widget formTitle(String title) {
    return Center(
      child: AppText(
        text: title,
        size: 18,
        weight: FontWeight.bold,
      ),
    );
  }

  void showFormModal(BuildContext context, Mood mood) {
    final TextEditingController textFieldController = TextEditingController();
    if (!mood.isNewRecord()) {
      textFieldController.text = mood.notes;
    }
    showModalBottomSheet(
      context: context, 
      backgroundColor: Colors.white,
      isScrollControlled: true,
      useSafeArea: true,
      builder: (BuildContext context) {
        return SingleChildScrollView(
          padding: const EdgeInsets.only(
            top: 15,
            bottom: 30,
            left: 15,
            right: 15,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              // MOOD
              formTitle(DateFormat('E, d MMM y').format(mood.date)), 
              const SizedBox(height: 15),
              formTitle('How Are You Feeling?'), 
              const SizedBox(height: 15),
              MoodSlider(
                moodValue: mood.value,
                onChange: (MoodValue moodValue) => mood.value = moodValue,
              ),
              const SizedBox(height: 30),
              // EMOTIONS
              formTitle('Emotions'),
              const SizedBox(height: 15),
              AttributeChip(
                list: emotionList,
                selectedList: mood.emotions,
                onChange: (list, item, selected) {
                  mood.emotions = list;
                },  
              ),
              const SizedBox(height: 30),
              // ACTIVITIES
              formTitle('Activities'),
              const SizedBox(height: 15),
              AttributeChip(
                list: activityList,
                selectedList: mood.activities,
                onChange: (list, item, selected) {
                  mood.activities = list;
                },  
              ),
              const SizedBox(height: 30),
              // NOTES
              formTitle('Notes'),
              const SizedBox(height: 15),
              TextField(
                controller: textFieldController,
                minLines: 10,
                maxLines: null,
                keyboardType: TextInputType.multiline,
                decoration: const InputDecoration(
                  contentPadding: EdgeInsets.all(15),
                  filled: true,
                  fillColor: AppColors.gray200,
                  border: OutlineInputBorder(
                    borderSide: BorderSide.none,
                    borderRadius: BorderRadius.all(
                      Radius.circular(10)
                    )
                  ),
                ),
                onChanged: (String content) {
                  mood.notes = content;
                },
              ),
              const SizedBox(height: 30),
              // SUBMIT
              TextButton(
                style: ButtonStyle(
                  backgroundColor: const MaterialStatePropertyAll<Color>(AppColors.indigo500),
                  foregroundColor: const MaterialStatePropertyAll<Color>(Colors.white),
                  overlayColor: MaterialStateProperty.resolveWith<Color>(
                    (Set<MaterialState> states) => AppColors.indigo600
                  ),
                  shape: MaterialStatePropertyAll<RoundedRectangleBorder>(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                      side: BorderSide.none,
                    )
                  ),
                ),
                onPressed: () async {
                  final bool isNewRecord = mood.isNewRecord();
                  final bool result = await handleSubmit(mood);
                  if (result) {
                    Navigator.pop(context);
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(isNewRecord ? 'Mood recorded!' : 'Mood updated!'),
                      )
                    );
                  }
                }, 
                child: Text(mood.id == null ? 'Save' : 'Update'),
              ),
            ],
          ),
        );
      }
    );
  } 

  Widget? floatingActionButton() {
    if (!isMoodLoaded || moodMap[ Utils.formatDate(DateTime.now()) ] != null) {
      return null;
    }
    return FloatingActionButton(
      onPressed: () {
        Mood mood = Mood();
        mood.date = Utils.getDate(DateTime.now());
        showFormModal(context, mood);
      },
      backgroundColor: AppColors.indigo500,
      foregroundColor: AppColors.white,
      shape: const StadiumBorder(),
      child: const Icon(Icons.add_reaction, size: 40),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      floatingActionButton: floatingActionButton(),
      floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      body: MoodCalendar(
        moodMap: moodMap,
        onTap: (DateTime date, Mood? mood) {
          if (mood == null) {
            mood = Mood();
            mood.date = Utils.getDate(date);
          }
          showFormModal(context, mood);
        },
      ),
    );
  }
}