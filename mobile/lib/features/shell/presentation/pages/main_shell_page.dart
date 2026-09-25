import 'package:collection/collection.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:langapp/features/review/presentation/providers/review_providers.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../home/presentation/pages/home_page.dart';

/// Shell minimal : bottom navigation entre les 5 sections principales.
/// Sera enrichi en Partie 14 (Apprendre, Réviser, Stats, Profil réels).
class MainShellPage extends ConsumerStatefulWidget {
  const MainShellPage({
    super.key,
    required this.child,
    required this.currentIndex,
  });
  final Widget child;
  final int currentIndex;

  @override
  ConsumerState<MainShellPage> createState() => _MainShellPageState();
}

class _MainShellPageState extends ConsumerState<MainShellPage> {
  static const _items = <_NavItem>[
    // Onglet Accueil
    _NavItem(
      icon: Icons.home_outlined,
      activeIcon: Icons.home_rounded,
      label: 'Accueil',
      path: '/home',
    ),

    // Onglet Apprendre
    _NavItem(
      icon: Icons.school_outlined,
      activeIcon: Icons.school_rounded,
      label: 'Apprendre',
      path: '/learn/vocabulary',
    ),

    // Onglet Reviser
    _NavItem(
      icon: Icons.refresh_outlined,
      activeIcon: Icons.refresh_rounded,
      label: 'Réviser',
      path: '/review',
    ),

    // Onglet Stat
    _NavItem(
      icon: Icons.insights_outlined,
      activeIcon: Icons.insights_rounded,
      label: 'Stats',
      path: '/statistics',
    ),

    // Onglet Profil
    _NavItem(
      icon: Icons.person_outline_rounded,
      activeIcon: Icons.person_rounded,
      label: 'Profil',
      path: '/profile',
    ),
  ];

  void _onTap(int index) {
    if (index == widget.currentIndex) return;
    context.go(_items[index].path);
  }

  @override
  Widget build(BuildContext context) {
    // Dans le build :
    final dueAsync = ref.watch(dueReviewCountProvider);

    return Scaffold(
      body: widget.child,
      bottomNavigationBar: NavigationBar(
        selectedIndex: widget.currentIndex,
        onDestinationSelected: _onTap,
        backgroundColor: AppColors.surface,
        indicatorColor: AppColors.primary.withValues(alpha: 0.12),
        labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
        destinations: _items
            .mapIndexed(
              (index, it) => it.path == '/review'
                  ? NavigationDestination(
                      icon: Badge(
                        isLabelVisible: (dueAsync.valueOrNull ?? 0) > 0,
                        label: Text('${dueAsync.valueOrNull}'),
                        child: const Icon(Icons.refresh_outlined),
                      ),
                      selectedIcon: Badge(
                        isLabelVisible: (dueAsync.valueOrNull ?? 0) > 0,
                        label: Text('${dueAsync.valueOrNull}'),
                        child: const Icon(
                          Icons.refresh_rounded,
                          color: AppColors.primary,
                        ),
                      ),
                      label: 'Réviser',
                    )
                  : NavigationDestination(
                      icon: Icon(it.icon),
                      selectedIcon: Icon(
                        it.activeIcon,
                        color: AppColors.primary,
                      ),
                      label: it.label,
                    ),
            )
            .toList(),
      ),
    );
  }
}

class _NavItem {
  const _NavItem({
    required this.icon,
    required this.activeIcon,
    required this.label,
    required this.path,
  });
  final IconData icon;
  final IconData activeIcon;
  final String label;
  final String path;
}

/// Placeholders pour les sections pas encore implémentées (seront livrées en P14/P17/P18).
class PlaceholderPage extends StatelessWidget {
  const PlaceholderPage({super.key, required this.title});
  final String title;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text(title)),
      body: Center(
        child: Text(
          '« $title » arrive bientôt.',
          style: Theme.of(context).textTheme.bodyMedium,
        ),
      ),
    );
  }
}

/// Raccourci pour le router : renvoie HomePage (ou n'importe quelle page) dans le shell.
class HomeShellPage extends StatelessWidget {
  const HomeShellPage({super.key});
  @override
  Widget build(BuildContext context) =>
      const MainShellPage(currentIndex: 0, child: HomePage());
}
