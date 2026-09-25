import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/exercise.dart';

/// WORD_ORDER — l'utilisateur remet les mots dans l'ordre.
/// Payload : `{ "words": ["I","am","a","student"] }`.
class WordOrderWidget extends StatefulWidget {
  const WordOrderWidget({
    super.key,
    required this.exercise,
    required this.onChanged,
    this.disabled = false,
  });

  final Exercise exercise;
  final ValueChanged<Map<String, dynamic>?> onChanged;
  final bool disabled;

  @override
  State<WordOrderWidget> createState() => _WordOrderWidgetState();
}

class _WordOrderWidgetState extends State<WordOrderWidget> {
  /// Mots disponibles (non utilisés) → index stable
  late List<String> _available;

  /// Mots placés dans la phrase (référence index dans `_available`)
  final List<int> _ordered = [];

  @override
  void initState() {
    super.initState();
    _available = List.of(widget.exercise.scrambledWords);
  }

  @override
  void didUpdateWidget(covariant WordOrderWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.exercise.id != widget.exercise.id) {
      setState(() {
        _available = List.of(widget.exercise.scrambledWords);
        _ordered.clear();
      });
    }
  }

  void _emit() {
    if (_ordered.isEmpty) {
      widget.onChanged(null);
      return;
    }
    widget.onChanged({
      'words': _ordered.map((i) => _available[i]).toList(growable: false),
    });
  }

  void _pick(int index) {
    if (widget.disabled || _ordered.contains(index)) return;
    setState(() => _ordered.add(index));
    _emit();
  }

  void _unpick(int position) {
    if (widget.disabled) return;
    setState(() => _ordered.removeAt(position));
    _emit();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        // Zone de composition
        Container(
          constraints: const BoxConstraints(minHeight: 80),
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.surfaceAlt,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: AppColors.border),
          ),
          child: _ordered.isEmpty
              ? Center(
                  child: Text(
                    'Touchez les mots ci-dessous pour composer la phrase.',
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: AppColors.textMuted,
                    ),
                  ),
                )
              : Wrap(
                  spacing: 8,
                  runSpacing: 8,
                  children: [
                    for (var i = 0; i < _ordered.length; i++)
                      _Chip(
                        label: _available[_ordered[i]],
                        onTap: () => _unpick(i),
                        filled: true,
                      ),
                  ],
                ),
        ),
        const SizedBox(height: 16),
        // Mots disponibles
        Wrap(
          spacing: 8,
          runSpacing: 8,
          children: [
            for (var i = 0; i < _available.length; i++)
              _Chip(
                label: _available[i],
                onTap: _ordered.contains(i) ? null : () => _pick(i),
                filled: false,
              ),
          ],
        ),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({required this.label, required this.onTap, required this.filled});
  final String label;
  final VoidCallback? onTap;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final bg = filled
        ? AppColors.primary.withValues(alpha: 0.1)
        : AppColors.surface;
    final border = filled ? AppColors.primary : AppColors.border;

    return InkWell(
      borderRadius: BorderRadius.circular(10),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 150),
        padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        decoration: BoxDecoration(
          color: bg,
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: border),
        ),
        child: Text(
          label,
          style: theme.textTheme.bodyMedium?.copyWith(
            color: filled ? AppColors.primary : AppColors.textPrimary,
            fontWeight: filled ? FontWeight.w600 : FontWeight.w400,
          ),
        ),
      ),
    );
  }
}
