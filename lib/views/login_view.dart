// lib/views/login_view.dart
import 'package:flutter/material.dart';
import '../controllers/login_controller.dart';
import 'register_view.dart';
import 'package:zen_circuit/utils/validators.dart';
import 'package:zen_circuit/widgets/custom_button.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final LoginController _controller = LoginController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

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
                  TextFormField(
                    controller: _controller.emailController,
                    decoration: const InputDecoration(labelText: "Correo electrónico"),
                    keyboardType: TextInputType.emailAddress,
                    validator: validateEmail,
                    style: const TextStyle(fontSize: 18),
                  ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _controller.passwordController,
                  decoration: const InputDecoration(labelText: "Contraseña"),
                  obscureText: true,
                  validator: validatePassword,
                  style: const TextStyle(fontSize: 18),
                ),
                const SizedBox(height: 60),
                CustomButton(
                  text: "Iniciar sesión",
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _controller.login(context);
                    }
                  },
                ),
                const SizedBox(height: 20),
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