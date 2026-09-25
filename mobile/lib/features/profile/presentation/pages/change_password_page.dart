import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/utils/validators.dart';
import '../../../auth/presentation/widgets/auth_text_field.dart';
import '../providers/profile_providers.dart';

class ChangePasswordPage extends ConsumerStatefulWidget {
  const ChangePasswordPage({super.key});

  @override
  ConsumerState<ChangePasswordPage> createState() => _ChangePasswordPageState();
}

class _ChangePasswordPageState extends ConsumerState<ChangePasswordPage> {
  final _formKey = GlobalKey<FormState>();
  final _currentCtrl = TextEditingController();
  final _newCtrl = TextEditingController();
  final _confirmCtrl = TextEditingController();
  bool _saving = false;

  @override
  void dispose() {
    _currentCtrl.dispose();
    _newCtrl.dispose();
    _confirmCtrl.dispose();
    super.dispose();
  }

  Future<void> _save() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    setState(() => _saving = true);

    final result = await ref
        .read(changePasswordUseCaseProvider)
        .call(currentPassword: _currentCtrl.text, newPassword: _newCtrl.text);

    if (!mounted) return;
    setState(() => _saving = false);

    result.fold(
      (f) => ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(f.message))),
      (_) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Mot de passe mis à jour.')),
        );
        context.pop();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Changer le mot de passe')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              children: [
                AuthTextField(
                  controller: _currentCtrl,
                  label: 'Mot de passe actuel',
                  obscure: true,
                  prefixIcon: Icons.lock_outline_rounded,
                  validator: (v) =>
                      Validators.required(v, 'Mot de passe actuel'),
                  enabled: !_saving,
                ),
                const SizedBox(height: 16),
                AuthTextField(
                  controller: _newCtrl,
                  label: 'Nouveau mot de passe',
                  obscure: true,
                  prefixIcon: Icons.lock_outline_rounded,
                  validator: Validators.password,
                  enabled: !_saving,
                ),
                const SizedBox(height: 16),
                AuthTextField(
                  controller: _confirmCtrl,
                  label: 'Confirmer le mot de passe',
                  obscure: true,
                  prefixIcon: Icons.lock_outline_rounded,
                  validator: (v) =>
                      Validators.passwordConfirm(v, _newCtrl.text),
                  enabled: !_saving,
                ),
                const SizedBox(height: 24),
                FilledButton(
                  onPressed: _saving ? null : _save,
                  child: _saving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Modifier le mot de passe'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
