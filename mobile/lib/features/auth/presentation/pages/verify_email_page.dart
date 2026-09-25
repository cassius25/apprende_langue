import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:langapp/core/theme/app_colors.dart';

import '../providers/auth_controller.dart';
import '../widgets/auth_text_field.dart';

/// Vérification de l'email via deep link :
/// `langapp://verify-email?token=xxx` → route `/auth/verify-email?token=xxx`
class VerifyEmailPage extends ConsumerStatefulWidget {
  const VerifyEmailPage({super.key, required this.token});
  final String token;

  @override
  ConsumerState<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends ConsumerState<VerifyEmailPage> {
  final _manualCtrl = TextEditingController();
  bool _loading = false;
  bool? _success;
  String? _error;

  @override
  void initState() {
    super.initState();
    if (widget.token.isNotEmpty) {
      WidgetsBinding.instance.addPostFrameCallback(
        (_) => _verify(widget.token),
      );
    }
  }

  @override
  void dispose() {
    _manualCtrl.dispose();
    super.dispose();
  }

  Future<void> _verify(String token) async {
    setState(() {
      _loading = true;
      _success = null;
      _error = null;
    });
    final ok = await ref
        .read(authControllerProvider.notifier)
        .verifyEmail(token);
    if (!mounted) return;
    setState(() {
      _loading = false;
      _success = ok;
      _error = ok ? null : ref.read(authControllerProvider).errorMessage;
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Center(
            child: _loading
                ? const CircularProgressIndicator()
                : _success == true
                ? _buildSuccess(theme)
                : _buildForm(theme),
          ),
        ),
      ),
    );
  }

  Widget _buildSuccess(ThemeData theme) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(Icons.verified_rounded, size: 72, color: AppColors.success),
        const SizedBox(height: 16),
        Text('Email vérifié', style: theme.textTheme.headlineSmall),
        const SizedBox(height: 8),
        Text(
          'Votre adresse email a bien été confirmée.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  Widget _buildForm(ThemeData theme) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        const Icon(
          Icons.mark_email_unread_outlined,
          size: 72,
          color: AppColors.primary,
        ),
        const SizedBox(height: 16),
        Text(
          'Vérifier votre email',
          style: theme.textTheme.headlineSmall,
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Text(
          'Collez le code reçu par email pour confirmer votre adresse.',
          style: theme.textTheme.bodyMedium?.copyWith(
            color: AppColors.textSecondary,
          ),
          textAlign: TextAlign.center,
        ),
        if (_error != null) ...[
          const SizedBox(height: 16),
          Text(
            _error!,
            style: theme.textTheme.bodySmall?.copyWith(color: AppColors.error),
            textAlign: TextAlign.center,
          ),
        ],
        const SizedBox(height: 24),
        AuthTextField(
          controller: _manualCtrl,
          label: 'Code de vérification',
          prefixIcon: Icons.vpn_key_outlined,
          enabled: !_loading,
        ),
        const SizedBox(height: 16),
        FilledButton(
          onPressed: _loading ? null : () => _verify(_manualCtrl.text.trim()),
          child: const Text('Vérifier'),
        ),
      ],
    );
  }
}
