import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../services/auth_service.dart';
import '../models/meditation_model.dart';
import '../services/meditation_service.dart';
import '../services/meditation_review_list_service.dart';
import '../utils/review_form.dart';
import '../generated/l10n.dart';

/// Pantalla que muestra los detalles de una meditación específica.
class MeditationDetailScreen extends StatefulWidget {
  /// Objeto [MeditationType] que contiene la información de la meditación seleccionada.
  final MeditationType meditation;

  /// Nombre de la categoría a la que pertenece la meditación.
  final String category;

  /// Constructor de [MeditationDetailScreen] para inicializar la meditación y su categoría.
  const MeditationDetailScreen({required this.meditation, required this.category, super.key});

  @override
  MeditationDetailScreenState createState() => MeditationDetailScreenState();
}

/// Estado de la pantalla de detalles de la meditación.
/// Gestiona la reproducción de audio y la actualización de la interfaz de usuario
class MeditationDetailScreenState extends State<MeditationDetailScreen> {
  /// Instancia del reproductor de audio.
  late AudioPlayer _audioPlayer;

  /// Indica si el audio está reproduciéndose.
  bool _isPlaying = false;

  /// Indica si el audio está en estado de carga o buffering.
  bool _isLoading = false;

  /// Posición actual de la reproducción de audio.
  Duration _currentPosition = Duration.zero;

  /// Duración total del audio.
  Duration _totalDuration = Duration.zero;

  /// Inicializa el reproductor de audio y configura los listeners.
  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();

    /// Escucha los cambios de estado del reproductor para actualizar la interfaz
    _audioPlayer.playerStateStream.listen((state) {
      setState(() {
        _isPlaying = state.playing;
        _isLoading = (state.processingState == ProcessingState.loading || state.processingState == ProcessingState.buffering);
      });
    });

    /// Escucha los cambios en la posición del audio y actualiza la interfaz
    _audioPlayer.positionStream.listen((position) {
      setState(() {
        _currentPosition = position;
      });
    });

    /// Escucha la duración total del audio y la almacena cuando está disponible.
    _audioPlayer.durationStream.listen((duration) {
      if (duration != null) {
        setState(() {
          _totalDuration = duration;
        });
      }
    });

