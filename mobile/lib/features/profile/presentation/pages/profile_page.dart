import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/providers/auth_controller.dart';
import '../../../statistics/presentation/providers/statistics_providers.dart';

class ProfilePage extends ConsumerWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final user = ref.watch(currentUserProvider);
    final statsAsync = ref.watch(overviewStatsProvider);
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            await ref.read(authControllerProvider.notifier).refreshProfile();
            ref.invalidate(overviewStatsProvider);
          },
          child: ListView(
            padding: const EdgeInsets.all(16),
            children: [
              // ─── Header ────────────────────────────────
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(20),
                  child: Row(
                    children: [
                      Container(
                        width: 64,
                        height: 64,
                        alignment: Alignment.center,
                        decoration: BoxDecoration(
                          color: AppColors.primary.withValues(alpha: 0.12),
                          shape: BoxShape.circle,
                        ),
                        child: Text(
                          (user?.firstName.isNotEmpty == true
                                  ? user!.firstName[0]
                                  : '?')
                              .toUpperCase(),
                          style: theme.textTheme.headlineSmall?.copyWith(
                            color: AppColors.primary,
                            fontWeight: FontWeight.w700,
                          ),
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              user?.displayName ?? 'Utilisateur',
                              style: theme.textTheme.titleLarge,
                            ),
                            Text(
                              user?.email ?? '—',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: AppColors.textSecondary,
                              ),
                            ),
                            if (user?.emailVerified == false)
                              Padding(
                                padding: const EdgeInsets.only(top: 4),
                                child: Text(
                                  'Email non vérifié',
                                  style: theme.textTheme.labelSmall?.copyWith(
                                    color: AppColors.warning,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 12),

              // ─── Stats mini ────────────────────────────
              statsAsync.maybeWhen(
                data: (o) => Row(
                  children: [
                    Expanded(
                      child: _MiniKpi(
                        label: 'Niveau',
                        value: '${o.userLevel}',
                        icon: Icons.military_tech_outlined,
                        color: AppColors.primary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _MiniKpi(
                        label: 'XP',
                        value: '${o.xpTotal}',
                        icon: Icons.bolt_rounded,
                        color: AppColors.secondary,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      child: _MiniKpi(
                        label: 'Série',
                        value: '${o.streakCurrent}',
                        icon: Icons.local_fire_department_outlined,
                        color: AppColors.streakFire,
                      ),
                    ),
                  ],
                ),
                orElse: () => const SizedBox(height: 80),
              ),
              const SizedBox(height: 16),

              // ─── Menu ──────────────────────────────────
              _MenuTile(
                icon: Icons.edit_outlined,
                label: 'Modifier le profil',
                onTap: () => context.push('/profile/edit'),
              ),
              _MenuTile(
                icon: Icons.local_fire_department_outlined,
                label: 'Série de jours',
                onTap: () => context.push('/profile/streak'),
              ),
              _MenuTile(
                icon: Icons.emoji_events_outlined,
                label: 'Badges',
                onTap: () => context.push('/profile/badges'),
              ),
              _MenuTile(
                icon: Icons.lock_outline_rounded,
                label: 'Changer le mot de passe',
                onTap: () => context.push('/profile/change-password'),
              ),
              _MenuTile(
                icon: Icons.tune_rounded,
                label: 'Objectif quotidien',
                onTap: () => context.push('/goals'),
              ),
              const SizedBox(height: 12),
              _MenuTile(
                icon: Icons.logout_rounded,
                label: 'Se déconnecter',
                color: AppColors.error,
                onTap: () async {
                  final ok = await showDialog<bool>(
                    context: context,
                    builder: (_) => AlertDialog(
                      title: const Text('Se déconnecter ?'),
                      content: const Text(
                        'Vos données locales restent enregistrées.',
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.pop(context, false),
                          child: const Text('Annuler'),
                        ),
                        FilledButton(
                          onPressed: () => Navigator.pop(context, true),
                          child: const Text('Se déconnecter'),
                        ),
                      ],
                    ),
                  );
                  if (ok == true) {
                    await ref.read(authControllerProvider.notifier).logout();
                  }
                },
              ),
              _MenuTile(
                icon: Icons.delete_outline_rounded,
                label: 'Supprimer mon compte',
                color: AppColors.error,
                onTap: () => context.push('/profile/delete'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _MiniKpi extends StatelessWidget {
  const _MiniKpi({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
  });
  final String label;
  final String value;
  final IconData icon;
  final Color color;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
        child: Column(
          children: [
            Icon(icon, color: color),
            const SizedBox(height: 4),
            Text(
              value,
              style: theme.textTheme.titleMedium?.copyWith(
                color: color,
                fontWeight: FontWeight.w700,
              ),
            ),
            Text(label, style: theme.textTheme.labelSmall),
          ],
        ),
      ),
    );
  }
}

class _MenuTile extends StatelessWidget {
  const _MenuTile({
    required this.icon,
    required this.label,
    required this.onTap,
    this.color,
  });
  final IconData icon;
  final String label;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: ListTile(
        leading: Icon(icon, color: color ?? AppColors.textPrimary),
        title: Text(label, style: TextStyle(color: color)),
        trailing: const Icon(
          Icons.chevron_right_rounded,
          color: AppColors.textMuted,
        ),
        onTap: onTap,
      ),
    );
  }
}
