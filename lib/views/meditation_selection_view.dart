// lib/views/meditation_selection_view.dart
import 'package:flutter/material.dart';
import '../controllers/meditation_controller.dart';
import '../models/meditation_model.dart';
import '../services/auth_service.dart';
import 'meditation_detail_view.dart';
import '../generated/l10n.dart';

class MeditationSelectionScreen extends StatelessWidget {
  final MeditationController _controller = MeditationController();

  @override
  Widget build(BuildContext context) {
    final t = S.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(t.explore),
        backgroundColor: const Color.fromARGB(255, 109, 43, 118),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Color.fromARGB(255, 253, 251, 253)),
            onPressed: () => AuthService.confirmSignOut(context),
          ),
        ],
      ),
      body: FutureBuilder<List<MeditationCategory>>(
        future: _controller.getCategories(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError) {
            return Center(child: Text("Error: ${snapshot.error}"));
          }
          final categories = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${t.home} > ${t.explore}",
                    style: TextStyle(fontSize: 14, color: Colors.grey)),
                const SizedBox(height: 20),
                Center(
                  child: Text(t.meditationSelect,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 10),
                Center(
                  child: Text(t.categories,
                    style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                ), 
                const SizedBox(height: 10),
                Expanded(
                  child: ListView.builder(
                    itemCount: categories.length,
                    itemBuilder: (context, index) {
                      final category = categories[index];
                      return _buildCategoryCard(context, category);
                    },
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }

  Widget _buildCategoryCard(BuildContext context, MeditationCategory category) {
    final t = S.of(context);
    return Card(
      elevation: 3,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ExpansionTile(
        title: Text(
          category.getLocalizedName(context),
          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
        children: category.types.map((type) {
          return ListTile(
            title: Text(type.getLocalizedName(context)),
            onTap: () async {
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MeditationDetailScreen(
                    meditation: type,
                    category: category.getLocalizedName(context),
                  ),
                ),
              );

              // Si la meditación fue completada, recarga el dashboard si está activo
              if (result == true) {
                if (context.mounted) {
                  // Hará que el dashboard se actualice
                  Navigator.pop(context, true);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(t.updatedSummary)),
                  );
                }
              }
            },
          );
        }).toList(),
      ),
    );
  }
}