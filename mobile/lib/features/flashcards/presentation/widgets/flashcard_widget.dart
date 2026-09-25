import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:langapp/features/flashcards/domain/entities/flashcard.dart';

import '../../../../core/theme/app_colors.dart';

/// Carte avec animation de flip au tap.
/// - Recto : WORD (+ phonetic)
/// - Verso : traduction + exemple
class FlashcardWidget extends StatefulWidget {
  const FlashcardWidget({
    super.key,
    required this.card,
    required this.showBack,
    required this.onFlip,
  });

  final Flashcard card;
  final bool showBack;
  final VoidCallback onFlip;

  @override
  State<FlashcardWidget> createState() => _FlashcardWidgetState();
}

class _FlashcardWidgetState extends State<FlashcardWidget>
    with SingleTickerProviderStateMixin {
  late final AnimationController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 450),
      value: widget.showBack ? 1 : 0,
    );
  }

  @override
  void didUpdateWidget(covariant FlashcardWidget oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.showBack != oldWidget.showBack) {
      if (widget.showBack) {
        _ctrl.forward();
      } else {
        _ctrl.reverse();
      }
    }
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return GestureDetector(
      onTap: widget.onFlip,
      child: AnimatedBuilder(
        animation: _ctrl,
        builder: (context, _) {
          final angle = _ctrl.value * math.pi;
          final isBack = angle > math.pi / 2;

          return Transform(
            alignment: Alignment.center,
            transform: Matrix4.identity()
              ..setEntry(3, 2, 0.001)
              ..rotateY(angle),
            child: isBack
                ? Transform(
                    alignment: Alignment.center,
                    transform: Matrix4.identity()..rotateY(math.pi),
                    child: _buildBack(theme),
                  )
                : _buildFront(theme),
          );
        },
      ),
    );
  }

  Widget _buildFront(ThemeData theme) {
    return _card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            'APPUIEZ POUR RÉVÉLER',
            style: theme.textTheme.labelSmall?.copyWith(
              color: AppColors.textMuted,
              letterSpacing: 1.2,
            ),
          ),
          const SizedBox(height: 24),
          Text(
            widget.card.front.toUpperCase(),
            style: theme.textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.w700,
            ),
            textAlign: TextAlign.center,
          ),
          if (widget.card.phonetic != null) ...[
            const SizedBox(height: 8),
            Text(
              widget.card.phonetic!,
              style: theme.textTheme.titleMedium?.copyWith(
                color: AppColors.textMuted,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildBack(ThemeData theme) {
    return _card(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            widget.card.front.toUpperCase(),
            style: theme.textTheme.titleMedium?.copyWith(
              color: AppColors.textMuted,
            ),
            textAlign: TextAlign.center,
          ),
          const SizedBox(height: 16),
          Text(
            widget.card.translation,
            style: theme.textTheme.displaySmall?.copyWith(
              fontWeight: FontWeight.w700,
              color: AppColors.primary,
            ),
            textAlign: TextAlign.center,
          ),
          if (widget.card.phonetic != null) ...[
            const SizedBox(height: 8),
            Text(
              widget.card.phonetic!,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: AppColors.textMuted,
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
          if (widget.card.example != null) ...[
            const SizedBox(height: 24),
            const Divider(),
            const SizedBox(height: 12),
            Text(
              widget.card.example!,
              style: theme.textTheme.bodyLarge,
              textAlign: TextAlign.center,
            ),
            if (widget.card.exampleTranslation != null) ...[
              const SizedBox(height: 6),
              Text(
                widget.card.exampleTranslation!,
                style: theme.textTheme.bodySmall?.copyWith(
                  color: AppColors.textSecondary,
                  fontStyle: FontStyle.italic,
                ),
                textAlign: TextAlign.center,
              ),
            ],
          ],
        ],
      ),
    );
  }

  Widget _card({required Widget child}) {
    return Container(
      constraints: const BoxConstraints(minHeight: 320),
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: AppColors.border),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Center(child: child),
    );
  }
}
