import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/exercise.dart';

/// PRONUNCIATION — stub d'interface pour la prononciation.
///
/// Le backend n'impose pas de transcription (Speech-to-Text viendra plus tard).
/// On affiche :
///  - le mot cible,
///  - un bouton « Écouter » (modèle audio),
///  - un bouton « Enregistrer » (placeholder, pas d'upload pour l'instant),
///  - un bouton « Valider » qui envoie `{}` au serveur → 100 par défaut.
class PronunciationWidget extends StatefulWidget {
  const PronunciationWidget({
    super.key,
    required this.exercise,
    required this.onChanged,
    this.disabled = false,
  });

  final Exercise exercise;
  final ValueChanged<Map<String, dynamic>?> onChanged;
  final bool disabled;

  @override
  State<PronunciationWidget> createState() => _PronunciationWidgetState();
}

class _PronunciationWidgetState extends State<PronunciationWidget> {
  bool _recorded = false;

  @override
  void didUpdateWidget(covariant PronunciationWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.exercise.id != widget.exercise.id) {
      setState(() => _recorded = false);
      widget.onChanged(null);
    }
  }

  void _fakeRecord() {
    if (widget.disabled) return;
    setState(() => _recorded = true);
    widget.onChanged(const <String, dynamic>{});
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final target = widget.exercise.question;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Card(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                Text('Prononcez ce mot :', style: theme.textTheme.bodyMedium),
                const SizedBox(height: 12),
                Text(
                  target,
                  style: theme.textTheme.displaySmall?.copyWith(
                    fontWeight: FontWeight.w700,
                    color: AppColors.primary,
                  ),
                  textAlign: TextAlign.center,
                ),
                if (widget.exercise.audioUrl != null) ...[
                  const SizedBox(height: 12),
                  OutlinedButton.icon(
                    onPressed: widget.disabled ? null : () {},
                    icon: const Icon(Icons.headphones_rounded),
                    label: const Text('Écouter le modèle'),
                  ),
                ],
              ],
            ),
          ),
        ),
        const SizedBox(height: 16),
        FilledButton.icon(
          onPressed: widget.disabled ? null : _fakeRecord,
          icon: Icon(_recorded ? Icons.check_rounded : Icons.mic_rounded),
          label: Text(
            _recorded ? 'Enregistrement OK' : 'Enregistrer ma prononciation',
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'La reconnaissance vocale arrive bientôt. Votre réponse sera pour l’instant '
          'acceptée automatiquement.',
          style: theme.textTheme.bodySmall?.copyWith(
            color: AppColors.textMuted,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
}
