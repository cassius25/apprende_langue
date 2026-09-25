import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Tuile de sélection (QCM / Fill-in / Listening) avec état visuel.
class ExerciseOptionTile extends StatelessWidget {
  const ExerciseOptionTile({
    super.key,
    required this.label,
    required this.selected,
    this.disabled = false,
    this.correct,
    this.wrong,
    this.onTap,
  });

  final String label;
  final bool selected;
  final bool disabled;
  final bool? correct;
  final bool? wrong;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    Color border = AppColors.border;
    Color bg = AppColors.surface;
    Color? textColor;

    if (selected && correct == null && wrong == null) {
      border = AppColors.primary;
      bg = AppColors.primary.withValues(alpha: 0.06);
    }
    if (correct == true) {
      border = AppColors.success;
      bg = AppColors.success.withValues(alpha: 0.08);
      textColor = AppColors.success;
    }
    if (wrong == true) {
      border = AppColors.error;
      bg = AppColors.error.withValues(alpha: 0.08);
      textColor = AppColors.error;
    }

    return AnimatedContainer(
      duration: const Duration(milliseconds: 180),
      margin: const EdgeInsets.only(bottom: 10),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: border, width: selected ? 2 : 1),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(14),
        onTap: disabled ? null : onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
          child: Row(
            children: [
              Expanded(
                child: Text(
                  label,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: textColor,
                    fontWeight: selected ? FontWeight.w600 : FontWeight.w400,
                  ),
                ),
              ),
              if (correct == true)
                const Icon(Icons.check_circle_rounded, color: AppColors.success)
              else if (wrong == true)
                const Icon(Icons.cancel_rounded, color: AppColors.error)
              else if (selected)
                const Icon(
                  Icons.radio_button_checked_rounded,
                  color: AppColors.primary,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
