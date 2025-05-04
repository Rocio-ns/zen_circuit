class MeditationReviewModel {
  final String userId;
  final String id;
  final String name;
  final String comment;
  final int rating; // del 1 al 5
  final DateTime timestamp;

  MeditationReviewModel({
    required this.userId,
    required this.id,
    required this.name,
    required this.comment,
    required this.rating,
    required this.timestamp,
  });

  factory MeditationReviewModel.fromMap(Map<String, dynamic> map) {
    return MeditationReviewModel(
      userId: map['userId'],
      id: map['id'],
      name: map['name'],
      comment: map['comment'],
      rating: map['rating'],
      timestamp: DateTime.parse(map['timestamp']),
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'userId': userId,
      'id': id,
      'name': name,
      'comment': comment,
      'rating': rating,
      'timestamp': timestamp.toIso8601String(),
    };
  }
}