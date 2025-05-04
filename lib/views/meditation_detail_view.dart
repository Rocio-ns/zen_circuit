import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import '../services/auth_service.dart';
import '../models/meditation_model.dart';
import '../services/meditation_service.dart';
import '../services/meditation_review_list_service.dart';
import '../utils/review_form.dart';
import '../generated/l10n.dart';

class MeditationDetailScreen extends StatefulWidget {
  final MeditationType meditation;
  final String category;

  const MeditationDetailScreen({required this.meditation, required this.category,super.key});

  @override
  MeditationDetailScreenState createState() => MeditationDetailScreenState();
}

class MeditationDetailScreenState extends State<MeditationDetailScreen> {
  late AudioPlayer _audioPlayer;
  bool _isPlaying = false;
  bool _isLoading = false; // para saber si está cargando

  Duration _currentPosition = Duration.zero;
  Duration _totalDuration = Duration.zero;

  @override
  void initState() {
    super.initState();
    _audioPlayer = AudioPlayer();

    // Escuchamos los cambios de estado para actualizar la UI
    _audioPlayer.playerStateStream.listen((state) {
      setState(() {
        _isPlaying = state.playing;
        _isLoading = (state.processingState == ProcessingState.loading || state.processingState == ProcessingState.buffering);
      });
    });

    _audioPlayer.positionStream.listen((position) {
      setState(() {
        _currentPosition = position;
      });
    });

    _audioPlayer.durationStream.listen((duration) {
      if (duration != null) {
        setState(() {
          _totalDuration = duration;
        });
      }
    });

    // Escuchar cuando el audio termina
    _audioPlayer.processingStateStream.listen((state) {
      if (state == ProcessingState.completed) {
        // Cuando el audio termine, volvemos a poner el botón de Play
        _onMeditationCompleted();
      }
    });
  }

  @override
  void dispose() {
    _audioPlayer.dispose();
    super.dispose();
  }

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

  void _pauseMeditation() {
    _audioPlayer.pause();
  }

  void _stopMeditation() {
    _audioPlayer.stop();
  }

  String _formatDuration(Duration duration) {
    String twoDigits(int n) => n.toString().padLeft(2, '0');
    final minutes = twoDigits(duration.inMinutes.remainder(60));
    final seconds = twoDigits(duration.inSeconds.remainder(60));
    return '$minutes:$seconds';
  }

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

  @override
  Widget build(BuildContext context) {
    final t = S.of(context);
    final imagePath = meditationImages[widget.meditation.getLocalizedName(context).toLowerCase()] ?? 'assets/images/logo.png';
    final audioPath = meditationAudios[widget.meditation.getLocalizedName(context).toLowerCase()] ?? 'assets/audios/disconnect.mp3';
    return Scaffold(
      resizeToAvoidBottomInset: true, // para que se ajuste con el teclado
      appBar: AppBar(
        title: Text(widget.meditation.getLocalizedName(context)),
        backgroundColor: const Color.fromARGB(255, 109, 43, 118),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout, color: Color.fromARGB(255, 253, 251, 253)),
            onPressed: () => AuthService.confirmSignOut(context),
          )
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                Text(
                  "${t.home} > ${t.explore} > ${widget.category} > ${widget.meditation.getLocalizedName(context)}",
                  style: const TextStyle(fontSize: 14, color: Colors.grey),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Image.asset(
                    imagePath,
                    height: 180,
                  ),
                ),
                const SizedBox(height: 20),
                Center(
                  child: Text(
                    widget.meditation.getLocalizedName(context),
                    style: const TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                const SizedBox(height: 10),
                Center(
                  child: Text(
                    widget.meditation.getLocalizedDescription(context),
                    style: const TextStyle(fontSize: 16),
                  ),
                ),
                const SizedBox(height: 30),
                // Barra de progreso
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
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(_formatDuration(_currentPosition)),
                    Text(_formatDuration(_totalDuration)),
                  ],
                ),
                const SizedBox(height: 30),
                Center(
                  child: _isLoading
                  ? const CircularProgressIndicator(color: Color.fromARGB(255, 109, 43, 118)) // <-- Loader cuando carga
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ElevatedButton.icon(
                          onPressed: _isPlaying
                                    ? _pauseMeditation
                                    : () => _startMeditation(audioPath),
                          //_isPlaying ? _pauseMeditation : _startMeditation,
                          icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                          label: Text(_isPlaying ? t.pause : t.play),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: const Color.fromARGB(255, 109, 43, 118),
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          ),
                        ),
                        const SizedBox(width: 20),
                        ElevatedButton.icon(
                          onPressed: _stopMeditation,
                          icon: const Icon(Icons.stop),
                          label: Text(t.stop),
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                          ),
                        ),
                      ],
                    ),
                ),
                // Llamamos a _buildReviewsSection()
                const SizedBox(height: 30),  // Espacio antes de las reseñas
                MeditationReviewListService(meditationId: widget.meditation.id),

                const SizedBox(height: 20),
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
                                  id: widget.meditation.id,
                                  name: widget.meditation.getLocalizedName(context),
                                  onReviewSubmitted: () {
                                    Navigator.pop(context); // Cierra el modal
                                    setState(() {});        // Refresca las reviews
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
        )
      )
    );
  }

  Future<void> _onMeditationCompleted() async {
    final t = S.of(context);
    try {
      // Marcar la meditación como completada
      final meditationService = MeditationService();
      await meditationService.completeMeditation(widget.meditation.id, widget.meditation.getLocalizedName(context));

      // Mostrar un mensaje al usuario, solo si el widget sigue montado
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(t.medCompleted)),
        );
      }

      // Ahora actualizamos el estado para cambiar el icono a Play, solo si el widget sigue montado
      if (mounted) {
        setState(() {
          _isPlaying = false;  // Restablecer el estado a Play
        });
        // Devuelve true a la pantalla anterior
        Navigator.pop(context, true);
      }
    } catch (e) {
      print('${t.errorMedCompleted} $e');
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(t.errorRegisterProgress)),
        );
      }
    }
  }
}