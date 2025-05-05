// Archivo generado automáticamente por FlutterFire CLI.
// ignore_for_file: type=lint

import 'package:firebase_core/firebase_core.dart' show FirebaseOptions;
import 'package:flutter/foundation.dart' show defaultTargetPlatform, kIsWeb, TargetPlatform;

/// Clase que contiene las opciones de configuración de Firebase para distintas plataformas.
/// Se utiliza para inicializar Firebase en la aplicación.
///
/// Ejemplo de uso:
/// ```dart
/// import 'firebase_options.dart';
/// // ...
/// await Firebase.initializeApp(
///   options: DefaultFirebaseOptions.currentPlatform,
/// );
/// ```
class DefaultFirebaseOptions {
  /// Retorna las opciones de configuración de Firebase correspondientes a la plataforma actual.
  /// Lanza un error si la plataforma no está configurada en este archivo.
  static FirebaseOptions get currentPlatform {
    if (kIsWeb) {
      throw UnsupportedError(
        'DefaultFirebaseOptions no ha sido configurado para Web - '
        'puedes reconfigurarlo ejecutando nuevamente FlutterFire CLI.',
      );
    }
    switch (defaultTargetPlatform) {
      case TargetPlatform.android:
        return android;
      case TargetPlatform.iOS:
        return ios;
      case TargetPlatform.macOS:
        throw UnsupportedError(
          'DefaultFirebaseOptions no ha sido configurado para macOS - '
          'puedes reconfigurarlo ejecutando nuevamente FlutterFire CLI.',
        );
      case TargetPlatform.windows:
        throw UnsupportedError(
          'DefaultFirebaseOptions no ha sido configurado para Windows - '
          'puedes reconfigurarlo ejecutando nuevamente FlutterFire CLI.',
        );
      case TargetPlatform.linux:
        throw UnsupportedError(
          'DefaultFirebaseOptions no ha sido configurado para Linux - '
          'puedes reconfigurarlo ejecutando nuevamente FlutterFire CLI.',
        );
      default:
        throw UnsupportedError(
          'DefaultFirebaseOptions no está soportado en esta plataforma.',
        );
    }
  }

  /// Configuración de Firebase específica para la plataforma Android.
  static const FirebaseOptions android = FirebaseOptions(
    apiKey: 'AIzaSyD2LWUf__xeLZFrrY-bHLL3jZl3ezeMDSk',
    appId: '1:70397212132:android:4f8be24a0ef32b8cc0c3f1',
    messagingSenderId: '70397212132',
    projectId: 'zencircuit',
    storageBucket: 'zencircuit.firebasestorage.app',
  );

  /// Configuración de Firebase específica para la plataforma iOS.
  static const FirebaseOptions ios = FirebaseOptions(
    apiKey: 'AIzaSyBfPUORyI43nao4MZC1o07pN5JXePUk5as',
    appId: '1:70397212132:ios:a002612105de05d9c0c3f1',
    messagingSenderId: '70397212132',
    projectId: 'zencircuit',
    storageBucket: 'zencircuit.firebasestorage.app',
    iosClientId: '70397212132-enppcoah99iqvl1vd26bf5ftg49b0leu.apps.googleusercontent.com',
    iosBundleId: 'com.example.zenCircuit',
  );
}