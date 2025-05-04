import 'package:flutter/material.dart';
import '../models/meditation_review_model.dart';
import '../services/meditation_service.dart';
import '../generated/l10n.dart';

class MeditationReviewListService extends StatefulWidget {
  final String meditationId;

  const MeditationReviewListService({required this.meditationId, super.key});

  @override
  MeditationReviewListServiceState createState() => MeditationReviewListServiceState();
}

class MeditationReviewListServiceState extends State<MeditationReviewListService> {
  late Future<List<MeditationReviewModel>> _futureReviews;

  @override
  void initState() {
    super.initState();
    _futureReviews = MeditationService().getReviews(widget.meditationId);
  }

  @override
  Widget build(BuildContext context) {
    final t = S.of(context);
    return FutureBuilder<List<MeditationReviewModel>>(
      future: _futureReviews,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        }

        final reviews = snapshot.data ?? [];

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

        final average = reviews.map((r) => r.rating).reduce((a, b) => a + b) / reviews.length;

        
        return Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 30),
            Text(
              t.reviewsTitle,
              style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Icon(Icons.star, color: Colors.amber),
                const SizedBox(width: 5),
                Text(
                  "${average.toStringAsFixed(1)} / 5.0",
                  style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
                ),
              ],
            ),
            const SizedBox(height: 16),
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

      /*  
        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: reviews.length,
          itemBuilder: (context, index) {
            final review = reviews[index];
            return Card(
              margin: EdgeInsets.symmetric(vertical: 6),
              child: Padding(
                padding: EdgeInsets.all(12),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: List.generate(5, (i) {
                        return Icon(
                          i < review.rating ? Icons.star : Icons.star_border,
                          color: Colors.amber,
                          size: 20,
                        );
                      }),
                    ),
                    SizedBox(height: 4),
                    if (review.comment.isNotEmpty)
                      Text(review.comment, style: TextStyle(fontSize: 16)),
                    SizedBox(height: 4),
                    Text(
                      _formatDate(review.timestamp),
                      style: TextStyle(color: Colors.grey, fontSize: 12),
                    ),
                  ],
                ),
              ),
            );
          },
        );
      */
      },
    );
  }

  String _formatTimestamp(DateTime timestamp) {
    return "${timestamp.day}/${timestamp.month}/${timestamp.year} ${timestamp.hour}:${timestamp.minute.toString().padLeft(2, '0')}";
  }
}