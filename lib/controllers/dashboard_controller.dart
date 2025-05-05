import 'package:flutter/material.dart';
import '../models/dashboard_model.dart';
import '../services/meditation_service.dart';

/// Controlador que gestiona la lógica de negocio para la pantalla del dashboard.
///
/// Este controlador obtiene los datos necesarios para mostrar el progreso
/// del usuario en su actividad de meditación.
class DashboardController {
  /// Instancia del servicio que maneja las operaciones relacionadas con meditación.
  final MeditationService _meditationService = MeditationService();

  /// Obtiene los datos necesarios para mostrar en el dashboard.
  ///
  /// Este método llama al servicio de meditación para obtener el porcentaje
  /// de progreso y retorna un [DashboardModel] con los datos.
  ///
  /// [context] es usado en caso de que el servicio necesite acceder al contexto.
  Future<DashboardModel> getDashboardData(BuildContext context) async {
    // Obtiene el porcentaje de progreso desde el servicio.
    final progress = await _meditationService.getProgressPercentage(context);

    // Crea y retorna un modelo de dashboard con el progreso obtenido.
    return DashboardModel(progress: progress);
  }
}