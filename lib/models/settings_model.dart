class SettingsModel {
  bool notificationsEnabled;
  String selectedTheme;
  String selectedLanguage;

  SettingsModel({
    this.notificationsEnabled = true,
    this.selectedTheme = 'Light',
    this.selectedLanguage = 'Español',
  });

  // Métodos para actualizar la configuración
  void toggleNotifications(bool value) {
    notificationsEnabled = value;
  }

  void toggleTheme(String theme) {
    selectedTheme = theme;
  }

  void changeLanguage(String language) {
    selectedLanguage = language;
  }
}