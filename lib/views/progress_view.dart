import 'package:flutter/material.dart';
import '../services/meditation_service.dart';
import '../services/auth_service.dart';
import 'package:intl/intl.dart';
import 'package:fl_chart/fl_chart.dart';
import '../generated/l10n.dart';

class ProgressScreen extends StatefulWidget {
  @override
  ProgressScreenState createState() => ProgressScreenState();
}

class ProgressScreenState extends State<ProgressScreen> {
  List<Map<String, dynamic>> _completed = [];
  int _totalMeditations = 0;

  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  Future<void> _loadProgress() async {
    final service = MeditationService();
    final completedDocs = await service.getCompletedMeditations();
    final allMeditations = await service.getAllMeditations(context);
    final total = allMeditations.length;

    setState(() {
      _completed = completedDocs;
      _totalMeditations = total;
    });

    print("🧘 Total completadas: ${_completed.length}");
  }

  @override
  Widget build(BuildContext context) {
    final t = S.of(context);
    double progress = _totalMeditations == 0
        ? 0
        : _completed.length / _totalMeditations;

    final dateCountMap = <String, int>{};

    for (var item in _completed) {
      final date = (item['completionDate'] as DateTime?) ?? DateTime.now();
      final dateStr = DateFormat('yyyy-MM-dd').format(date);
      dateCountMap[dateStr] = (dateCountMap[dateStr] ?? 0) + 1;
    }

    print("Fechas agrupadas: $dateCountMap");

    final sortedDates = dateCountMap.keys.toList()..sort();
    final spots = <FlSpot>[];

    int index = 0;
    for (var date in sortedDates) {
      final count = dateCountMap[date]!;
      spots.add(FlSpot(index.toDouble(), count.toDouble()));
      index++;
    }

    print("✅ Spots finales generados: $spots");

    if (spots.length == 1) {
      spots.add(FlSpot(1, spots.first.y)); // Duplicar para forzar una línea
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(t.progress),
        backgroundColor: const Color.fromARGB(255, 109, 43, 118),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Color.fromARGB(255, 253, 251, 253)),
            onPressed: () => AuthService.confirmSignOut(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("${t.home} > ${t.progress}",
              style: TextStyle(fontSize: 14, color: Colors.grey)),
            const SizedBox(height: 10),
            Text("📊 ${t.totalProgress}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[300],
              color: const Color.fromARGB(255, 109, 43, 118),
              minHeight: 10,
            ),
            const SizedBox(height: 10),
            Text("${(progress * 100).toStringAsFixed(1)}% ${t.completed}", style: const TextStyle(fontSize: 16)),
            const SizedBox(height: 30),
            Text("📈 ${t.evolution}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            AspectRatio(
              aspectRatio: 1.7,
              child: LineChart(
                LineChartData(
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      color: Colors.deepPurple,
                      barWidth: 3,
                      dotData: FlDotData(show: false),
                    )
                  ],
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true),
                    ),
                  ),
                  //titlesData: FlTitlesData(show: false),
                  gridData: FlGridData(show: false),
                  borderData: FlBorderData(show: false),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text("🧘‍♂️ ${t.meditationCompleted} ✅", style: TextStyle(fontSize: 18)),
            Expanded(
              child: ListView.builder(
                itemCount: _completed.length,
                itemBuilder: (context, index) => ListTile(
                  leading: const Icon(Icons.check_circle, color: Colors.green),
                  title: Text(_completed[index]['id']),
                  subtitle: Text(DateFormat('yyyy-MM-dd – kk:mm').format(_completed[index]['completionDate'])),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}