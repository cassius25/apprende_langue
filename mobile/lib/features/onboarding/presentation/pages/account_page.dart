import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:langapp/features/goals/domain/entities/daily_goal.dart';

import '../../../../core/router/route_names.dart';
import '../../../../core/utils/validators.dart';
import '../../../auth/domain/repositories/auth_repository.dart';
import '../../../auth/presentation/providers/auth_controller.dart';
import '../../../auth/presentation/widgets/auth_text_field.dart';
import '../../../goals/presentation/providers/goals_providers.dart';
import '../providers/onboarding_controller.dart';
import '../widgets/onboarding_scaffold.dart';

class AccountPage extends ConsumerStatefulWidget {
  const AccountPage({super.key});

  @override
  ConsumerState<AccountPage> createState() => _AccountPageState();
}

class _AccountPageState extends ConsumerState<AccountPage> {
  final _formKey = GlobalKey<FormState>();
  final _firstCtrl = TextEditingController();
  final _lastCtrl = TextEditingController();
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _obscure = true;
  bool _loading = false;

  @override
  void dispose() {
    _firstCtrl.dispose();
    _lastCtrl.dispose();
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;

    final data = ref.read(onboardingControllerProvider);
    setState(() => _loading = true);

    final ok = await ref
        .read(authControllerProvider.notifier)
        .register(
          RegisterParams(
            firstName: _firstCtrl.text.trim(),
            lastName: _lastCtrl.text.trim(),
            email: _emailCtrl.text.trim(),
            password: _passCtrl.text,
            nativeLanguageId: data.nativeLanguageId,
            learningLanguageId: data.learningLanguageId,
          ),
        );

    if (!ok) {
      if (!mounted) return;
      setState(() => _loading = false);
      final err = ref.read(authControllerProvider).errorMessage ?? 'Erreur';
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(err)));
      return;
    }

    // Post-registration: applique l'objectif et le temps quotidien
    try {
      await ref
          .read(upsertGoalUseCaseProvider)
          .call(
            type: goalTypeFromString(data.goalType.name),
            target: data.goalTarget,
          );
    } catch (_) {
      // best-effort, ne bloque pas l'onboarding
    }

    if (!mounted) return;
    setState(() => _loading = false);
    ref.read(onboardingControllerProvider.notifier).reset();
    context.goNamed(RouteNames.home);
  }

  @override
  Widget build(BuildContext context) {
    return OnboardingScaffold(
      step: 7,
      totalSteps: 7,
      title: 'Créer votre compte',
      subtitle: 'Dernière étape pour démarrer votre apprentissage.',
      onBack: () => context.pop(),
      nextLabel: 'Créer mon compte',
      nextLoading: _loading,
      onNext: _submit,
      child: Form(
        key: _formKey,
        child: ListView(
          children: [
            AuthTextField(
              controller: _firstCtrl,
              label: 'Prénom',
              prefixIcon: Icons.person_outline_rounded,
              validator: Validators.name,
              enabled: !_loading,
            ),
            const SizedBox(height: 12),
            AuthTextField(
              controller: _lastCtrl,
              label: 'Nom',
              prefixIcon: Icons.person_outline_rounded,
              validator: Validators.name,
              enabled: !_loading,
            ),
            const SizedBox(height: 12),
            AuthTextField(
              controller: _emailCtrl,
              label: 'Email',
              hint: 'vous@exemple.com',
              keyboardType: TextInputType.emailAddress,
              prefixIcon: Icons.mail_outline_rounded,
              validator: Validators.email,
              enabled: !_loading,
            ),
            const SizedBox(height: 12),
            AuthTextField(
              controller: _passCtrl,
              label: 'Mot de passe',
              obscure: _obscure,
              prefixIcon: Icons.lock_outline_rounded,
              suffix: IconButton(
                icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility),
                onPressed: () => setState(() => _obscure = !_obscure),
              ),
              validator: Validators.password,
              enabled: !_loading,
            ),
          ],
        ),
      ),
    );
  }
}
