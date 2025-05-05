import 'package:flutter/material.dart';
import '../models/meditation_review_model.dart';
import '../services/meditation_service.dart';
import '../generated/l10n.dart';

/// Widget que muestra la lista de reseñas de una meditación específica.
/// Recupera las reseñas desde el servicio y las presenta en un formato visual atractivo.
class MeditationReviewListService extends StatefulWidget {
  /// Identificador único de la meditación para obtener sus reseñas.
  final String meditationId;

  /// Constructor para inicializar la pantalla con la meditación correspondiente.
  const MeditationReviewListService({required this.meditationId, super.key});

  @override
  MeditationReviewListServiceState createState() => MeditationReviewListServiceState();
}

/// Estado de [MeditationReviewListService] donde se maneja la lógica de carga de reseñas.
class MeditationReviewListServiceState extends State<MeditationReviewListService> {
  /// Futuro que contiene la lista de reseñas de la meditación.
  late Future<List<MeditationReviewModel>> _futureReviews;

  /// Inicializa la carga de reseñas al iniciar la pantalla.
  @override
  void initState() {
    super.initState();
    _futureReviews = MeditationService().getReviewsByMeditation(widget.meditationId);
  }

  /// Construcción de la interfaz de usuario para mostrar las reseñas.
  @override
  Widget build(BuildContext context) {
    final t = S.of(context);
    return FutureBuilder<List<MeditationReviewModel>>(
      future: _futureReviews,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }

        final reviews = snapshot.data ?? [];

        /// Muestra un mensaje si no hay reseñas disponibles.
        if (reviews.isEmpty) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 20),
              Text(
                t.noReviewsYet,
                style: const TextStyle(fontSize: 16, fontStyle: FontStyle.italic),
              ),
            ],
          );
        }

        /// Calcula el promedio de calificaciones de las reseñas.
        final average = reviews.map((r) => r.rating).reduce((a, b) => a + b) / reviews.length;

        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),

            /// Título de la sección de reseñas.
            Text(
              t.reviewsTitle,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),

            /// Muestra el promedio de calificaciones con un icono.
            Row(
              children: [
                const Icon(Icons.star, color: Colors.amber),
                const SizedBox(width: 5),
                Text(
                  "${average.toStringAsFixed(1)} / 5.0",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const SizedBox(height: 16),

            /// Lista de reseñas mostradas en tarjetas.
            ...reviews.map((r) => Card(
              elevation: 2,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              margin: const EdgeInsets.only(bottom: 12),
              child: Padding(
                padding: const EdgeInsets.all(12.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: List.generate(
                        5,
                        (index) => Icon(
                          index < r.rating ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                          size: 20,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      r.comment,
                      style: const TextStyle(fontSize: 16),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      _formatTimestamp(r.timestamp),
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
              ),
            )),
          ],
        );
      },
    );
  }

  /// Formatea la fecha y hora de la reseña en formato legible.
  String _formatTimestamp(DateTime timestamp) {
    return "${timestamp.day}/${timestamp.month}/${timestamp.year} ${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}";
  }
}