import 'package:flutter/material.dart';
import '../models/settings_model.dart';
import '../services/auth_service.dart';

class SettingsController {
  final SettingsModel settingsModel;

  SettingsController(this.settingsModel);

  // Cambiar el estado de las notificaciones
  void toggleNotifications(bool value) {
    settingsModel.toggleNotifications(value);
  }

  // Cambiar el tema
  void toggleTheme(String theme) {
    settingsModel.toggleTheme(theme);
  }

  // Cambiar el idioma
  void changeLanguage(String language) {
    settingsModel.changeLanguage(language);
  }

  // Eliminar la cuenta
  void deleteAccount(BuildContext context) {
    AuthService().confirmDeleteUser(context);
  }
}