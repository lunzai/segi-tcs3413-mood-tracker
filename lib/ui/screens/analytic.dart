import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:mood_tracker/core/enums/attribute_category.dart';
import 'package:mood_tracker/core/enums/mood_value.dart';
import 'package:mood_tracker/core/services/db.dart';
import 'package:mood_tracker/core/models/attribute.dart';
import 'package:mood_tracker/core/models/mood_summary.dart';
import 'package:mood_tracker/core/utils/colors.dart';
import 'package:mood_tracker/ui/widgets/app_card.dart';
import 'package:mood_tracker/ui/widgets/app_text.dart';
import 'package:mood_tracker/ui/widgets/chip_text.dart';

class AnalyticScreen extends StatefulWidget {
  const AnalyticScreen({super.key});

  @override
  State<AnalyticScreen> createState() => _AnalyticScreenState();
}

class _AnalyticScreenState extends State<AnalyticScreen> {

  List<Attribute> badEmotionList = [];
  List<Attribute> badActivityList = [];
  List<Attribute> goodEmotionList = [];
  List<Attribute> goodActivityList = [];
  List<MoodSummary> recentSummaryList = [];
  List<List<double>> recentHistoryList = [];
  Map<int, double> dowSummaryMap = {};
  int pieTouchedIndex = 0;

  @override
  void initState() {
    super.initState();
    getBadEmotions();
    getBadActivities();
    getGoodEmotions();
    getGoodActivities();
    getRecentSummary();
    getRecentHistory();
    getDowSummary();
  }

  Future<void> getRecentSummary() async {
    final result = await DbService.getRecentSummary();
    setState(() {
      recentSummaryList = result;
    });
  }

  Future<void> getRecentHistory() async {
    final result = await DbService.getRecentHistory();
    var now = DateTime.now();
    var startDate = DateTime(now.year, now.month, now.day).subtract(
      const Duration(days: 30)
    );
    List<List<double>> valueMap = result.map((e) {
      return [
        e.date.difference(startDate).inDays.toDouble(),
        e.value.value.toDouble(),
      ];
    }).toList();
    setState(() {
      recentHistoryList = valueMap;
    });
  }

  Future<void> getDowSummary() async {
    final result = await DbService.getDayOfWeekSummary();
    setState(() {
      dowSummaryMap = result;
    });
  }

  Future<void> getBadEmotions() async {
    final result = await DbService.getBadMoodRelatedAttributeByCategory(AttributeCategory.Emotions);
    setState(() {
      badEmotionList = result;
    });
  }

  Future<void> getBadActivities() async {
    final result = await DbService.getBadMoodRelatedAttributeByCategory(AttributeCategory.Activities);
    setState(() {
      badActivityList = result;
    });
  }

  Future<void> getGoodEmotions() async {
    final result = await DbService.getGoodMoodRelatedAttributeByCategory(AttributeCategory.Emotions);
    setState(() {
      goodEmotionList = result;
    });
  }

  Future<void> getGoodActivities() async {
    final result = await DbService.getGoodMoodRelatedAttributeByCategory(AttributeCategory.Activities);
    setState(() {
      goodActivityList = result;
    });
  }

  Widget getHistorybottomTitles(double value, TitleMeta meta) {
    const style = TextStyle(
      fontWeight: FontWeight.bold,
      color: AppColors.gray500,
      fontSize: 12,
    );
    if (value % 7 != 0) {
      return const Text('', style: style);
    }
    final startDate = DateTime.now().subtract(
      const Duration(days: 30)
    );
    final currentDate = startDate.add(
      Duration(days: value.toInt())
    );
    return Text(
      DateFormat('dd/MM').format(currentDate), 
      style: style
    );
  }

  Widget recentSummary() {
    return AppCard(
      child: Column(
        children: [
          titleBuilder('Your Mood'),
          const SizedBox(height: 15),
          recentSummaryList.isEmpty ? const Text('Not enough data.') : 
          AspectRatio(
            aspectRatio: 1.0,
            child: PieChart(
              PieChartData(
                pieTouchData: PieTouchData(
                  touchCallback: (FlTouchEvent event, pieTouchResponse) {
                    setState(() {
                      if (!event.isInterestedForInteractions ||
                          pieTouchResponse == null ||
                          pieTouchResponse.touchedSection == null) {
                        pieTouchedIndex = -1;
                        return;
                      }
                      pieTouchedIndex =
                          pieTouchResponse.touchedSection!.touchedSectionIndex;
                    });
                  },
                ),
                borderData: FlBorderData(
                  show: false,
                ),
                sectionsSpace: 3,
                centerSpaceRadius: 0,
                sections: recentSummaryList.asMap().entries.map((e) {
                  int index = e.key;
                  MoodSummary item = e.value;
                  Color color;
                  Color titleColor;
                  switch (item.mood) {
                    case MoodValue.Angry:
                      color = AppColors.red400;
                      titleColor = AppColors.white;
                      break;
                    case MoodValue.Unhappy:
                      color = AppColors.yellow400;
                      titleColor = AppColors.white;
                      break;
                    case MoodValue.Neutral:
                      color = AppColors.indigo400;
                      titleColor = AppColors.white;
                      break;
                    case MoodValue.Happy:
                      color = AppColors.blue400;
                      titleColor = AppColors.white;
                      break;
                    case MoodValue.Delighted:
                      color = AppColors.green400;
                      titleColor = AppColors.white;
                      break;
                  }
                  return pieChartSectionDataBuilder(
                    item: item,
                    color: color,
                    titleColor: titleColor,
                    isTouched: pieTouchedIndex == index
                  );
                }).toList(),
              ),
            ),
          )
          
        ],
      ),
    );
  }

