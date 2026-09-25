import 'package:flutter/material.dart';

import '../../domain/entities/exercise.dart';
import 'exercise_option_tile.dart';

/// MULTIPLE_CHOICE — l'utilisateur sélectionne une option.
/// Payload renvoyé : `{ "optionId": "<uuid>" }`.
class QcmWidget extends StatefulWidget {
  const QcmWidget({
    super.key,
    required this.exercise,
    required this.onChanged,
    this.disabled = false,
  });

  final Exercise exercise;
  final ValueChanged<Map<String, dynamic>?> onChanged;
  final bool disabled;

  @override
  State<QcmWidget> createState() => _QcmWidgetState();
}

class _QcmWidgetState extends State<QcmWidget> {
  String? _selectedId;

  @override
  void didUpdateWidget(covariant QcmWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.exercise.id != widget.exercise.id) {
      setState(() => _selectedId = null);
      widget.onChanged(null);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
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
