// lib/models/meditation_model.dart
import 'package:flutter/material.dart';

/// Representa un tipo de meditación con sus atributos fundamentales.
class MeditationType {
  /// Identificador único de la meditación.
  final String id;

  /// Nombre de la meditación en diferentes idiomas.
  final Map<String, String> name;

  /// Descripción de la meditación en diferentes idiomas.
  final Map<String, String> description;

  /// URL del audio asociado a la meditación.
  final String audioUrl;

  /// Constructor para inicializar un objeto [MeditationType].
  MeditationType({
    required this.id,
    required this.name,
    required this.description,
    required this.audioUrl,
  });

  /// Crea una instancia de [MeditationType] a partir de un mapa de datos.
  factory MeditationType.fromMap(Map<String, dynamic> map) {
    final rawName = map['name'] as Map<String, dynamic>? ?? {};
    final rawDescription = map['description'] as Map<String, dynamic>? ?? {};

    return MeditationType(
      id: (map['id'] ?? 'sin_id').toString(), // Si no hay 'id', usa 'sin_id
      name: Map<String, String>.from(rawName),
      description: Map<String, String>.from(rawDescription),
      audioUrl: map['audioUrl'] ?? '',
    );
  }

  /// Convierte la instancia actual en un mapa de datos.
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'audioUrl': audioUrl,
    };
  }
}

/// Extensión para obtener los valores localizados de un [MeditationType].
extension LocalizedMeditationType on MeditationType {
  /// Obtiene el nombre localizado basado en el idioma del contexto.
  String getLocalizedName(BuildContext context) {
    return _getLocalizedString(name, context);
  }

  /// Obtiene la descripción localizada basada en el idioma del contexto.
  String getLocalizedDescription(BuildContext context) {
    return _getLocalizedString(description, context);
  }

  /// Método auxiliar para recuperar un valor localizado desde un mapa de idiomas.
  String _getLocalizedString(Map<String, String> map, BuildContext context) {
    final langCode = Localizations.localeOf(context).languageCode;
    return map[langCode] ?? map['en'] ?? 'Sin traducción';
  }
}

/// Representa una categoría de meditaciones con múltiples tipos.
class MeditationCategory {
  /// Nombre de la categoría en diferentes idiomas.
  final Map<String, String> name;

  /// Lista de tipos de meditación dentro de la categoría.
  final List<MeditationType> types;

  /// Constructor para inicializar un objeto [MeditationCategory].
  MeditationCategory({
    required this.name,
    required this.types,
  });

  /// Crea una instancia de [MeditationCategory] a partir de datos obtenidos de Firestore.
  factory MeditationCategory.fromFirestore(Map<String, dynamic> data) {
    final rawTypes = data['types'] as List<dynamic>? ?? [];
    final types = rawTypes
        .map((t) => MeditationType.fromMap(Map<String, dynamic>.from(t)))
        .toList();

    final rawName = data['name'] as Map<String, dynamic>? ?? {};

    return MeditationCategory(
      name: Map<String, String>.from(rawName),
      types: types,
    );
  }

  /// Convierte la instancia actual en un mapa de datos.
  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'types': types.map((t) => t.toMap()).toList(),
    };
  }
}

/// Extensión para obtener el nombre localizado de un [MeditationCategory].
extension LocalizedMeditationCategory on MeditationCategory {
  /// Obtiene el nombre localizado basado en el idioma del contexto.
  String getLocalizedName(BuildContext context) {
    return _getLocalizedString(name, context);
  }

  /// Método auxiliar para recuperar un valor localizado desde un mapa de idiomas.
  String _getLocalizedString(Map<String, String> map, BuildContext context) {
    final langCode = Localizations.localeOf(context).languageCode;
    return map[langCode] ?? map['en'] ?? 'Sin traducción';
  }
}