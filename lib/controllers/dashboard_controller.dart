// lib/controllers/dashboard_controller.dart
import 'package:flutter/material.dart';
import '../models/dashboard_model.dart';
import '../services/meditation_service.dart';

class DashboardController {
  final MeditationService _meditationService = MeditationService();

  Future<DashboardModel> getDashboardData(BuildContext context) async {
    final progress = await _meditationService.getProgressPercentage(context);
    return DashboardModel(progress: progress);
  }
}