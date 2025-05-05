import 'package:flutter/material.dart';
import '../controllers/register_controller.dart';
import '../utils/validators.dart';
import '../widgets/custom_button.dart';

/// Pantalla de registro donde los usuarios pueden crear una cuenta
class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

/// Estado de la pantalla de registro que maneja la lógica del formulario
class _RegisterScreenState extends State<RegisterScreen> {
  bool _passwordVisible = false;
  // Controlador que contiene la lógica de registro y los TextEditingControllers
  final RegisterController _controller = RegisterController();

  // Clave global para manejar el estado del formulario
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    // Libera los recursos del controlador cuando se destruye la pantalla
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
            key: _formKey, // Asociación del formulario con la clave global
            child: Column(
              children: [
                const SizedBox(height: 40),

                // Logo de la aplicación
                Image.asset('assets/images/logo.png', height: 150),

                const SizedBox(height: 20),

                // Campo de texto para ingresar el nombre
                TextFormField(
                  controller: _controller.nameController,
                  decoration: const InputDecoration(labelText: "Nombre"),
                  keyboardType: TextInputType.name,
                  validator: validateName,
                ),

                const SizedBox(height: 20),

                // Campo de texto para ingresar el correo teléfono
                TextFormField(
                  controller: _controller.phoneController,
                  decoration: const InputDecoration(labelText: "Teléfono"),
                  keyboardType: TextInputType.phone,
                  validator: validatePhone,
                ),

                const SizedBox(height: 20),

                // Campo de texto para ingresar el correo electrónico
                TextFormField(
                  controller: _controller.emailController,
                  decoration: const InputDecoration(labelText: "Correo electrónico"),
                  keyboardType: TextInputType.emailAddress,
                  validator: validateEmail, // Valida el formato del correo
                ),

                const SizedBox(height: 20),

                // Campo de texto para ingresar la contraseña
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

                const SizedBox(height: 40),

                // Botón personalizado para enviar el formulario de registro
                CustomButton(
                  text: "Crear cuenta",
                  onPressed: () {
                    // Si el formulario es válido, ejecuta el método de registro
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