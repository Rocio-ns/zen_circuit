import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zen_circuit/utils/locale_provider.dart';
import 'package:zen_circuit/utils/theme_provider.dart';
import 'package:zen_circuit/firebase_options.dart';

// Importamos las pantallas
import 'package:zen_circuit/views/login_view.dart';
import 'package:zen_circuit/views/register_view.dart';
import 'package:zen_circuit/views/dashboard_view.dart';
import 'package:zen_circuit/views/meditation_selection_view.dart';
import 'package:zen_circuit/views/settings_view.dart';

// Importamos los paquetes de traducción generados
import 'package:flutter_localizations/flutter_localizations.dart'; // Importa las localizaciones
import './generated/l10n.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocaleProvider()), // Proveedor para idioma
        ChangeNotifierProvider(create: (_) => ThemeProvider()), // Proveedor para tema
      ],
      child: const ZenCircuit(),
    ),
  );
}

class ZenCircuit extends StatelessWidget {
  const ZenCircuit({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context); // Escuchar cambios en el tema
    final localeProvider = Provider.of<LocaleProvider>(context); // Escuchar cambios
          
    return MaterialApp(
      title: 'Zen Circuit',
      themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light, // Cambiar tema según la preferencia del usuario
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 109, 43, 118),
          foregroundColor: Colors.white,
        ),
        textTheme: TextTheme(
          bodySmall: TextStyle(color: Colors.black),
          bodyMedium: TextStyle(color: Colors.black),
          bodyLarge: TextStyle(color: Colors.black),
        ),
      ),
      darkTheme: ThemeData(
        brightness: Brightness.dark,
        scaffoldBackgroundColor: const Color(0xFF121212),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 109, 43, 118),
          foregroundColor: Colors.white,
        ),
        textTheme: const TextTheme(
          bodySmall: TextStyle(color: Colors.white),
          bodyMedium: TextStyle(color: Colors.white),
          bodyLarge: TextStyle(color: Colors.white),
        ),
      ),
      locale: localeProvider.locale, // Idioma configurado por el usuario
      supportedLocales: S.delegate.supportedLocales,
      // Configura la localización
      localizationsDelegates: const [
        S.delegate, // Clase generada para las traducciones
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      // Definir la pantalla de inicio
      initialRoute: '/login',
      routes: {
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/dashboard': (context) => DashboardScreen(),
        '/meditation_selection': (context) => MeditationSelectionScreen(),
        '/settings': (contex) => SettingsScreen(),
      },
    );
  }
}