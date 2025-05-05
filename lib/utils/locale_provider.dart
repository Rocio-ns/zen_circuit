import 'package:flutter/material.dart';

/// Clase que gestiona el idioma de la aplicación.
/// Permite cambiar y restaurar el idioma preferido del usuario.
class LocaleProvider extends ChangeNotifier {
  /// Idioma actual de la aplicación. Por defecto es español ('es').
  Locale _locale = const Locale('es');

  /// Retorna el idioma actual configurado.
  Locale get locale => _locale;

  /// Cambia el idioma de la aplicación si está dentro de los idiomas soportados.
  /// Notifica a los oyentes para actualizar la interfaz.
  void setLocale(Locale locale) {
    if (!L10n.all.contains(locale)) return;

    _locale = locale;
    notifyListeners();
  }

  /// Restaura el idioma a español ('es') y notifica los cambios.
  void clearLocale() {
    _locale = const Locale('es');
    notifyListeners();
  }
}

/// Clase auxiliar que gestiona los idiomas disponibles en la aplicación.
class L10n {
  /// Lista de idiomas soportados.
  static final all = [
    const Locale('en'), // Inglés
    const Locale('es'), // Español
  ];

  /// Retorna el nombre del idioma correspondiente al código de idioma.
  static String getLanguageName(Locale locale) {
    switch (locale.languageCode) {
      case 'en':
        return 'English';
      case 'es':
        return 'Español';
      default:
        return '';
    }
  }
}