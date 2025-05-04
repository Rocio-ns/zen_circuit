import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:zen_circuit/views/login_view.dart';

class AuthService {
  final FirebaseAuth _auth = FirebaseAuth.instance;

  static String currentUserId() {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      return user.uid;
    } else {
      throw Exception("Usuario no autenticado");
    }
  }

  Future<UserCredential> signInWithEmail(String email, String password) async {
    return await _auth.signInWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );
  }

  Future<UserCredential> registerUser(String email, String password) async {
    return await _auth.createUserWithEmailAndPassword(
      email: email.trim(),
      password: password.trim(),
    );
  }

  // Método para eliminar la cuenta del usuario
  Future<void> confirmDeleteUser(BuildContext context) async {
    User? user = FirebaseAuth.instance.currentUser;

    // Verificamos si el usuario está logueado
    if (user != null) {
      try {
        bool confirm = await _showDeleteDialog(context);
        if (confirm) {
          await user.delete();
          if (context.mounted) {
            // Después de eliminar la cuenta, redirigimos al login
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => LoginScreen()),
            );
          }
        }
      } catch (e) {
        // Manejo de errores (por ejemplo, si el usuario no está autenticado)
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("Error al eliminar la cuenta: $e")),
        );
      }
    }
  }

  // Método para mostrar el cuadro de diálogo de confirmación antes de cerrar sesión
  static Future<void> confirmSignOut(BuildContext context) async {
    bool confirm = await _showSignOutDialog(context);
    if (confirm) {
      await FirebaseAuth.instance.signOut();
      if (context.mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => LoginScreen()), // Redirige al login
        );
      }
    }
  }

  // Método que muestra el AlertDialog
  static Future<bool> _showSignOutDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Cerrar sesión"),
          content: const Text("Vas a cerrar sesión, ¿estás seguro?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false), // No cierra sesión
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true), // Confirma cierre de sesión
              child: const Text("Sí"),
            ),
          ],
        );
      },
    ) ?? false; // Devuelve false si el usuario cierra el diálogo sin seleccionar nada
  }

  // Método que muestra el AlertDialog
  static Future<bool> _showDeleteDialog(BuildContext context) async {
    return await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Eliminar cuenta"),
          content: const Text("Vas a eliminar tu cuenta en ZenCircuit, ¿estás seguro?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(false), // No elimina la cuenta
              child: const Text("No"),
            ),
            TextButton(
              onPressed: () => Navigator.of(context).pop(true), // Confirma la eliminación de la cuenta
              child: const Text("Sí"),
            ),
          ],
        );
      },
    ) ?? false; // Devuelve false si el usuario cierra el diálogo sin seleccionar nada
  }
}