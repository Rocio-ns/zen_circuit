import 'package:flutter/material.dart';

class HelpScreen extends StatelessWidget {
  final List<Map<String, String>> helpTopics = [
    {
      'title': 'Cambiar tema',
      'content': 'Ve a Configuración > Tema y elige entre claro u oscuro.'
    },
    {
      'title': 'Cambiar idioma',
      'content': 'Ve a Configuración > Idioma y selecciona Español o Inglés.'
    },
    {
      'title': 'Cerrar sesión',
      'content': 'Haz clic en "Cerrar sesión" al final del menú.'
    },
    {
      'title': 'Eliminar cuenta',
      'content': 'Selecciona "Eliminar cuenta" y confirma tu decisión.'
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Ayuda'),
        backgroundColor: const Color.fromARGB(255, 109, 43, 118),
      ),
      body: ListView.builder(
        itemCount: helpTopics.length,
        itemBuilder: (context, index) {
          final topic = helpTopics[index];
          return ExpansionTile(
            title: Text(topic['title']!),
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Text(topic['content']!),
              ),
            ],
          );
        },
      ),
    );
  }
}