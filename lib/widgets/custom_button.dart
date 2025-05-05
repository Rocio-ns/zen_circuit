// lib/widgets/custom_button.dart

import 'package:flutter/material.dart';

/// Un botón personalizado reutilizable con estilo configurable.
/// Permite modificar el texto, color de fondo y color del texto.
class CustomButton extends StatelessWidget {
  /// Texto que se muestra dentro del botón.
  final String text;

  /// Acción que se ejecuta cuando se presiona el botón.
  final VoidCallback onPressed;

  /// Color de fondo del botón. Por defecto es un tono púrpura.
  final Color color;

  /// Color del texto dentro del botón. Por defecto es blanco.
  final Color textColor;

  /// Constructor para definir un [CustomButton] con propiedades opcionales.
  const CustomButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.color = const Color.fromARGB(255, 109, 43, 118),
    this.textColor = Colors.white,
  });

  /// Construcción del botón con estilo personalizado.
  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: color,
        foregroundColor: textColor,
        padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 15),
        textStyle: const TextStyle(fontSize: 16),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
      ),
      child: Text(text),
    );
  }
}