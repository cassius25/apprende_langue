import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../auth/presentation/providers/auth_controller.dart';
import '../../../auth/presentation/widgets/auth_text_field.dart';
import '../providers/profile_providers.dart';

class DeleteAccountPage extends ConsumerStatefulWidget {
  const DeleteAccountPage({super.key});

  @override
  ConsumerState<DeleteAccountPage> createState() => _DeleteAccountPageState();
}

class _DeleteAccountPageState extends ConsumerState<DeleteAccountPage> {
  final _formKey = GlobalKey<FormState>();
  final _passwordCtrl = TextEditingController();
  bool _confirm = false;
  bool _saving = false;

  @override
  void dispose() {
    _passwordCtrl.dispose();
    super.dispose();
  }

  Future<void> _delete() async {
    if (!(_formKey.currentState?.validate() ?? false)) return;
    if (!_confirm) return;
    setState(() => _saving = true);

    final result = await ref
        .read(deleteAccountUseCaseProvider)
        .call(_passwordCtrl.text);

    if (!mounted) return;
    setState(() => _saving = false);

    result.fold(
      (f) => ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(f.message))),
      (_) async {
        await ref.read(authControllerProvider.notifier).handleSessionExpired();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(title: const Text('Supprimer le compte')),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const Icon(
                  Icons.warning_amber_rounded,
                  size: 64,
                  color: AppColors.error,
                ),
                const SizedBox(height: 16),
                Text(
                  'Cette action est irréversible.',
                  style: theme.textTheme.titleLarge,
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 8),
                Text(
                  'Vos données personnelles seront anonymisées. Votre progression sera perdue.',
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 24),
                AuthTextField(
                  controller: _passwordCtrl,
                  label: 'Confirmez avec votre mot de passe',
                  obscure: true,
                  prefixIcon: Icons.lock_outline_rounded,
                  validator: (v) =>
                      (v ?? '').isEmpty ? 'Mot de passe requis' : null,
                  enabled: !_saving,
                ),
                const SizedBox(height: 12),
                CheckboxListTile(
                  value: _confirm,
                  onChanged: _saving
                      ? null
                      : (v) => setState(() => _confirm = v ?? false),
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                  title: Text(
                    'Je comprends que cette action est définitive.',
                    style: theme.textTheme.bodySmall,
                  ),
                ),
                const SizedBox(height: 16),
                FilledButton(
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.error,
                  ),
                  onPressed: (_saving || !_confirm) ? null : _delete,
                  child: _saving
                      ? const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text('Supprimer définitivement'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
