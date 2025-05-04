// lib/services/meditation_service.dart
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/meditation_review_model.dart';

class MeditationService {
  final FirebaseFirestore _db = FirebaseFirestore.instance;
  final FirebaseAuth _auth = FirebaseAuth.instance;

  // Obtener las meditaciones completadas por el usuario actual
  Future<List<Map<String, dynamic>>> getCompletedMeditations() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return [];

      final snapshot = await _db
          .collection('users')
          .doc(userId)
          .collection('completed_meditations')
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        return {
          'id': doc.id,
          'completed': data['completed'] ?? false,
          'completionDate': (data['completionDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
        };
      }).toList();
    } catch (e) {
      print("❌ Error obteniendo meditaciones completadas: $e");
      return [];  // Si ocurre un error, devolvemos una lista vacía
    }
  }

  // Obtener TODAS las meditaciones disponibles
  Future<List<Map<String, String>>> getAllMeditations(BuildContext context) async {
    List<Map<String, String>> allMeditations = [];
    final langCode = Localizations.localeOf(context).languageCode;

    try {
      final categoriesSnapshot = await _db.collection('meditations').get();
      print("🔍 Categorías encontradas: ${categoriesSnapshot.docs.length}");

      for (var categoryDoc in categoriesSnapshot.docs) {
        final data = categoryDoc.data();
        final typesRaw = data['types'];
        //final types = data['types'] as List<dynamic>?;

        if (typesRaw is List) {
          print("📂 Meditaciones en '${categoryDoc.id}': ${typesRaw.length}");

          // Iterar sobre cada meditación de la categoría
          for (var item in typesRaw) {
            final rawName = item['name'];
            final rawDescription = item['description'];

            Map<String, String> nameMap = {};
            Map<String, String> descriptionMap = {};

            if (rawName is Map) {
              nameMap = rawName.map((key, value) => MapEntry(key.toString(), value.toString()));
            }
            if (rawDescription is Map) {
              descriptionMap = rawDescription.map((key, value) => MapEntry(key.toString(), value.toString()));
            }
            
            // Aquí extraemos solo el valor de tipo String, no el mapa completo
            final meditationName = nameMap[langCode] ?? nameMap['en'] ?? 'Unnamed';
            final meditationDescription = descriptionMap[langCode] ?? descriptionMap['en'] ?? 'No description';

            allMeditations.add({
              'id': item['id']?.toString() ?? '',
              'name': meditationName,
              'description': meditationDescription,
              'audioUrl': item['audioUrl'] ?? '',
            });
          }
        } else {
          print("⚠️ El campo 'types' no es una lista en ${categoryDoc.id}");
        }
      }

      print("✅ Total de meditaciones encontradas: ${allMeditations.length}");
    } catch (e) {
      print("❌ Error obteniendo meditaciones: $e");
    }

    return allMeditations;
  }

  // Método para obtener meditaciones según el idioma
  Future<List<Map<String, String>>> getMeditationsForLanguage(BuildContext context) async {
    final allMeditations = await getAllMeditations(context);
    List<Map<String, String>> meditationsForLang = [];

    for (var meditation in allMeditations) {
      final name = meditation['name'];
      final description = meditation['description'];

      if (name != null && description != null) {
        meditationsForLang.add({
          'meditationName': name,
          'meditationDescription': description,
        });
      }
    }

    return meditationsForLang;
  }

  Future<int> getProgressPercentage(BuildContext context) async {
    try {
      final completed = await getCompletedMeditations();
      final all = await getAllMeditations(context);

      if (all.isEmpty) return 0;  // No hay meditaciones disponibles

      final percentage = (completed.length / all.length) * 100;
      return percentage.round();
    } catch (e) {
      print("❌ Error calculando el progreso: $e");
      return 0;  // Si ocurre un error, devolvemos 0 como valor por defecto
    }
  }

  Future<void> completeMeditation(String id, String meditationName) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) throw Exception('Usuario no autenticado');

    await FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('completed_meditations')
      .doc(id)
      .set({
        'id': id,
        'name': meditationName,
        'completed': true,
        'completionDate': FieldValue.serverTimestamp(),
      });
  }

  Future<void> submitReview(MeditationReviewModel review) async {
    final userId = FirebaseAuth.instance.currentUser?.uid;
    if (userId == null) throw Exception('Usuario no autenticado');

    // Guarda en colección global
    await FirebaseFirestore.instance
      .collection('meditations_reviews')
      .doc(review.id)
      .collection('reviews')
      .add(review.toMap());

    // Guarda bajo el usuario
    await FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('meditation_reviews')
      .add(review.toMap());
  }

  Future<List<MeditationReviewModel>> getReviews(String meditationId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('meditations_reviews')
        .doc(meditationId)
        .collection('reviews')
        .orderBy('timestamp', descending: true)
        .get();

    return snapshot.docs
        .map((doc) => MeditationReviewModel.fromMap(doc.data()))
        .toList();
  }
}