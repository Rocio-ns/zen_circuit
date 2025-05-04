import 'package:flutter/material.dart';
import '../controllers/register_controller.dart';
import '../utils/validators.dart';
import '../widgets/custom_button.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final RegisterController _controller = RegisterController();
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
      appBar: AppBar(title: const Text("Registrarse")),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                const SizedBox(height: 60),
                Image.asset('assets/images/logo.png', height: 150),
                const SizedBox(height: 60),
                TextFormField(
                  controller: _controller.emailController,
                  decoration: const InputDecoration(labelText: "Correo electrónico"),
                  keyboardType: TextInputType.emailAddress,
                  validator: validateEmail,
                ),
                const SizedBox(height: 20),
                TextFormField(
                  controller: _controller.passwordController,
                  decoration: const InputDecoration(labelText: "Contraseña"),
                  obscureText: true,
                  validator: validatePassword,
                ),
                const SizedBox(height: 60),
                CustomButton(
                  text: "Registrarse",
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _controller.register(context);
                    }
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}