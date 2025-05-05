// lib/views/meditation_selection_view.dart

import 'package:flutter/material.dart';
import '../controllers/meditation_controller.dart';
import '../models/meditation_model.dart';
import '../services/auth_service.dart';
import 'meditation_detail_view.dart';
import '../generated/l10n.dart';

/// Pantalla de selección de meditaciones.
/// Permite a los usuarios explorar diferentes categorías de meditación disponibles.
class MeditationSelectionScreen extends StatelessWidget {
  /// Controlador que gestiona la obtención de categorías de meditación.
  final MeditationController _controller = MeditationController();

  /// Construcción de la interfaz de usuario para la pantalla de selección de meditaciones.
  @override
  Widget build(BuildContext context) {
    final t = S.of(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(t.explore),
        backgroundColor: const Color.fromARGB(255, 109, 43, 118),
        actions: [
          /// Botón para cerrar sesión del usuario.
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

          /// Listado de categorías de meditación disponibles.
          final categories = snapshot.data!;
          return Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                /// Indicación de la ruta de navegación actual.
                Text("${t.home} > ${t.explore}", style: TextStyle(fontSize: 14, color: Colors.grey)),
                const SizedBox(height: 20),

                /// Título principal de la pantalla.
                Center(
                  child: Text(t.meditationSelect, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 10),

                /// Subtítulo de categorías disponibles.
                Center(
                  child: Text(t.categories, style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold)),
                ),
                const SizedBox(height: 10),

                /// Listado de categorías con sus respectivas meditaciones.
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

  /// Construye la tarjeta para cada categoría de meditación.
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
            /// Muestra el nombre de la meditación en el idioma adecuado.
            title: Text(type.getLocalizedName(context)),
            onTap: () async {
              /// Navega a la pantalla de detalle de la meditación seleccionada.
              final result = await Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MeditationDetailScreen(
                    meditation: type,
                    category: category.getLocalizedName(context),
                  ),
                ),
              );

              /// Si la meditación fue completada, se actualiza el dashboard.
              if (result == true) {
                if (context.mounted) {
                  Navigator.pop(context, true); // Regresar al dashboard
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