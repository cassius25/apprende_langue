import 'package:flutter/material.dart';

import '../../domain/entities/exercise.dart';
import 'exercise_option_tile.dart';

/// FILL_IN_THE_BLANK — accepte **soit** un choix parmi des options,
/// **soit** une saisie libre, selon ce que le backend a configuré.
class FillInBlankWidget extends StatefulWidget {
  const FillInBlankWidget({
    super.key,
    required this.exercise,
    required this.onChanged,
    this.disabled = false,
  });

  final Exercise exercise;
  final ValueChanged<Map<String, dynamic>?> onChanged;
  final bool disabled;

  @override
  State<FillInBlankWidget> createState() => _FillInBlankWidgetState();
}

class _FillInBlankWidgetState extends State<FillInBlankWidget> {
  String? _selectedId;
  final _ctrl = TextEditingController();

  bool get _hasOptions => widget.exercise.options.isNotEmpty;

  @override
  void initState() {
    super.initState();
    _ctrl.addListener(_onText);
  }

  @override
  void didUpdateWidget(covariant FillInBlankWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.exercise.id != widget.exercise.id) {
      setState(() => _selectedId = null);
      _ctrl.clear();
    }
  }

  void _onText() {
    if (_hasOptions) return;
    final txt = _ctrl.text.trim();
    widget.onChanged(txt.isEmpty ? null : {'text': txt});
  }

  @override
  void dispose() {
    _ctrl.removeListener(_onText);
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_hasOptions) {
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

    return TextField(
      controller: _ctrl,
      enabled: !widget.disabled,
      textInputAction: TextInputAction.done,
      decoration: const InputDecoration(hintText: 'Complétez la phrase…'),
    );
  }
}
