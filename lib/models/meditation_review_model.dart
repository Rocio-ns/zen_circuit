import 'package:cloud_firestore/cloud_firestore.dart';

/// Modelo que representa una reseña de meditación realizada por un usuario.
class MeditationReviewModel {
  /// Identificador único del usuario que realizó la reseña.
  final String userId;

  /// Identificador único de la reseña.
  final String id;

  /// Identificador único de la meditación que está siendo evaluada.
  final String meditationId; // 🔹 Agregado aquí

  /// Nombre del usuario que escribió la reseña.
  final String name;

  /// Comentario proporcionado por el usuario sobre la meditación.
  final String comment;

  /// Calificación de la meditación, en una escala del 1 al 5.
  final int rating;

  /// Marca de tiempo en la que se realizó la reseña.
  final DateTime timestamp;

  /// Constructor para inicializar una instancia de [MeditationReviewModel].
  MeditationReviewModel({
    required this.userId,
    required this.id,
    required this.meditationId,
    required this.name,
    required this.comment,
    required this.rating,
    required this.timestamp,
  });

  /// Crea una instancia de [MeditationReviewModel] a partir de un mapa de datos.
  factory MeditationReviewModel.fromMap(Map<String, dynamic> map) {
    return MeditationReviewModel(
      userId: map['userId'] ?? 'Desconocido',
      id: map['id'] ?? '',
      meditationId: map['meditationId'] ?? '', // 🔹 Agregado aquí
      name: map['name'] ?? 'Anónimo',
      comment: map['comment'] ?? '',
      rating: map['rating'] ?? 0,
      timestamp: map['timestamp'] is Timestamp
          ? (map['timestamp'] as Timestamp).toDate()
          : DateTime.tryParse(map['timestamp'] ?? '') ?? DateTime.now(),
    );
  }

  /// Convierte la instancia actual en un mapa de datos para almacenamiento o transmisión.
  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'id': id,
      'meditationId': meditationId, // 🔹 Agregado aquí
      'name': name,
      'comment': comment,
      'rating': rating,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}