// lib/controllers/meditation_controller.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/meditation_model.dart';

class MeditationController {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// Obtiene todas las categorías de meditaciones desde Firestore.
  /// Cada categoría incluye su nombre y una lista de tipos de meditación.
  Future<List<MeditationCategory>> getCategories() async {
    try {
      final snapshot = await _firestore.collection('meditations').get();

      // Convertimos cada documento en un objeto MeditationCategory
      return snapshot.docs.map((doc) {
        return MeditationCategory.fromFirestore(doc.data());
      }).toList();
    } catch (e) {
      print('❌ Error al obtener categorías de meditaciones: $e');
      return [];
    }
  }

  /// Obtiene todas las meditaciones (de todas las categorías) en una sola lista.
  Future<List<MeditationType>> getAllMeditations() async {
    try {
      final categories = await getCategories();

      // Aplanamos todas las meditaciones de todas las categorías en una sola lista
      return categories.expand((cat) => cat.types).toList();
    } catch (e) {
      print('❌ Error al obtener todas las meditaciones: $e');
      return [];
    }
  }
}