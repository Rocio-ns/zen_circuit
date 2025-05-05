// lib/models/dashboard_model.dart

/// Modelo de datos para representar el estado del dashboard.
class DashboardModel {
  /// Representa el progreso en porcentaje ya calculado.
  final int progress;

  /// Constructor para inicializar el modelo con un progreso obligatorio.
  DashboardModel({required this.progress});

  /// Método de fábrica para crear una instancia de [DashboardModel] a partir de un mapa.
  /// Si el valor de 'progress' no está presente en el mapa, se asigna 0 por defecto.
  factory DashboardModel.fromMap(Map<String, dynamic> map) {
    return DashboardModel(progress: map['progress'] ?? 0);
  }

  /// Convierte la instancia actual en un mapa para facilitar su almacenamiento o transmisión.
  Map<String, dynamic> toMap() {
    return {'progress': progress};
  }
}