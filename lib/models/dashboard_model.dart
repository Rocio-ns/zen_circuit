// lib/models/dashboard_model.dart

class DashboardModel {
  final int progress; // porcentaje ya calculado

  DashboardModel({required this.progress});

  factory DashboardModel.fromMap(Map<String, dynamic> map) {
    return DashboardModel(progress: map['progress'] ?? 0);
  }

  Map<String, dynamic> toMap() {
    return {'progress': progress};
  }
}