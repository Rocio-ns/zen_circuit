import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:zen_circuit/utils/locale_provider.dart';
import 'package:zen_circuit/utils/theme_provider.dart';
import 'package:zen_circuit/firebase_options.dart';

// Importamos las pantallas principales
import 'package:zen_circuit/views/login_view.dart';
import 'package:zen_circuit/views/register_view.dart';
import 'package:zen_circuit/views/dashboard_view.dart';
import 'package:zen_circuit/views/meditation_selection_view.dart';
import 'package:zen_circuit/views/settings_view.dart';

// Importamos los paquetes de traducción generados
import 'package:flutter_localizations/flutter_localizations.dart';
import './generated/l10n.dart';

/// Función principal que inicializa Firebase y ejecuta la aplicación.
void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Inicializar Firebase con la configuración de la plataforma actual.
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  // Iniciar la aplicación con proveedores de estado.
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LocaleProvider()), // Proveedor para idioma.
        ChangeNotifierProvider(create: (_) => ThemeProvider()), // Proveedor para tema.
      ],
      child: const ZenCircuit(),
    ),
  );
}

/// Widget principal de la aplicación Zen Circuit.
/// Gestiona el tema, idioma y la navegación entre pantallas.
class ZenCircuit extends StatelessWidget {
  const ZenCircuit({super.key});

  /// Construcción del MaterialApp que define la configuración global de la app.
  @override
  Widget build(BuildContext context) {
    final themeProvider = Provider.of<ThemeProvider>(context); // Escuchar cambios en el tema.
    final localeProvider = Provider.of<LocaleProvider>(context); // Escuchar cambios en el idioma.

    return MaterialApp(
      title: 'Zen Circuit',

      /// Modo de tema basado en la preferencia del usuario.
      themeMode: themeProvider.isDarkMode ? ThemeMode.dark : ThemeMode.light,

      /// Tema claro de la aplicación.
      theme: ThemeData(
        brightness: Brightness.light,
        scaffoldBackgroundColor: Colors.white,
        appBarTheme: const AppBarTheme(
          backgroundColor: Color.fromARGB(255, 109, 43, 118),
          foregroundColor: Colors.white,
        ),
        textTheme: const TextTheme(
          bodySmall: TextStyle(color: Colors.black),
          bodyMedium: TextStyle(color: Colors.black),
          bodyLarge: TextStyle(color: Colors.black),
        ),
      ),

      /// Tema oscuro de la aplicación.
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

      /// Establece el idioma configurado por el usuario.
      locale: localeProvider.locale,

      /// Idiomas soportados en la aplicación.
      supportedLocales: S.delegate.supportedLocales,

      /// Configuración de localización.
      localizationsDelegates: const [
        S.delegate, // Delegado generado para las traducciones.
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      /// Pantalla inicial de la aplicación.
      initialRoute: '/login',

      /// Definición de rutas de navegación dentro de la aplicación.
      routes: {
        '/login': (context) => LoginScreen(),
        '/register': (context) => RegisterScreen(),
        '/dashboard': (context) => DashboardScreen(),
        '/meditation_selection': (context) => MeditationSelectionScreen(),
        '/settings': (context) => SettingsScreen(),
      },
    );
  }
}