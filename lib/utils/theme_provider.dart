import 'package:flutter/material.dart';

/// Proveedor de estado para gestionar el tema de la aplicación.
/// Permite cambiar entre modo claro y oscuro de manera dinámica.
class ThemeProvider extends ChangeNotifier {
  /// Indica si el modo oscuro está activado.
  bool _isDarkMode = false;

  /// Getter que devuelve el estado actual del modo oscuro.
  bool get isDarkMode => _isDarkMode;

  /// Alterna entre modo oscuro y modo claro.
  /// Notifica a los oyentes para que actualicen la interfaz.
  void toggleTheme() {
    _isDarkMode = !_isDarkMode;
    notifyListeners(); // Notifica a las vistas que el estado ha cambiado.
  }

  /// Activa el modo oscuro y notifica el cambio.
  void setDarkMode() {
    _isDarkMode = true;
    notifyListeners();
  }

  /// Activa el modo claro y notifica el cambio.
  void setLightMode() {
    _isDarkMode = false;
    notifyListeners();
  }
}