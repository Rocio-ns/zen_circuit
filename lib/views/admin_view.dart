import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../generated/l10n.dart';
import 'package:intl/intl.dart';

/// Clase `AdminView` que proporciona una interfaz para gestionar reseñas de meditaciones.
/// Los administradores pueden eliminar comentarios o responder a ellos dentro de la aplicación. También podrán eliminar usuarios
class AdminView extends StatefulWidget {
  const AdminView({super.key});

  @override
  State<AdminView> createState() => _AdminViewState();
}

class _AdminViewState extends State<AdminView> {
  late Future<List<Map<String, dynamic>>> _reviewsFuture;
  List<Map<String, dynamic>> _users = [];

  @override
  void initState() {
    super.initState();
    _loadReviews();
    _loadUsers();
  }

  // Carga todas las reseñas desde Firebase y guarda su ID
  void _loadReviews() {
    _reviewsFuture = FirebaseFirestore.instance
        .collection('allReviews')
        .orderBy('timestamp', descending: true)
        .get()
        .then((snapshot) => snapshot.docs.map((doc) {
              final data = doc.data();
              data['id'] = doc.id; // Añadimos el ID del documento
              return data;
            }).toList());
  }

  // Carga usuarios de la colección "users"
  Future<void> _loadUsers() async {
    try {
      final snapshot = await FirebaseFirestore.instance.collection('users').get();
      setState(() {
        _users = snapshot.docs.map((doc) {
          final data = doc.data();
          data['id'] = doc.id;
          return data;
        }).toList();
      });
    } catch (e) {
      print("❌ Error al cargar usuarios: $e");
    }
  }

  /// Elimina una reseña por su ID
  Future<void> deleteReview(String reviewId) async {
    final t = S.of(context);
    try {
      await FirebaseFirestore.instance.collection('allReviews').doc(reviewId).delete();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("✅ ${t.reviewDeleted}")));
        setState(() => _loadReviews());
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("❌ Error: $e")));
      }
    }
  }

  /// Responde a una reseña y actualiza la pantalla
  Future<void> replyToReview(String reviewId, String reply) async {
    final t = S.of(context);
    try {
      await FirebaseFirestore.instance.collection('allReviews').doc(reviewId).update({'reply': reply});
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("💬 ${t.answerSaved}")));
        setState(() => _loadReviews());
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("❌ ${t.errorAnswer} $e")));
      }
    }
  }

  /// Cuadro de diálogo para escribir la respuesta a una reseña
  void _showReplyDialog(String reviewId) {
    final t = S.of(context);
    final controller = TextEditingController();
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text(t.answerReview),
        content: TextField(
          controller: controller,
          decoration: InputDecoration(labelText: t.yourAnswer),
        ),
        actions: [
          TextButton(onPressed: () => Navigator.pop(ctx), child: Text(t.cancel)),
          TextButton(
            onPressed: () {
              final reply = controller.text.trim();
              if (reply.isNotEmpty) {
                replyToReview(reviewId, reply);
                Navigator.pop(ctx);
              }
            },
            child: Text(t.submit),
          ),
        ],
      ),
    );
  }

  /// Elimina un usuario y actualiza la lista
  Future<void> deleteUser(String userId) async {
    final t = S.of(context);
    try {
      await FirebaseFirestore.instance.collection('users').doc(userId).delete();
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("🧑‍💼 ${t.deleteUser}")));
        _loadUsers();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("❌ Error: $e")));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final t = S.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(t.adminView),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            tooltip: t.update,
            onPressed: () {
              setState(() {
                _loadReviews();
              });
              _loadUsers();
            },
          ),
        ],
      ),
      body: FutureBuilder<List<Map<String, dynamic>>>(
        future: _reviewsFuture,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }

          if (snapshot.hasError) {
            return Center(child: Text('❌ ${t.errorLoadingReviews}'));
          }

          final reviews = snapshot.data!;
          return ListView(
            children: [
              // SECCIÓN DE RESEÑAS
              Padding(
                padding: EdgeInsets.all(12),
                child: Text("📝 ${t.reviewsTitle}", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
              ),
              ...reviews.map((review) {
                final timestamp = review['timestamp'];
                String formattedDate = t.undated;

                if (timestamp is Timestamp) {
                  formattedDate = DateFormat('yyyy-MM-dd – kk:mm').format(timestamp.toDate());
                }

                return Card(
                  elevation: 3,
                  margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(review['comment'] ?? '', style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                        const SizedBox(height: 8),
                        Text("👤 ${review['userName']} | ⭐ ${review['rating']}"),
                        Text("🕒 $formattedDate"),
                        if (review['reply'] != null && (review['reply'] as String).isNotEmpty) ...[
                          const SizedBox(height: 6),
                          Text("💬 ${t.answer} ${review['reply']}", style: const TextStyle(color: Colors.blueGrey)),
                        ],
                        const SizedBox(height: 12),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.reply, color: Colors.blue),
                              tooltip: t.answer,
                              onPressed: () => _showReplyDialog(review['id']),
                            ),
                            IconButton(
                              icon: const Icon(Icons.delete, color: Colors.red),
                              tooltip: t.delete,
                              onPressed: () async {
                                final confirm = await showDialog<bool>(
                                  context: context,
                                  builder: (ctx) => AlertDialog(
                                    title: Text(t.deleteReview),
                                    content: Text(t.actionUndone),
                                    actions: [
                                      TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(t.cancel)),
                                      TextButton(
                                        onPressed: () => Navigator.pop(ctx, true),
                                        child: Text(t.delete, style: TextStyle(color: Colors.red)),
                                      ),
                                    ],
                                  ),
                                );
                                if (confirm == true) {
                                  deleteReview(review['id']);
                                }
                              },
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }),

              const Divider(),

              // SECCIÓN DE USUARIOS
              ExpansionTile(
                title: Text("👥 ${t.userManagement}", style: TextStyle(fontWeight: FontWeight.bold)),
                children: _users.map((user) {
                  return ListTile(
                    title: Text(user['name'] ?? t.unknownName),
                    subtitle: Text(user['email'] ?? t.noEmail),
                    trailing: IconButton(
                      icon: const Icon(Icons.delete, color: Colors.red),
                      onPressed: () async {
                        final confirm = await showDialog<bool>(
                          context: context,
                          builder: (ctx) => AlertDialog(
                            title: Text(t.deleteUser),
                            content: Text(t.actionIrreversible),
                            actions: [
                              TextButton(onPressed: () => Navigator.pop(ctx, false), child: Text(t.cancel)),
                              TextButton(
                                onPressed: () => Navigator.pop(ctx, true),
                                child: Text(t.delete, style: TextStyle(color: Colors.red)),
                              ),
                            ],
                          ),
                        );
                        if (confirm == true) {
                          deleteUser(user['id']);
                        }
                      },
                    ),
                  );
                }).toList(),
              ),
            ],
          );
        },
      ),
    );
  }
}