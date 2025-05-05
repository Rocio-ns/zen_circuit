// lib/utils/validators.dart

/// Valida un nombre ingresado.
/// Retorna un mensaje de error si el campo está vacío o contiene caracteres inválidos.
String? validateName(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'El nombre es obligatorio';
  }

  final nameRegex = RegExp(r"^[a-zA-ZÁÉÍÓÚáéíóúñÑ\s]+$");
  if (!nameRegex.hasMatch(value.trim())) {
    return 'Ingresa un nombre válido';
  }

  return null;
}

/// Valida un número de teléfono.
/// Retorna un mensaje de error si el campo está vacío o no tiene formato válido.
String? validatePhone(String? value) {
  if (value == null || value.trim().isEmpty) {
    return 'El teléfono es obligatorio';
  }

  final phoneRegex = RegExp(r'^[0-9]{7,15}$');
  if (!phoneRegex.hasMatch(value.trim())) {
    return 'Ingresa un número de teléfono válido';
  }

  return null;
}


/// Valida un correo electrónico ingresado.
/// Retorna un mensaje de error si el campo está vacío o no tiene un formato válido.
/// Retorna `null` si el correo es válido.
String? validateEmail(String? value) {
  if (value == null || value.isEmpty) {
    return 'El correo es obligatorio';
  }

  // Expresión regular para verificar el formato del correo electrónico.
  final emailRegex = RegExp(r'^[\w-.]+@([\w-]+\.)+[\w-]{2,4}$');
  if (!emailRegex.hasMatch(value)) {
    return 'Ingresa un correo válido';
  }

  return null;
}

/// Valida una contraseña ingresada.
/// Retorna un mensaje de error si el campo está vacío o tiene menos de 6 caracteres.
/// Retorna `null` si la contraseña es válida.
String? validatePassword(String? value) {
  if (value == null || value.isEmpty) {
    return 'La contraseña es obligatoria';
  }

  // Verifica que la contraseña tenga al menos 6 caracteres.
  if (value.length < 6) {
    return 'Debe tener al menos 6 caracteres';
  }

  return null;
}