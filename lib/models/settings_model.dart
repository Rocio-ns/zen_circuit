/// Modelo de configuración para administrar preferencias de usuario.
class SettingsModel {
  /// Indica si las notificaciones están habilitadas o deshabilitadas.
  bool notificationsEnabled;

  /// Tema seleccionado por el usuario (por ejemplo, "Light" o "Dark").
  String selectedTheme;

  /// Idioma seleccionado por el usuario.
  String selectedLanguage;

  /// Constructor de [SettingsModel] con valores predeterminados.
  /// - `notificationsEnabled`: Activado por defecto.
  /// - `selectedTheme`: Tema claro por defecto.
  /// - `selectedLanguage`: Español por defecto.
  SettingsModel({
    this.notificationsEnabled = true,
    this.selectedTheme = 'Light',
    this.selectedLanguage = 'Español',
  });

  /// Activa o desactiva las notificaciones según el valor proporcionado.
  void toggleNotifications(bool value) {
    notificationsEnabled = value;
  }

  /// Cambia el tema de la aplicación al valor proporcionado.
  void toggleTheme(String theme) {
    selectedTheme = theme;
  }

  /// Cambia el idioma de la aplicación al valor proporcionado.
  void changeLanguage(String language) {
    selectedLanguage = language;
  }
}