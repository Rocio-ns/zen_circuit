import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:zen_circuit/views/login_view.dart';

/// Servicio de autenticación para manejar el inicio de sesión, registro y administración de cuentas.
class AuthService {
  /// Instancia de Firebase Authentication.
  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Obtiene el identificador único del usuario autenticado.
  /// Lanza una excepción si no hay usuario autenticado.
  static String currentUserId() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.uid;
    } else {
      throw Exception("Usuario no autenticado");
    }
  }

  /// Inicia sesión con correo electrónico y contraseña.
  /// Retorna las credenciales del usuario autenticado.
  Future<UserCredential> signInWithEmail(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );
  }

  /// Registra un nuevo usuario con correo electrónico y contraseña.
  /// Retorna las credenciales del usuario creado.
  Future<UserCredential> registerUser(String name, String phone, String email, String password) async {
    try {
      // Crea la cuenta en Firebase Authentication
      UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      // Obtiene el ID del usuario generado por Firebase
      final userId = userCredential.user?.uid;
      if (userId == null) {
        throw Exception("❌ Error al obtener el ID del usuario.");
      }

      // Guarda los datos en la colección 'users' de Firestore
      await _db.collection('users').doc(userId).set({
        'name': name.trim(),
        'phone': phone.trim(),
        'email': email.trim(),
        'createdAt': FieldValue.serverTimestamp(), // Guarda la fecha de creación
      });

      print("✅ Usuario registrado y guardado en Firestore correctamente.");
      return userCredential;
    } catch (e) {
      print("❌ Error en el registro: $e");
      throw Exception("Error al registrar el usuario.");
    }
  }

  /// Obtiene el rol del usuario actual desde Firestore.
  /// Retorna 'user' si no se encuentra el rol.
  Future<String> getUserRole() async {
    final user = _auth.currentUser;
    if (user != null) {
      final doc = await _db.collection('users').doc(user.uid).get();
      return doc.data()?['role'] ?? 'user'; // Retorna 'user' si no tiene rol definido.
    } else {
      throw Exception("Usuario no autenticado");
    }
  }

/*
  Future<UserCredential> registerUser(String name, String phone, String email, String password) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );
  }
*/

  /// Método para eliminar la cuenta del usuario autenticado.
  /// Muestra un cuadro de diálogo de confirmación antes de proceder.
  Future<void> confirmDeleteUser(BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      try {
        bool confirm = await _showDeleteDialog(context);
        if (confirm) {
          await user.delete();
          if (context.mounted) {
            // Redirige al usuario a la pantalla de inicio de sesión después de eliminar la cuenta.
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
          }
        }
      } catch (e) {
        // Manejo de errores al eliminar la cuenta.
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error al eliminar la cuenta: $e")),
        );
      }
    }
  }

  /// Método para mostrar un cuadro de diálogo de confirmación antes de cerrar sesión.
  static Future<void> confirmSignOut(BuildContext context) async {
    bool confirm = await _showSignOutDialog(context);
    if (confirm) {
      await FirebaseAuth.instance.signOut();
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()), // Redirige al login.
        );
      }
    }
  }

  /// Muestra un cuadro de diálogo de confirmación para cerrar sesión.
  static Future<bool> _showSignOutDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Cerrar sesión"),
          content: const Text("Vas a cerrar sesión, ¿estás seguro?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false), // No cierra sesión.
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true), // Confirma cierre de sesión.
              child: const Text("Sí"),
            ),
          ],
        );
      },
    ) ?? false; // Devuelve false si el usuario cierra el diálogo sin seleccionar nada.
  }

  /// Muestra un cuadro de diálogo de confirmación antes de eliminar la cuenta.
  static Future<bool> _showDeleteDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Eliminar cuenta"),
          content: const Text("Vas a eliminar tu cuenta en ZenCircuit, ¿estás seguro?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false), // No elimina la cuenta.
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true), // Confirma la eliminación de la cuenta.
              child: const Text("Sí"),
            ),
          ],
        );
      },
    ) ?? false; // Devuelve false si el usuario cierra el diálogo sin seleccionar nada.
  }
}