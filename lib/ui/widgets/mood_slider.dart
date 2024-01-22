// ignore_for_file: must_be_immutable

import 'package:flutter/material.dart';
import 'package:mood_tracker/core/enums/mood_value.dart';

class MoodSlider extends StatefulWidget {
  double value;
  final Function(MoodValue) onChange;
  
  MoodSlider({
    super.key,
    MoodValue? moodValue,
    required this.onChange,
  }) : 
    value = moodValue == null ? 
      MoodValue.Neutral.value.toDouble() : 
      moodValue.value.toDouble();

  @override
  State<MoodSlider> createState() => _MoodSliderState();
}

class _MoodSliderState extends State<MoodSlider> {

  MoodValue getMoodValue() {
    return MoodValue.values[ widget.value.round() - 1 ];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      mainAxisAlignment: MainAxisAlignment.center,
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 150,
          width: 150,
          child: Image.asset(getMoodValue().asset),
        ),
        const SizedBox(height: 20),
        SliderTheme(
          data: const SliderThemeData(
            trackHeight: 10,
            valueIndicatorTextStyle: TextStyle(
              fontSize: 14,
            ),
            showValueIndicator: ShowValueIndicator.always,
            thumbShape: RoundSliderThumbShape(
              enabledThumbRadius: 12,
            ),
          ), 
          child: Slider(
            value: widget.value,
            min: 1,
            max: 5,
            divisions: 4,
            label: getMoodValue().name,
            activeColor: getMoodValue().color,
            onChanged: (double value) {
              setState(() {
                widget.value = value;
              });
              widget.onChange(getMoodValue());
            }
          ),
        ),
      ],
    );
  }
}