    /// Escucha el estado de procesamiento del audio.
    /// Cuando el audio termina, ejecuta la función que maneja la finalización de la meditación
    _audioPlayer.processingStateStream.listen((state) {
      if (state == ProcessingState.completed) {
        // Cuando el audio termine, vuelve a poner el botón de Play
        _onMeditationCompleted();
      }
    });
  }

  /// Libera los recursos del reproductor de audio cuando se destruye la pantalla.
  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

  /// Inicia la reproducción de una meditación desde un archivo de audio.
  /// Muestra un mensaje de error si ocurre algún problema.
  Future<void> _startMeditation(String assetPath) async {
    final t = S.of(context);
    try {
      await _audioPlayer.setAsset(assetPath);
      await _audioPlayer.play();
    } catch (e) {
      print('${t.errorAudio}: $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("${t.errorAudio}: $e")),
        );
      }
    }
  }

  /// Pausa la reproducción de la meditación.
  void _pauseMeditation() {
    _audioPlayer.pause();
  }

  /// Detiene completamente la reproducción de la meditación.
  void _stopMeditation() {
    _audioPlayer.stop();
  }

  /// Formatea una duración en minutos y segundos con ceros a la izquierda si es necesario.
  /// Ejemplo: `00:45` en lugar de `0:45`.
  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

  // Mapa que almacena las imágenes correspondientes a cada meditación según su nombre.
  final Map<String, String> meditationImages = {
    'sueño profundo': 'assets/images/sleep.png',
    'deep sleep': 'assets/images/sleep.png',
    'sonidos relajantes': 'assets/images/sounds.png',
    'relaxing sounds': 'assets/images/sounds.png',
    'desconectar la mente': 'assets/images/disconnect.png',
    'disconnect the mind': 'assets/images/disconnect.png',
    'reducción del estrés': 'assets/images/stressReduction.png',
    'stress reduction': 'assets/images/stressReduction.png',
    'conciencia plena': 'assets/images/mindfulness.png',
    'mindfulness': 'assets/images/mindfulness.png',
    'reducción de la ansiedad': 'assets/images/anxietyReduction.png',
    'anxiety reduction': 'assets/images/anxietyReduction.png',
    'meditación guiada': 'assets/images/meditation.png',
    'guided meditation': 'assets/images/meditation.png',
    'respiración profunda': 'assets/images/deepBreathing.png',
    'deep breathing': 'assets/images/deepBreathing.png',
    'paz interior': 'assets/images/peace.png',
    'inner peace': 'assets/images/peace.png',
  };

  // Mapa que almacena los audios correspondientes a cada meditación según su nombre.
  final Map<String, String> meditationAudios = {
    'sueño profundo': 'assets/audios/sleep.ogg',
    'deep sleep': 'assets/audios/sleep.ogg',
    'sonidos relajantes': 'assets/audios/sounds.mp3',
    'relaxing sounds': 'assets/audios/sounds.mp3',
    'desconectar la mente': 'assets/audios/disconnect.mp3',
    'disconnect the mind': 'assets/audios/disconnect.mp3',
    'reducción del estrés': 'assets/audios/stressReduction.mp3',
    'stress reduction': 'assets/audios/stressReduction.mp3',
    'conciencia plena': 'assets/audios/mindfulness.mp3',
    'mindfulness': 'assets/audios/mindfulness.mp3',
    'reducción de la ansiedad': 'assets/audios/anxietyReduction.mp3',
    'anxiety reduction': 'assets/audios/anxietyReduction.mp3',
    'meditación guiada': 'assets/audios/meditation.mp3',
    'guided meditation': 'assets/audios/meditation.mp3',
    'respiración profunda': 'assets/audios/deepBreathing.mp3',
    'deep breathing': 'assets/audios/deepBreathing.mp3',
    'paz interior': 'assets/audios/peace.mp3',
    'inner peace': 'assets/audios/peace.mp3',
  };

  /// Construcción de la interfaz de usuario de la pantalla de detalles de meditación.
  @override
  Widget build(BuildContext context) {
    final t = S.of(context);

    /// Obtiene la imagen y el audio correspondiente a la meditación seleccionada.
    final imagePath = meditationImages[widget.meditation.getLocalizedName(context).toLowerCase()] ?? 'assets/images/logo.png';
    final audioPath = meditationAudios[widget.meditation.getLocalizedName(context).toLowerCase()] ?? 'assets/audios/disconnect.mp3';

    return Scaffold(
      resizeToAvoidBottomInset: true, // Ajusta la UI cuando se muestra el teclado.
      appBar: AppBar(
        title: Text(widget.meditation.getLocalizedName(context)),
        backgroundColor: const Color.fromARGB(255, 109, 43, 118),
        actions: [
          /// Botón para cerrar sesión del usuario.
          IconButton(
            icon: const Icon(Icons.logout, color: Color.fromARGB(255, 253, 251, 253)),
            onPressed: () => AuthService.confirmSignOut(context),
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Muestra la ruta de navegación actual.
              Text("${t.home} > ${t.explore} > ${widget.category} > ${widget.meditation.getLocalizedName(context)}",
                  style: const TextStyle(fontSize: 14, color: Colors.grey)),

              const SizedBox(height: 20),

              /// Muestra la imagen de la meditación.
              Center(child: Image.asset(imagePath, height: 180)),

              const SizedBox(height: 20),

              /// Título de la meditación.
              Center(
                child: Text(widget.meditation.getLocalizedName(context),
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold)),
              ),

              const SizedBox(height: 10),

              /// Descripción de la meditación.
              Center(
                child: Text(widget.meditation.getLocalizedDescription(context),
                    style: const TextStyle(fontSize: 16)),
              ),

              const SizedBox(height: 30),

              /// Barra de progreso del audio de la meditación.
              Slider(
                min: 0,
                max: _totalDuration.inSeconds.toDouble(),
                value: _currentPosition.inSeconds.toDouble().clamp(0.0, _totalDuration.inSeconds.toDouble()),
                onChanged: (value) async {
                  await _audioPlayer.seek(Duration(seconds: value.toInt()));
                },
                activeColor: const Color.fromARGB(255, 109, 43, 118),
                inactiveColor: Colors.grey,
              ),

              /// Muestra la duración actual y total del audio.
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(_formatDuration(_currentPosition)),
                  Text(_formatDuration(_totalDuration)),
                ],
              ),

              const SizedBox(height: 30),

              /// Controles de reproducción de la meditación.
              Center(
                child: _isLoading
                    ? const CircularProgressIndicator(color: Color.fromARGB(255, 109, 43, 118)) // Loader mientras carga.
                    : Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          ElevatedButton.icon(
                            onPressed: _isPlaying ? _pauseMeditation : () => _startMeditation(audioPath),
                            icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                            label: Text(
                              _isPlaying ? t.pause : t.play,
                              style: const TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: const Color.fromARGB(255, 109, 43, 118),
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            ),
                          ),
                          const SizedBox(width: 20),
                          ElevatedButton.icon(
                            onPressed: _stopMeditation,
                            icon: const Icon(Icons.stop),
                            label: Text(
                              t.stop,
                              style: const TextStyle(color: Colors.white),
                            ),
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.red,
                              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                            ),
                          ),
                        ],
                      ),
              ),

              const SizedBox(height: 30),

              /// Sección de reseñas de la meditación.
              MeditationReviewListService(meditationId: widget.meditation.id),

              const SizedBox(height: 20),

              /// Botón para agregar una nueva reseña.
              Center(
                child: ElevatedButton.icon(
                  onPressed: () {
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(25.0)),
                      ),
                      builder: (context) {
                        return Padding(
                          padding: EdgeInsets.only(
                            bottom: MediaQuery.of(context).viewInsets.bottom,
                            top: 20,
                            left: 20,
                            right: 20,
                          ),
                          child: Wrap(
                            children: [
                              Center(
                                child: Text(
                                  t.addReview,
                                  style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                                ),
                              ),
                              const SizedBox(height: 10),
                              ReviewForm(
                                meditationId: widget.meditation.id,
                                name: widget.meditation.getLocalizedName(context),
                                onReviewSubmitted: () {
                                  Navigator.pop(context); // Cierra el modal.
                                  setState(() {}); // Refresca las reseñas.
                                },
                              ),
                            ],
                          ),
                        );
                      },
                    );
                  },
                  icon: const Icon(Icons.rate_review),
                  label: Text(t.addReview),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 109, 43, 118),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 14),
                    textStyle: const TextStyle(fontSize: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(30.0),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  /// Maneja la finalización de la meditación, marcándola como completada.
  Future<void> _onMeditationCompleted() async {
    final t = S.of(context);
    try {
      final meditationService = MeditationService();
      await meditationService.completeMeditation(widget.meditation.id, widget.meditation.getLocalizedName(context));

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.medCompleted)));
        setState(() {
          _isPlaying = false; // Restablece el estado de reproducción.
        });
        Navigator.pop(context, true); // Devuelve `true` a la pantalla anterior.
      }
    } catch (e) {
      print('${t.errorMedCompleted} $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(t.errorRegisterProgress)));
      }
    }
  }
}