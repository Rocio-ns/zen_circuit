// lib/views/login_view.dart

import 'package:flutter/material.dart';
import '../controllers/login_controller.dart';
import 'register_view.dart';
import 'package:zen_circuit/utils/validators.dart';
import 'package:zen_circuit/widgets/custom_button.dart';

/// Pantalla de inicio de sesión para la aplicación Zen Circuit.
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

/// Estado de [LoginScreen] donde se maneja la lógica de autenticación.
class _LoginScreenState extends State<LoginScreen> {
  bool _passwordVisible = false;
  /// Controlador que gestiona la lógica del inicio de sesión.
  final LoginController _controller = LoginController();

  /// Clave global para validar el formulario de inicio de sesión.
  final _formKey = GlobalKey<FormState>();

  /// Libera los recursos utilizados por el controlador cuando la pantalla se destruye.
  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  /// Construye la interfaz de usuario para la pantalla de inicio de sesión.
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 212, 185, 215),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(height: 100),
                Image.asset('assets/images/logo.png', height: 150),
                const SizedBox(height: 40),
                const Text(
                  "Bienvenido a Zen Circuit",
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Color.fromARGB(255, 109, 43, 118),
                  ),
                ),
                const SizedBox(height: 20),

                /// Campo de entrada para el correo electrónico del usuario.
                TextFormField(
                  controller: _controller.emailController,
                  decoration: const InputDecoration(labelText: "Correo electrónico"),
                  keyboardType: TextInputType.emailAddress,
                  validator: validateEmail,
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 20),

                /// Campo de entrada para la contraseña del usuario.
                TextFormField(
                  controller: _controller.passwordController,
                  obscureText: !_passwordVisible,
                  validator: validatePassword,
                  style: const TextStyle(fontSize: 18),
                  decoration: InputDecoration(
                    labelText: "Contraseña",
                    suffixIcon: IconButton(
                      icon: Icon(
                        _passwordVisible ? Icons.visibility : Icons.visibility_off,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          _passwordVisible = !_passwordVisible;
                        });
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 60),

                /// Botón para enviar el formulario y autenticar al usuario.
                CustomButton(
                  text: "Iniciar sesión",
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _controller.login(context);
                    }
                  },
                ),
                const SizedBox(height: 20),

                /// Botón de navegación para la pantalla de registro.
                TextButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => const RegisterScreen()),
                    );
                  },
                  child: RichText(
                    text: TextSpan(
                      style: const TextStyle(
                        fontSize: 16,
                        color: Colors.black,
                      ),
                      children: [
                        const TextSpan(text: '¿No tienes cuenta? '),
                        TextSpan(
                          text: 'Regístrate aquí',
                          style: const TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Color.fromARGB(255, 109, 43, 118),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}