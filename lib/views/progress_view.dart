import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import '../services/auth_service.dart';
import '../services/meditation_service.dart';
import '../generated/l10n.dart';

/// Pantalla de progreso del usuario en la aplicación.
/// Muestra el número de meditaciones completadas y una visualización gráfica de la evolución.
class ProgressScreen extends StatefulWidget {
  @override
  ProgressScreenState createState() => ProgressScreenState();
}

/// Estado de [ProgressScreen] donde se maneja la lógica de progreso del usuario.
class ProgressScreenState extends State<ProgressScreen> {
  /// Lista de meditaciones completadas por el usuario.
  List<Map<String, dynamic>> _completed = [];

  /// Total de meditaciones disponibles en la aplicación.
  int _totalMeditations = 0;

  /// Inicializa la carga de progreso al entrar en la pantalla.
  @override
  void initState() {
    super.initState();
    _loadProgress();
  }

  /// Obtiene el progreso del usuario desde el servicio de meditaciones.
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

  /// Construcción de la interfaz de usuario para visualizar el progreso.
  @override
  Widget build(BuildContext context) {
    final t = S.of(context);
    double progress = _totalMeditations == 0 ? 0 : _completed.length / _totalMeditations;

    /// Mapa que almacena el número de meditaciones completadas por fecha.
    final dateCountMap = <String, int>{};
    for (var item in _completed) {
      final date = (item['completionDate'] as DateTime?) ?? DateTime.now();
      final dateStr = DateFormat('yyyy-MM-dd').format(date);
      dateCountMap[dateStr] = (dateCountMap[dateStr] ?? 0) + 1;
    }

    print("Fechas agrupadas: $dateCountMap");

    /// Ordena las fechas de las meditaciones completadas.
    final sortedDates = dateCountMap.keys.toList()..sort();
    final spots = <FlSpot>[];
    int index = 0;
    for (var date in sortedDates) {
      final count = dateCountMap[date]!;
      spots.add(FlSpot(index.toDouble(), count.toDouble()));
      index++;
    }

    print("✅ Spots finales generados: $spots");

    /// Asegura que haya al menos dos puntos en el gráfico para evitar errores.
    if (spots.length == 1) {
      spots.add(FlSpot(1, spots.first.y));
    }

    return Scaffold(
      appBar: AppBar(
        title: Text(t.progress),
        backgroundColor: const Color.fromARGB(255, 109, 43, 118),
        actions: [
          /// Botón para cerrar sesión del usuario.
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () => AuthService.confirmSignOut(context),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Ruta de navegación actual.
            Text("${t.home} > ${t.progress}", style: const TextStyle(fontSize: 14, color: Colors.grey)),
            const SizedBox(height: 10),

            /// Indicador del progreso total en porcentaje.
            Text("📊 ${t.totalProgress}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            LinearProgressIndicator(
              value: progress,
              backgroundColor: Colors.grey[300],
              color: const Color(0xFF6D2B76),
              minHeight: 10,
            ),
            const SizedBox(height: 10),
            Text("${(progress * 100).toStringAsFixed(1)}% ${t.completed}", style: const TextStyle(fontSize: 16)),

            const SizedBox(height: 35),

            /// Gráfico de evolución de meditaciones completadas.
            Text("📈 ${t.evolution}", style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),
            AspectRatio(
              aspectRatio: 1.6,
              child: LineChart(
                LineChartData(
                  backgroundColor: const Color(0xFFF5F1F9),
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: true,
                    verticalInterval: 1,
                    horizontalInterval: 1,
                    getDrawingHorizontalLine: (value) => FlLine(color: Colors.grey.withOpacity(0.2), strokeWidth: 1),
                    getDrawingVerticalLine: (value) => FlLine(color: Colors.grey.withOpacity(0.2), strokeWidth: 1),
                  ),
                  titlesData: FlTitlesData(
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(showTitles: true, reservedSize: 28),
                    ),
                    bottomTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 28,
                        getTitlesWidget: (value, meta) {
                          final int index = value.toInt();
                          if (index < sortedDates.length) {
                            return Text(sortedDates[index].substring(5), style: const TextStyle(fontSize: 10));
                          }
                          return const SizedBox();
                        },
                      ),
                    ),
                    rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                    topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
                  ),
                  borderData: FlBorderData(show: true, border: Border.all(color: Colors.grey.withOpacity(0.3))),
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      color: const Color(0xFF6D2B76),
                      barWidth: 3,
                      dotData: FlDotData(show: true),
                      belowBarData: BarAreaData(
                        show: true,
                        color: const Color(0xFF6D2B76).withOpacity(0.2),
                      ),
                    )
                  ],
                ),
              ),
            ),

            const SizedBox(height: 40),

            /// Lista de meditaciones completadas con fecha.
            Text("🧘‍♂️ ${t.meditationCompleted} ✅", style: const TextStyle(fontSize: 18)),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: _completed.length,
                itemBuilder: (context, index) => Card(
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  elevation: 2,
                  margin: const EdgeInsets.symmetric(vertical: 6),
                  child: ListTile(
                    leading: const Icon(Icons.check_circle, color: Colors.green),
                    title: Text(_completed[index]['id']),
                    subtitle: Text(DateFormat('yyyy-MM-dd – kk:mm').format(_completed[index]['completionDate'])),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}