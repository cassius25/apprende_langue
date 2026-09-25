import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/exercise.dart';
import 'exercise_option_tile.dart';

/// LISTENING — l'utilisateur écoute puis choisit la bonne réponse.
/// Accepte `{ optionId }` (QCM) ou `{ text }` (saisie libre).
class ListeningWidget extends StatefulWidget {
  const ListeningWidget({
    super.key,
    required this.exercise,
    required this.onChanged,
    this.disabled = false,
  });

  final Exercise exercise;
  final ValueChanged<Map<String, dynamic>?> onChanged;
  final bool disabled;

  @override
  State<ListeningWidget> createState() => _ListeningWidgetState();
}

class _ListeningWidgetState extends State<ListeningWidget> {
  final _player = AudioPlayer();
  String? _selectedId;
  bool _playing = false;
  String? _error;

  @override
  void initState() {
    super.initState();
    _player.playerStateStream.listen((s) {
      if (!mounted) return;
      setState(() => _playing = s.playing);
    });
  }

  @override
  void didUpdateWidget(covariant ListeningWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.exercise.id != widget.exercise.id) {
      _player.stop();
      setState(() {
        _selectedId = null;
        _error = null;
      });
    }
  }

  Future<void> _play() async {
    final url = widget.exercise.audioUrl;
    if (url == null || url.isEmpty) {
      setState(() => _error = 'Audio indisponible.');
      return;
    }
    try {
      await _player.setUrl(url);
      await _player.play();
    } catch (_) {
      setState(() => _error = 'Impossible de lire l’audio.');
    }
  }

  Future<void> _slowPlay() async {
    final url = widget.exercise.audioUrl;
    if (url == null) return;
    try {
      await _player.setSpeed(0.7);
      await _play();
    } catch (_) {}
  }

  @override
  void dispose() {
    _player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Zone d'écoute
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: AppColors.primary.withValues(alpha: 0.06),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: AppColors.primary.withValues(alpha: 0.2)),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Expanded(
                    child: FilledButton.icon(
                      onPressed: widget.disabled ? null : _play,
                      icon: Icon(
                        _playing
                            ? Icons.pause_rounded
                            : Icons.play_arrow_rounded,
                      ),
                      label: Text(_playing ? 'Lecture…' : 'Écouter'),
                    ),
                  ),
                  const SizedBox(width: 10),
                  OutlinedButton.icon(
                    onPressed: widget.disabled ? null : _slowPlay,
                    icon: const Icon(Icons.slow_motion_video_rounded),
                    label: const Text('Lent'),
                  ),
                ],
              ),
              if (_error != null) ...[
                const SizedBox(height: 8),
                Text(
                  _error!,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: AppColors.error,
                  ),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 16),
        // Options (QCM classique)
        if (widget.exercise.options.isNotEmpty)
          for (final o in widget.exercise.options)
            ExerciseOptionTile(
              label: o.label,
              selected: _selectedId == o.id,
              disabled: widget.disabled,
              onTap: () {
                setState(() => _selectedId = o.id);
                widget.onChanged({'optionId': o.id});
              },
            ),
      ],
    );
  }
}
