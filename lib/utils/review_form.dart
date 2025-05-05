import 'package:flutter/material.dart';
import '../models/meditation_review_model.dart';
import '../services/auth_service.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../services/meditation_service.dart';
import '../generated/l10n.dart';

/// Formulario para que los usuarios dejen una reseña sobre una meditación.
class ReviewForm extends StatefulWidget {
  /// Identificador único de la meditación que se está evaluando.
  final String meditationId;

  /// Nombre de la meditación.
  final String name;

  /// Callback opcional que se ejecuta después de enviar la reseña.
  final void Function()? onReviewSubmitted;

  /// Constructor de [ReviewForm].
  ReviewForm({required this.meditationId, required this.name, this.onReviewSubmitted});

  @override
  ReviewFormState createState() => ReviewFormState();
}

/// Estado de [ReviewForm] que maneja la lógica de captura y envío de la reseña.
class ReviewFormState extends State<ReviewForm> {
  /// Controlador de texto para capturar el comentario del usuario.
  final _commentController = TextEditingController();

  /// Almacena la calificación seleccionada (de 1 a 5 estrellas).
  int _rating = 0;

  /// Envía la reseña del usuario y actualiza la interfaz.
  void _submitReview() async {
    final userId = AuthService.currentUserId();
    if (userId.isEmpty) {
      print("❌ Error: Usuario no autenticado.");
      return;
    }

    if (_commentController.text.trim().isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("❌ No puedes enviar una reseña vacía.")),
      );
      return;
    }

    // Crea una instancia de reseña con la información proporcionada por el usuario.
    final review = MeditationReviewModel(
      userId: AuthService.currentUserId(),
      id: FirebaseFirestore.instance.collection('reviews').doc().id, // Genera un ID único para la reseña
      meditationId: widget.meditationId,
      name: widget.name,
      comment: _commentController.text,
      rating: _rating,
      timestamp: DateTime.now(),
    );

    // Enviar la reseña al servicio de meditaciones.
    await MeditationService().submitReview(review);

    if (mounted) {
      final t = S.of(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.opinionThanks)));

      // Limpiar el formulario después de enviar la reseña.
      _commentController.clear();
      setState(() {
        _rating = 0;
      });

      // Llama al callback si fue definido.
      widget.onReviewSubmitted?.call();

      // Cierra el diálogo de la reseña sin afectar la pantalla principal.
      _closeDialog();
    }
  }

  /// Cierra el cuadro de diálogo si es posible.
  void _closeDialog() {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop(); // Solo cierra si hay algo que cerrar.
    }
  }

  /// Construcción de la interfaz del formulario de reseña.
  @override
  Widget build(BuildContext context) {
    final t = S.of(context);
    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Campo para ingresar el comentario del usuario.
          Text(t.comment, style: TextStyle(fontWeight: FontWeight.bold)),
          TextField(controller: _commentController),

          const SizedBox(height: 10),

          /// Sección para seleccionar una calificación en estrellas.
          Text(t.review),
          Row(
            children: List.generate(5, (index) {
              return IconButton(
                icon: Icon(
                  index < _rating ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                ),
                onPressed: () => setState(() => _rating = index + 1),
              );
            }),
          ),

          /// Botón para enviar la reseña.
          ElevatedButton(onPressed: _submitReview, child: Text(t.submit)),
        ],
      ),
    );
  }
}