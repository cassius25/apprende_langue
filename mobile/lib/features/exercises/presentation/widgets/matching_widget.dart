import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../domain/entities/exercise.dart';

/// MATCHING — l'utilisateur associe chaque item de gauche à un item de droite.
/// Payload : `{ "pairs": [{ "left": "...", "right": "..." }, ...] }`.
class MatchingWidget extends StatefulWidget {
  const MatchingWidget({
    super.key,
    required this.exercise,
    required this.onChanged,
    this.disabled = false,
  });

  final Exercise exercise;
  final ValueChanged<Map<String, dynamic>?> onChanged;
  final bool disabled;

  @override
  State<MatchingWidget> createState() => _MatchingWidgetState();
}

class _MatchingWidgetState extends State<MatchingWidget> {
  /// leftItem -> rightItem sélectionné
  final Map<String, String> _matches = {};
  String? _pendingLeft;

  List<String> get _rights {
    final rights = widget.exercise.matchingPairs.map((p) => p.right).toList();
    // tri alphabétique pour un effet "mélangé" stable
    rights.sort();
    return rights;
  }

  @override
  void didUpdateWidget(covariant MatchingWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.exercise.id != widget.exercise.id) {
      setState(() {
        _matches.clear();
        _pendingLeft = null;
      });
    }
  }

  void _emit() {
    widget.onChanged({
      'pairs': _matches.entries
          .map((e) => {'left': e.key, 'right': e.value})
          .toList(growable: false),
    });
  }

  void _selectLeft(String left) {
    if (widget.disabled) return;
    setState(() => _pendingLeft = left);
  }

  void _selectRight(String right) {
    if (widget.disabled) return;
    final left = _pendingLeft;
    if (left == null) return;
    setState(() {
      _matches[left] = right;
      _pendingLeft = null;
    });
    _emit();
  }

  void _unpair(String left) {
    if (widget.disabled) return;
    setState(() => _matches.remove(left));
    if (_matches.isEmpty) {
      widget.onChanged(null);
    } else {
      _emit();
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final pairs = widget.exercise.matchingPairs;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Text(
          'Associez chaque élément :',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Colonne de gauche
            Expanded(
              child: Column(
                children: [
                  for (final p in pairs)
                    _MatchTile(
                      label: p.left,
                      selected: _pendingLeft == p.left,
                      matched: _matches.containsKey(p.left),
                      matchedWith: _matches[p.left],
                      onTap: () => _matches.containsKey(p.left)
                          ? _unpair(p.left)
                          : _selectLeft(p.left),
                    ),
                ],
              ),
            ),
            const SizedBox(width: 12),
            // Colonne de droite
            Expanded(
              child: Column(
                children: [
                  for (final r in _rights)
                    _MatchTile(
                      label: r,
                      selected: false,
                      matched: _matches.containsValue(r),
                      matchedWith: null,
                      onTap: () => _selectRight(r),
                    ),
                ],
              ),
            ),
          ],
        ),
        if (_pendingLeft != null) ...[
          const SizedBox(height: 12),
          Text(
            'Choisissez l’élément correspondant pour « $_pendingLeft ».',
            style: theme.textTheme.bodySmall?.copyWith(
              color: AppColors.primary,
            ),
          ),
        ],
      ],
    );
  }
}

class _MatchTile extends StatelessWidget {
  const _MatchTile({
    required this.label,
    required this.selected,
    required this.matched,
    required this.matchedWith,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final bool matched;
  final String? matchedWith;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    Color border = AppColors.border;
    Color bg = AppColors.surface;
    if (selected) {
      border = AppColors.primary;
      bg = AppColors.primary.withValues(alpha: 0.08);
    } else if (matched) {
      border = AppColors.accent;
      bg = AppColors.accent.withValues(alpha: 0.08);
    }

    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
          decoration: BoxDecoration(
            color: bg,
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: border),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(label, style: theme.textTheme.bodyMedium),
              if (matchedWith != null)
                Padding(
                  padding: const EdgeInsets.only(top: 2),
                  child: Text(
                    '→ $matchedWith',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: AppColors.accent,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
