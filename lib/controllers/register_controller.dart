// lib/controllers/register_controller.dart

import 'package:flutter/material.dart';
import '../services/auth_service.dart';

/// Controlador para manejar el registro de usuarios.
/// Se encarga de gestionar la lógica de registro y comunicación con el servicio de autenticación.
class RegisterController {
  // Instancia del servicio de autenticación para manejar el registro.
  final AuthService _authService = AuthService();

  // Controladores de texto para capturar el nombre, teléfono, correo electrónico, la contraseña ingresados por el usuario.
  final nameController = TextEditingController();
  final phoneController = TextEditingController();
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  /// Método para registrar un usuario con los datos proporcionados.
  /// Muestra mensajes de éxito o error según el resultado del proceso.
  Future<void> register(BuildContext context) async {
    try {
      // Llama al servicio de autenticación para registrar al usuario con los datos ingresados.
      await _authService.registerUser(
        nameController.text,
        phoneController.text,
        emailController.text,
        passwordController.text,
      );

      // Si el `context` está montado, muestra un mensaje de éxito y redirige al dashboard.
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text("Registro exitoso")),
        );
        Navigator.pushReplacementNamed(context, '/dashboard');
      }
    } catch (e) {
      // En caso de error, muestra un mensaje con la descripción del problema.
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error: ${e.toString()}")),
        );
      }
    }
  }

  /// Método para liberar los recursos de los controladores de texto cuando ya no son necesarios.
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
  }
}