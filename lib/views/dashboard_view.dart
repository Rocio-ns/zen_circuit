// lib/views/dashboard_view.dart

import 'package:flutter/material.dart';
import '../controllers/dashboard_controller.dart';
import '../models/dashboard_model.dart';
import '../services/auth_service.dart';
import '../services/meditation_service.dart';
import 'meditation_selection_view.dart';
import 'progress_view.dart';
import 'settings_view.dart';
import 'admin_view.dart';
import '../generated/l10n.dart';

/// Pantalla principal del dashboard de la aplicación.
/// Muestra el progreso del usuario y opciones de navegación.
class DashboardScreen extends StatefulWidget {
  @override
  DashboardScreenState createState() => DashboardScreenState();
}

/// Estado de [DashboardScreen] donde se maneja la lógica de la pantalla.
class DashboardScreenState extends State<DashboardScreen> {
  /// Controlador que gestiona los datos del dashboard.
  final DashboardController _controller = DashboardController();

  /// Lista de identificadores de meditaciones completadas por el usuario.
  List<String> _completedMeditations = [];

  /// Futuro que contiene los datos del dashboard.
  Future<DashboardModel>? _dashboardFuture;

  String? _userRole;

  /// Inicialización del estado de la pantalla.
  /// Se carga el resumen de meditaciones una vez que la interfaz está lista.
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {
        _loadSummary();
        _loadUserRole();
      });
    });
  }

  /// Carga el resumen de meditaciones completadas y los datos generales del dashboard.
  Future<void> _loadSummary() async {
    final allMeditations = await MeditationService().getAllMeditations(context);
    print("TOTAL meditations (dashboard): ${allMeditations.length}");
    final completedData = await MeditationService().getCompletedMeditations();

    _completedMeditations = completedData.map((e) => e['id'] as String).toList();

    final dashboardData = await _controller.getDashboardData(context);

    setState(() {
      _dashboardFuture = Future.value(dashboardData); // evitar doble carga
    });
  }

  /// Construye la interfaz del dashboard.
  @override
  Widget build(BuildContext context) {
    final t = S.of(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text("Zen Circuit"),
        backgroundColor: const Color.fromARGB(255, 109, 43, 118),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Colors.white),
            onPressed: () => AuthService.confirmSignOut(context),
          ),
        ],
      ),
      body: FutureBuilder<DashboardModel>(
        future: _dashboardFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('Error: ${snapshot.error}'));
          }

          final dashboardData = snapshot.data!;

          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  _buildHeader(t),
                  const SizedBox(height: 20),
                  if (_userRole != 'admin') ...[
                    _buildProgressCard(dashboardData, t),
                    const SizedBox(height: 20),
                  ],
                  _buildDashboardOptions(t),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  /// Construye el encabezado del dashboard con el logo y el título.
  Widget _buildHeader(S t) {
    return Center(
      child: Column(
        children: [
          const SizedBox(height: 20),
          Image.asset('assets/images/logo.png', height: 120),
          const SizedBox(height: 20),
          Text(t.summary, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  Future<void> _loadUserRole() async {
    try {
      final role = await AuthService().getUserRole();
      setState(() {
        _userRole = role;
      });
    } catch (e) {
      print("❌ Error obteniendo el rol del usuario: $e");
    }
  }

  /// Construye la tarjeta de progreso del usuario en el dashboard.
  Widget _buildProgressCard(DashboardModel dashboardData, S t) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (_completedMeditations.isNotEmpty) ...[
              const SizedBox(height: 20),
              Text("🧘‍♂️ ${t.meditationCompleted}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              Text("${_completedMeditations.length}", style: const TextStyle(fontSize: 16)),
              const SizedBox(height: 20),
              Text("📊 ${t.totalProgress}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              const SizedBox(height: 10),
              LinearProgressIndicator(
                value: dashboardData.progress / 100,
                backgroundColor: Colors.grey[300],
                color: const Color.fromARGB(255, 109, 43, 118),
                minHeight: 10,
              ),
              const SizedBox(height: 10),
              Text("${dashboardData.progress}% ${t.completed}", style: TextStyle(fontSize: 16)),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildDashboardOptions(S t) {
    final t = S.of(context);
    final buttons = <Widget>[
      _dashboardButton(Icons.search, t.explore, () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => MeditationSelectionScreen()))
            .then((result) {
          if (result == true) {
            _loadSummary();
          }
        });
      }),
      _dashboardButton(Icons.settings, t.settings, () {
        Navigator.push(context, MaterialPageRoute(builder: (context) => SettingsScreen()));
      }),
    ];

    // 👮 Si es admin, agregamos un botón extra
    if (_userRole != 'admin') {
      buttons.add(
        _dashboardButton(Icons.bar_chart, t.progress, () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => ProgressScreen()));
        }),
      );
    }

    // 👮 Si es admin, agregamos un botón extra
    if (_userRole == 'admin') {
      buttons.add(
        _dashboardButton(Icons.admin_panel_settings, t.adminView, () {
          Navigator.push(context, MaterialPageRoute(builder: (context) => AdminView()));
        }),
      );
    }

    return GridView.count(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisCount: 2,
      crossAxisSpacing: 16,
      mainAxisSpacing: 16,
      children: buttons,
    );
  }

  /// Construye un botón de opción del dashboard.
  Widget _dashboardButton(IconData icon, String title, VoidCallback onTap) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 3,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: const Color.fromARGB(255, 109, 43, 118)),
            const SizedBox(height: 10),
            Text(title, textAlign: TextAlign.center, style: const TextStyle(fontSize: 16)),
          ],
        ),
      ),
    );
  }
}