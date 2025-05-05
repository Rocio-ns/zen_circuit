// lib/services/meditation_service.dart

import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../models/meditation_review_model.dart';

/// Servicio encargado de gestionar las meditaciones.
/// Permite obtener meditaciones, registrar progreso, completar sesiones y manejar reseñas.
class MeditationService {
  /// Instancia de Firebase Firestore para acceder a la base de datos.
  final FirebaseFirestore _db = FirebaseFirestore.instance;

  /// Instancia de Firebase Auth para manejar la autenticación del usuario.
  final FirebaseAuth _auth = FirebaseAuth.instance;

  /// Obtiene las meditaciones completadas por el usuario actual.
  Future<List<Map<String, dynamic>>> getCompletedMeditations() async {
    try {
      final userId = _auth.currentUser?.uid;
      if (userId == null) return [];

      final snapshot = await _db
          .collection('users_meditations')
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
      return [];
    }
  }

  /// Obtiene todas las meditaciones disponibles en la base de datos.
  Future<List<Map<String, dynamic>>> getAllMeditations(BuildContext context) async {
    List<Map<String, dynamic>> allMeditations = [];
    final langCode = Localizations.localeOf(context).languageCode;

    try {
      final user = FirebaseAuth.instance.currentUser;
      if (user == null) {
        print("❌ Error: El usuario no está autenticado");
        return [];
      }

      final categoriesSnapshot = await _db.collection('meditations').get();
      print("🔍 Categorías encontradas: ${categoriesSnapshot.docs.length}");

      for (var categoryDoc in categoriesSnapshot.docs) {
        final data = categoryDoc.data();
        final typesRaw = data['types'];

        if (typesRaw is List) {
          print("📂 Meditaciones en '${categoryDoc.id}': ${typesRaw.length}");

          // Iterar sobre cada meditación en la categoría
          for (var item in typesRaw) {
            final rawName = item['name'];
            final rawDescription = item['description'];

            Map<String, String> nameMap = {};
            Map<String, String> descriptionMap = {};

            if (rawName is Map<String, dynamic>) {
              nameMap = rawName.map((key, value) => MapEntry(key.toString(), value.toString()));
            }
            if (rawDescription is Map<String, dynamic>) {
              descriptionMap = rawDescription.map((key, value) => MapEntry(key.toString(), value.toString()));
            }
/*
            if (rawName is Map) {
              nameMap = rawName.map((key, value) => MapEntry(key.toString(), value.toString()));
            }
            if (rawDescription is Map) {
              descriptionMap = rawDescription.map((key, value) => MapEntry(key.toString(), value.toString()));
            }
*/
            final meditationName = nameMap[langCode] ?? nameMap['en'] ?? 'Unnamed';
            final meditationDescription = descriptionMap[langCode] ?? descriptionMap['en'] ?? 'No description';

            final meditationData = {
              'id': item['id']?.toString() ?? 'sin_id',
              'name': meditationName,
              'description': meditationDescription,
              'audioUrl': item['audioUrl'] ?? '',
            };

            // 🔹 IMPRIMIR datos de la meditación en consola
            print("🧘 Meditación: $meditationData");

            allMeditations.add(meditationData);
/*
            allMeditations.add({
              'id': item['id']?.toString() ?? '',
              'name': meditationName,
              'description': meditationDescription,
              'audioUrl': item['audioUrl'] ?? '',
            });
            // 🔹 IMPRIMIR datos de la meditación en consola
            print("🧘 Meditación: $meditationData");
*/
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

  /// Obtiene meditaciones filtradas por el idioma del usuario.
  Future<List<Map<String, dynamic>>> getMeditationsForLanguage(BuildContext context) async {
    final allMeditations = await getAllMeditations(context);
    return allMeditations.map((meditation) {
      return {
        'meditationName': meditation['name']!,
        'meditationDescription': meditation['description']!,
      };
    }).toList();
  }

  /// Calcula el porcentaje de progreso basado en meditaciones completadas.
  Future<int> getProgressPercentage(BuildContext context) async {
    try {
      final completed = await getCompletedMeditations();
      final all = await getAllMeditations(context);

      if (all.isEmpty) return 0; // No hay meditaciones disponibles

      final percentage = (completed.length / all.length) * 100;
      return percentage.round();
    } catch (e) {
      print("❌ Error calculando el progreso: $e");
      return 0;
    }
  }

  /// Marca una meditación como completada por el usuario.
  Future<void> completeMeditation(String id, String meditationName) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null) throw Exception('Usuario no autenticado');

    await _db
      .collection('users_meditations')
      .doc(userId)
      .collection('completed_meditations')
      .doc(meditationName) // Guardamos cada meditación con su nombre
      .set({
        'completed': true,
        'completionDate': FieldValue.serverTimestamp()
      });
  }

  Future<void> submitReview(MeditationReviewModel review) async {
    final userId = _auth.currentUser?.uid;
    if (userId == null || userId.isEmpty) {
      print("❌ Error: Usuario no autenticado.");
      return;
    }

    if (review.meditationId.isEmpty) {
      print("❌ Error: 'meditationId' no está definido.");
      return;
    }

    try {
      // 🔍 Obtener el nombre del usuario desde Firestore
      final userDoc = await _db.collection('users').doc(userId).get();
      final userData = userDoc.data();
      final userName = userData?['name'] ?? 'Desconocido';

      // 🔄 Convertir la reseña a Map y agregar el nombre del usuario
      final reviewData = review.toMap();
      reviewData['userId'] = userId;
      reviewData['userName'] = userName;
      reviewData['timestamp'] = FieldValue.serverTimestamp();

      // ✅ Guardar en la colección allReviews
      await _db.collection('allReviews').add(reviewData);

      print("✅ Reseña guardada correctamente con nombre de usuario.");

/*      await FirebaseFirestore.instance
        .collection('allReviews')
        .add(review.toMap());
      //await FirebaseFirestore.instance.collection('reviews').add(review.toMap()); // Se guarda en la colección global

      print("✅ Reseña guardada correctamente en 'allReviews'.");
*/
    } catch (e) {
      print("❌ Error al guardar la reseña: $e");
    }
  }

  static Future<List<Map<String, dynamic>>> getAllReviews() async {
    try {
      final snapshot = await FirebaseFirestore.instance
        .collection('allReviews')
        .orderBy('timestamp', descending: true)
        .get();
      //return snapshot.docs.map((doc) => doc.data()).toList();
      return snapshot.docs.map((doc) {
        final data = doc.data();
        data['id'] = doc.id;
        return data;
      }).toList();
    } catch (e) {
      print("❌ Error al obtener todas las reseñas: $e");
      return [];
    }
  }

  Future<List<MeditationReviewModel>> getReviewsByMeditation(String meditationId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('allReviews')
        .where('meditationId', isEqualTo: meditationId)
        .get();

    return snapshot.docs.map((doc) {
      final data = doc.data();
      data['id'] = doc.id; // Si necesitas guardar el ID
      return MeditationReviewModel.fromMap(data);
    }).toList();
  }

  /*
  Future<List<Map<String, dynamic>>> getReviewsByMeditation(String meditationId) async {
    final snapshot = await FirebaseFirestore.instance
        .collection('allReviews')
        .where('meditationId', isEqualTo: meditationId)
        .orderBy('timestamp', descending: true)
        .get();

    return snapshot.docs.map((doc) => doc.data()).toList();
  }
  */

  /// Obtiene la lista de reseñas para una meditación específica.
  Future<List<MeditationReviewModel>> getReviews(String meditationId) async {
    final snapshot = await _db
        .collection('meditations_reviews')
        .doc(meditationId)
        .collection('reviews')
        .orderBy('timestamp', descending: true)
        .get();

    return snapshot.docs.map((doc) => MeditationReviewModel.fromMap(doc.data())).toList();
  }
}