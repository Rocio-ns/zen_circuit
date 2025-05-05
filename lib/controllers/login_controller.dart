import 'package:flutter/material.dart';
import '../services/auth_service.dart';

/// Controlador que gestiona la lógica del inicio de sesión.
///
/// Este controlador maneja la autenticación del usuario utilizando el
/// servicio de autenticación, y también administra los campos de entrada
/// del correo electrónico y la contraseña.
class LoginController {
  /// Instancia del servicio de autenticación para realizar el login.
  final AuthService _authService = AuthService();

  /// Controlador para el campo de correo electrónico.
  final emailController = TextEditingController();

  /// Controlador para el campo de contraseña.
  final passwordController = TextEditingController();

  /// Realiza el proceso de inicio de sesión del usuario.
  ///
  /// Este método utiliza el servicio de autenticación para validar las credenciales.
  /// Si el inicio de sesión es exitoso, muestra un mensaje y redirige al dashboard.
  /// Si hay un error, se muestra un mensaje de error en pantalla.
  ///
  /// [context] se utiliza para mostrar mensajes y navegar entre pantallas.
  Future<void> login(BuildContext context) async {
    try {
      // Intenta iniciar sesión con el correo y la contraseña ingresados
      await _authService.signInWithEmail(
        emailController.text,
        passwordController.text,
      );

      if (context.mounted) {
        // Muestra mensaje de éxito y redirige al dashboard
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Inicio de sesión exitoso")),
        );
        Navigator.pushReplacementNamed(context, '/dashboard');
      }
    } catch (e) {
      if (context.mounted) {
        // Muestra un mensaje de error si ocurre alguna excepción
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${e.toString()}")),
        );
      }
    }
  }

  /// Libera los recursos utilizados por los controladores de texto.
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
  }
}