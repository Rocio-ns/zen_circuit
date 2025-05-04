import 'package:flutter/material.dart';
import '../models/meditation_review_model.dart';
import '../services/auth_service.dart';
import '../services/meditation_service.dart';
import '../generated/l10n.dart';

class ReviewForm extends StatefulWidget {
  final String id;
  final String name;
  final void Function()? onReviewSubmitted;

  ReviewForm({required this.id, required this.name, this.onReviewSubmitted});

  @override
  ReviewFormState createState() => ReviewFormState();
}

class ReviewFormState extends State<ReviewForm> {
  final _commentController = TextEditingController();
  int _rating = 0;

  void _submitReview() async {
    final review = MeditationReviewModel(
      userId: AuthService.currentUserId(),
      id: widget.id,
      name: widget.name,
      comment: _commentController.text,
      rating: _rating,
      timestamp: DateTime.now(),
    );

    await MeditationService().submitReview(review);

    if (mounted) {
      final t = S.of(context);
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.opinionThanks)));
      _commentController.clear();
      setState(() {
        _rating = 0;
      });

      // Llama al callback
      widget.onReviewSubmitted?.call();

      _closeDialog(); // cerrar el modelo, NO la pantalla principal
    }
  }

  void _closeDialog() {
    if (Navigator.of(context).canPop()) {
      Navigator.of(context).pop(); // solo cierra si hay algo que cerrar
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = S.of(context);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(t.comment, style: TextStyle(fontWeight: FontWeight.bold)),
        TextField(controller: _commentController),
        SizedBox(height: 10),
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
        ElevatedButton(onPressed: _submitReview, child: Text(t.send)),
      ],
    );
  }
}