  PieChartSectionData pieChartSectionDataBuilder({
    required MoodSummary item,
    required Color color,
    required Color titleColor,
    required bool isTouched,
  }) {
    final fontSize = isTouched ? 22.0 : 18.0;
    final radius = isTouched ? 150.0 : 140.0;
    final widgetSize = isTouched ? 50.0 : 40.0;
    final double percent = item.percent * 100.0;
    return PieChartSectionData(
      color: color,
      value: item.count.toDouble(),
      //title: '${item.mood.name} (${percent.toStringAsFixed(1)}%)',
      title: '${percent.toStringAsFixed(1)}%',
      radius: radius,
      titleStyle: TextStyle(
        fontSize: fontSize,
        fontWeight: FontWeight.bold,
        color: titleColor,
        shadows: const [
          Shadow(color: Colors.black, blurRadius: 2)
        ],
      ),
      badgeWidget: AnimatedContainer(
        duration: PieChart.defaultDuration,
        height: widgetSize,
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(0.5),
              offset: const Offset(2, 2), 
              blurRadius: 3
            )
          ],
        ),
        child: Image.asset(
          item.mood.asset,
        ),
      ),
      badgePositionPercentageOffset: .98,
    );
  }

  Widget recentHistory() {
    return AppCard(
      child: Column(
        children: [
          titleBuilder('Mood Flow'),
          const SizedBox(height: 15),
          recentHistoryList.isEmpty ? const Text('Not enough data.') : 
          AspectRatio(
            aspectRatio: 1.6,
            child : LineChart(
              LineChartData(
                lineTouchData: const LineTouchData(enabled: false),
                gridData: FlGridData(
                  show: true,
                  drawHorizontalLine: true,
                  verticalInterval: 1,
                  horizontalInterval: 1,
                  getDrawingVerticalLine: (value) {
                    return const FlLine(
                      color: AppColors.gray200,
                      strokeWidth: 0.5,
                    );
                  },
                  getDrawingHorizontalLine: (value) {
                    return const FlLine(
                      color: AppColors.gray200,
                      strokeWidth: 1,
                    );
                  },
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: getHistorybottomTitles,
                      interval: 1,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: getDowLeftTitles,
                      reservedSize: 20,
                      interval: 1,
                    ),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(showTitles: false),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(color: AppColors.gray300),
                ),
                minX: 0,
                maxX: 30,
                minY: 0,
                maxY: 5,
                lineBarsData: [
                  LineChartBarData(
                    spots: recentHistoryList.map((e) => FlSpot(e[0], e[1])).toList(),
                    isCurved: false,
                    color: AppColors.gray400,
                    barWidth: 2,
                    isStrokeCapRound: true,
                    dotData: FlDotData(
                      show: true,
                      getDotPainter: (spot, percent, barData, index) {
                        Color color = MoodValue.byNearestDoubleValue(spot.y)?.color ?? AppColors.gray500;
                        return FlDotCirclePainter(
                          radius: 4,
                          color: color,
                          strokeColor: Colors.transparent,
                        );
                      }
                    ),
                    belowBarData: BarAreaData(
                      show: true,
                      color: AppColors.black.withOpacity(0.1)
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget getDowBottomTitles(double value, TitleMeta meta) {
    List<String> dow = ['Mon', 'Tue', 'Wed', 'Thu', 'Fri', 'Sat', 'Sun'];
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        dow[ value.toInt() ],
        style: const TextStyle(
          color: AppColors.gray500,
          fontSize: 12,
          fontWeight: FontWeight.bold,
        ),
      )
    );
  }

  Widget getDowLeftTitles(double value, TitleMeta meta) {
    if (value == 0) {
      return Container();
    }
    return SideTitleWidget(
      axisSide: meta.axisSide,
      child: Text(
        value.toInt().toString(),
        style: const TextStyle(
          color: AppColors.gray500,
          fontSize: 12,
        ),
      )
    );
  }

  BarChartGroupData getDowGroupData(int x, double y) {
    MoodValue? mood = MoodValue.byNearestDoubleValue(y);
    Color color = mood?.color ?? AppColors.gray500;
    return BarChartGroupData(
      x: x,
      barRods: [
        BarChartRodData(
          toY: y,
          color: color,
          borderRadius: BorderRadius.zero,
          width: 22,
        ),
      ],
      showingTooltipIndicators: [0],
    );
  }

  Widget dowSummary() {
    return AppCard(
      child: Column(
        children: [
          titleBuilder('Day Of Week'),
          const SizedBox(height: 15),
          dowSummaryMap.isEmpty ? const Text('Not enough data.') : 
          AspectRatio(
            aspectRatio: 1.6,
            child: BarChart(
              BarChartData(
                barTouchData: BarTouchData(
                  enabled: false,
                  touchTooltipData: BarTouchTooltipData(
                    tooltipBgColor: Colors.transparent,
                    tooltipPadding: EdgeInsets.zero,
                    tooltipMargin: 8,
                    getTooltipItem: (
                      BarChartGroupData group,
                      int groupIndex,
                      BarChartRodData rod,
                      int rodIndex,
                    ) {
                      final MoodValue? mood = MoodValue.byNearestDoubleValue(rod.toY);
                      return BarTooltipItem(
                        rod.toY.toStringAsPrecision(2),
                        TextStyle(
                          color: mood?.color ?? AppColors.gray500,
                          fontWeight: FontWeight.bold,
                        ),
                      );
                    },
                  ),
                ),
                titlesData: FlTitlesData(
                  show: true,
                  bottomTitles: AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: true,
                      getTitlesWidget: getDowBottomTitles,
                      reservedSize: 38,
                    ),
                  ),
                  leftTitles: AxisTitles(
                    sideTitles: SideTitles(
                      reservedSize: 20,
                      getTitlesWidget: getDowLeftTitles,
                      showTitles: true,
                    ),
                  ),
                  rightTitles: const AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: false,
                    ),
                  ),
                  topTitles: const AxisTitles(
                    sideTitles: SideTitles(
                      showTitles: false,
                    ),
                  ),
                ),
                borderData: FlBorderData(
                  show: true,
                  border: Border.all(
                    color: AppColors.gray300,
                  )
                ),
                barGroups: List.generate(7, (index) => getDowGroupData(
                  index, 
                  dowSummaryMap[ index + 1 ] as double
                )),
                gridData: FlGridData(
                  show: true,
                  drawVerticalLine: false,
                  getDrawingHorizontalLine: (double value) {
                    final MoodValue? mood = MoodValue.byNearestDoubleValue(value + 1);
                    return FlLine(
                      color: mood?.color.withOpacity(0.5) ?? AppColors.gray300,
                      strokeWidth: 1,
                    );
                  },
                ),
                alignment: BarChartAlignment.spaceAround,
                maxY: 5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget titleBuilder(String text) {
    return AppText(
      text: text,
      size: 20,
      weight: FontWeight.bold,
    );
  }

  Widget moodAttributeBuilder({
    required String activityTitle,
    required String emotionTitle,
    required List<Attribute> activities, 
    required List<Attribute> emotions, 
    required Color color,
    required Color borderColor,
  }) {
    return AppCard(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          titleBuilder(activityTitle),
          const SizedBox(height: 15),
          Wrap(
            spacing: 3,
            runSpacing: 5,
            alignment: WrapAlignment.center,
            children: activities.map((e) => ChipText(
              text: e.label, 
              color: color, 
              borderColor: borderColor,
            )).toList(),
          ),
          const SizedBox(height: 15),
          titleBuilder(emotionTitle),
          const SizedBox(height: 15),
          Wrap(
            spacing: 3,
            runSpacing: 5,
            alignment: WrapAlignment.center,
            children: emotions.map((e) => ChipText(
              text: e.label, 
              color: color, 
              borderColor: borderColor,
            )).toList(),
          ),
          const SizedBox(height: 5),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final date = now.subtract(const Duration(days: 30));
    final dateFormat = DateFormat('dd/MM/y');
    return SingleChildScrollView(
      padding: const EdgeInsets.only(
        bottom: 20,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        mainAxisSize: MainAxisSize.max,
        children: [
          const Center(
            child: AppText(
              text: '30 Days Summary',
              color: AppColors.gray950,
              weight: FontWeight.bold,
              size: 28,
            ),
          ),
          const SizedBox(height: 5),
          Center(
            child: AppText(
              text: '${dateFormat.format(date)} - ${dateFormat.format(now)}',
              color: AppColors.gray500,
              size: 16,
            ),
          ),
          const SizedBox(height: 15),
          recentSummary(),
          const SizedBox(height: 20),
          recentHistory(),
          const SizedBox(height: 20),
          dowSummary(),
          const SizedBox(height: 30),
          const Center(
            child: AppText(
              text: 'Lifetime Summary',
              color: AppColors.gray950,
              weight: FontWeight.bold,
              size: 28,
            ),
          ),
          const SizedBox(height: 15),
          moodAttributeBuilder(
            activityTitle: 'What improves your mood',
            emotionTitle: 'that\'s why you feel...',
            activities: goodActivityList,
            emotions: goodEmotionList,
            color: AppColors.emerald400,
            borderColor: AppColors.emerald400,
          ),
          const SizedBox(height: 20),
          moodAttributeBuilder(
            activityTitle: 'What upsets you',
            emotionTitle: 'that\'s why you feel...',
            activities: badActivityList,
            emotions: badEmotionList,
            color: AppColors.blue400,
            borderColor: AppColors.blue400,
          ),
        ],
      ),
    );
  }
}