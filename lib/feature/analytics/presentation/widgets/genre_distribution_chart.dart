import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class GenreDistributionChart extends StatelessWidget {
  final Map<String, int> distribution;

  const GenreDistributionChart({super.key, required this.distribution});

  @override
  Widget build(BuildContext context) {
    
    final List<Color> colors = [
      Colors.blue,
      Colors.green,
      Colors.orange,
      Colors.purple,
      Colors.red,
      Colors.teal,
      Colors.indigo,
      Colors.amber,
    ];

    int colorIndex = 0;
    final List<PieChartSectionData> sections = [];
    final List<Widget> legendItems = [];

    distribution.forEach((genre, count) {
      final color = colors[colorIndex % colors.length];
      sections.add(
        PieChartSectionData(
          color: color,
          value: count.toDouble(),
          title: '$count',
          radius: 50,
          titleStyle: const TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
      );

      legendItems.add(
        Padding(
          padding: const EdgeInsets.symmetric(vertical: 4),
          child: Row(
            children: [
              Container(
                width: 12,
                height: 12,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  genre,
                  style: const TextStyle(fontSize: 14),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ),
      );
      colorIndex++;
    });

    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.05),
            blurRadius: 10,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            'Genre Distribution',
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 200,
            child: PieChart(
              PieChartData(
                sectionsSpace: 2,
                centerSpaceRadius: 40,
                sections: sections,
              ),
            ),
          ),
          const SizedBox(height: 24),
          Wrap(
            spacing: 16,
            runSpacing: 8,
            children: legendItems
                .map((item) => SizedBox(width: 140, child: item))
                .toList(),
          ),
        ],
      ),
    );
  }
}
