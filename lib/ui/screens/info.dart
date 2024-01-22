import 'package:flutter/material.dart';
import 'package:mood_tracker/core/models/info_content.dart';

class InfoScreen extends StatelessWidget {
  const InfoScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          const SizedBox(height: 20),
          ...InfoContent.list.map((e) {
            return buildBenefit(e['title']!, e['image']!, e['content']!);
          }).toList(),
          const SizedBox(height: 20),
          _buildHowToGetStarted(),
          const SizedBox(height: 20),
        ],
      ),
    );
  }
  // #6366f1
  Widget buildBenefit(String title, String image, String description) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Center(
          child: Text(
            title,
            style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
          )
        ),
        const SizedBox(height: 15),
        Image.asset(image),
        const SizedBox(height: 15),
        Text(description),
        const SizedBox(height: 30),
      ],
    );
  }

  Widget _buildHowToGetStarted() {
    return const Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'How to Get Started?',
          style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
        ),
        SizedBox(height: 15),
        Text(
          '1. Daily Check-Ins:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(' - Set aside a few moments each day to reflect on your mood.'),
        Text(' - Use our simple rating system or add notes to capture the nuances of your emotions.'),
        SizedBox(height: 10),
        Text(
          '2. Personalize Your Entries:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(' - Customize your entries with tags, activities, and events to provide context to your mood.'),
        SizedBox(height: 10),
        Text(
          '3. Review and Reflect:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(' - Explore your mood history to identify patterns and gain insights into your emotional well-being.'),
        SizedBox(height: 10),
        Text(
          '4. Celebrate Achievements:',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(' - Acknowledge and celebrate positive changes in your mood and well-being.'),
        SizedBox(height: 10),
        Text(
          'Your well-being matters. Begin your mood tracking journey today!',
          style: TextStyle(fontStyle: FontStyle.italic),
        ),
      ],
    );
  }
}