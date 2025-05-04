// lib/models/meditation_model.dart
import 'package:flutter/material.dart';

class MeditationType {
  final String id;
  final Map<String, String> name;
  final Map<String, String> description;
  final String audioUrl;

  MeditationType({
    required this.id,
    required this.name,
    required this.description,
    required this.audioUrl,
  });

/*
  factory MeditationType.fromFirestore(Map<String, dynamic> data) {
    return MeditationType(
      id: (data['id'] ?? '').toString(),
      name: _parseStringMap(data['name']),
      description: _parseStringMap(data['description']),
      audioUrl: data['audioUrl'] ?? '',
    );
  }
*/

  factory MeditationType.fromMap(Map<String, dynamic> map) {
    final rawName = map['name'] as Map<String, dynamic>? ?? {};
    final rawDescription = map['description'] as Map<String, dynamic>? ?? {};

    return MeditationType(
      id: (map['id'] ?? '').toString(),
      name: Map<String, String>.from(rawName),  // Convertir 'name' a Map<String, String>
      description: Map<String, String>.from(rawDescription),  // Convertir 'description' a Map<String, String>
      audioUrl: map['audioUrl'] ?? '',
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,  // Guardar 'name' como Map<String, String>
      'description': description,  // Guardar 'description' como Map<String, String>
      'audioUrl': audioUrl,
    };
  }

/*
  static Map<String, String> _parseStringMap(dynamic input) {
    if (input is Map) {
      return input.map((key, value) =>
          MapEntry(key.toString(), value.toString()));
    }
    return {};
  }
  */
}

extension LocalizedMeditationType on MeditationType {
  String getLocalizedName(BuildContext context) {
    return _getLocalizedString(name, context);
  }

  String getLocalizedDescription(BuildContext context) {
    return _getLocalizedString(description, context);
  }

  String _getLocalizedString(Map<String, String> map, BuildContext context) {
    final langCode = Localizations.localeOf(context).languageCode;
    return map[langCode] ?? map['en'] ?? 'Sin traducción';
  }
}

class MeditationCategory {
  final Map<String, String> name;
  final List<MeditationType> types;

  MeditationCategory({
    required this.name,
    required this.types,
  });

  factory MeditationCategory.fromFirestore(Map<String, dynamic> data) {
    final rawTypes = data['types'] as List<dynamic>? ?? [];
    final types = rawTypes
        .map((t) => MeditationType.fromMap(
            Map<String, dynamic>.from(t))) // aseguro tipos
        .toList();
    
    // Deserializar 'name' como un Map<String, String>
    final rawName = data['name'] as Map<String, dynamic>? ?? {};

    return MeditationCategory(
      name: Map<String, String>.from(rawName),
      types: types,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'types': types.map((t) => t.toMap()).toList(),
    };
  }
}

extension LocalizedMeditationCategory on MeditationCategory {
  String getLocalizedName(BuildContext context) {
    return _getLocalizedString(name, context);
  }

  String _getLocalizedString(Map<String, String> map, BuildContext context) {
    final langCode = Localizations.localeOf(context).languageCode;
    return map[langCode] ?? map['en'] ?? 'Sin traducción';
  }
}