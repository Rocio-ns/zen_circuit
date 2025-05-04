import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zen_circuit/controllers/settings_controller.dart';
import 'package:zen_circuit/utils/locale_provider.dart';
import 'package:zen_circuit/utils/theme_provider.dart';
import 'package:zen_circuit/models/settings_model.dart';
import 'package:zen_circuit/services/auth_service.dart';
import 'package:zen_circuit/services/notification_service.dart';
import 'package:zen_circuit/generated/l10n.dart';
import 'package:zen_circuit/views/help_view.dart';

class SettingsScreen extends StatefulWidget {
  @override
  SettingsScreenState createState() => SettingsScreenState();
}

class SettingsScreenState extends State<SettingsScreen> {
  late SettingsController _controller;
  late SettingsModel _settingsModel;

  @override
  void initState() {
    super.initState();
    _settingsModel = SettingsModel(
      notificationsEnabled: true,
      selectedTheme: 'Claro',
      selectedLanguage: 'Español',
    );
    _controller = SettingsController(_settingsModel);
  }

  @override
  Widget build(BuildContext context) {
    final t = S.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);  // Escuchamos el tema actual

    return Scaffold(
      appBar: AppBar(
        title: Text(t.settings),
        backgroundColor: const Color.fromARGB(255, 109, 43, 118),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "${t.home} > ${t.settings}",
              style: Theme.of(context).textTheme.bodySmall?.copyWith(color: Colors.grey),
            ),
            SwitchListTile(
              title: Text(t.notifications),
              value: _settingsModel.notificationsEnabled,
              onChanged: (value) async {
                setState(() {
                  _controller.toggleNotifications(value);
                });
                if (value) {
                  await NotificationService.subscribeToNotifications();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(t.notificationsEnabledMessage)),
                  );
                } else {
                  await NotificationService.unsubscribeFromNotifications();
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(t.notificationsDisabledMessage)),
                  );
                }
              },
            ),
            ListTile(
              leading: const Icon(Icons.help_outline),
              title: Text(t.help),
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => HelpScreen()),
                );
              },
            ),
            const Divider(),
            ListTile(
              title: Text(t.theme),
              subtitle: themeProvider.isDarkMode ? Text(t.darkTheme) : Text(t.lightTheme),
              onTap: () => _showThemeDialog(),
            ),
            const Divider(),
            ListTile(
              title: Text(t.language),
              subtitle: Text(
                Localizations.localeOf(context).languageCode == 'es'
                    ? t.spanish
                    : t.english,
              ),
              onTap: () => _showLanguageDialog(),
            ),
            const Divider(),
            ListTile(
              leading: Icon(Icons.logout),
              title: Text(t.logout),
              onTap: () => AuthService.confirmSignOut(context),
            ),
            const Divider(),
            ListTile(
              leading: Icon(Icons.delete),
              title: Text(t.deleteAccount),
              onTap: () => _controller.deleteAccount(context),
            ),
          ],
        ),
      ),
    );
  }

  void _showThemeDialog() {
    final t = S.of(context);
    final themeProvider = Provider.of<ThemeProvider>(context, listen: false);  // Escuchamos el tema actual

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(t.selectTheme),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(t.lightTheme),
                onTap: () {
                  themeProvider.setLightMode();  // Fuerza tema claro
                  Navigator.pop(context);  // Cerrar el diálogo después de seleccionar
                },
              ),
              ListTile(
                title: Text(t.darkTheme),
                onTap: () {
                  themeProvider.setDarkMode();  // Fuerza tema oscuro
                  Navigator.pop(context);  // Cerrar el diálogo después de seleccionar
                },
              ),
            ],
          ),
        );
      },
    );
  }

  void _showLanguageDialog() {
    final t = S.of(context);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text(t.selectLanguage),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                title: Text(t.spanish),
                onTap: () {
                  Provider.of<LocaleProvider>(context, listen: false).setLocale(const Locale('es'));
                  setState(() {
                    _controller.changeLanguage(t.spanish);
                  });
                  Navigator.pop(context);
                },
              ),
              ListTile(
                title: Text(t.english),
                onTap: () {
                  Provider.of<LocaleProvider>(context, listen: false).setLocale(const Locale('en'));
                  setState(() {
                    _controller.changeLanguage(t.english);
                  });
                  Navigator.pop(context);
                },
              ),
            ],
          ),
        );
      },
    );
  }
}