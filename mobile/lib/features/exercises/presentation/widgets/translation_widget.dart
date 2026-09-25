import 'package:flutter/material.dart';

import '../../domain/entities/exercise.dart';

/// TRANSLATION — l'utilisateur saisit une traduction libre.
/// Payload renvoyé : `{ "text": "<string>" }`.
class TranslationWidget extends StatefulWidget {
  const TranslationWidget({
    super.key,
    required this.exercise,
    required this.onChanged,
    this.disabled = false,
  });

  final Exercise exercise;
  final ValueChanged<Map<String, dynamic>?> onChanged;
  final bool disabled;

  @override
  State<TranslationWidget> createState() => _TranslationWidgetState();
}

class _TranslationWidgetState extends State<TranslationWidget> {
  final _ctrl = TextEditingController();

  @override
  void initState() {
    super.initState();
    _ctrl.addListener(_onText);
  }

  @override
  void didUpdateWidget(covariant TranslationWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.exercise.id != widget.exercise.id) {
      _ctrl.clear();
    }
  }

  void _onText() {
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
    return TextField(
      controller: _ctrl,
      enabled: !widget.disabled,
      maxLines: 3,
      minLines: 2,
      textInputAction: TextInputAction.done,
      decoration: const InputDecoration(
        hintText: 'Saisissez votre traduction…',
      ),
    );
  }
}
