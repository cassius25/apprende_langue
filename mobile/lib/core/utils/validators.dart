/// Validateurs de formulaires — retournent `null` si valide, sinon le message.
class Validators {
  const Validators._();

  static final RegExp _emailRegex = RegExp(
    r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
  );

  static String? email(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Email requis';
    if (!_emailRegex.hasMatch(v)) return 'Adresse email invalide';
    if (v.length > 255) return 'Adresse email trop longue';
    return null;
  }

  static String? password(String? value) {
    final v = value ?? '';
    if (v.isEmpty) return 'Mot de passe requis';
    if (v.length < 8) return 'Au moins 8 caractères';
    if (v.length > 128) return 'Trop long';
    if (!RegExp(r'[A-Z]').hasMatch(v)) return 'Au moins une majuscule';
    if (!RegExp(r'[a-z]').hasMatch(v)) return 'Au moins une minuscule';
    if (!RegExp(r'[0-9]').hasMatch(v)) return 'Au moins un chiffre';
    return null;
  }

  static String? passwordConfirm(String? value, String original) {
    if (value != original) return 'Les mots de passe ne correspondent pas';
    return null;
  }

  static String? required(String? value, [String field = 'Ce champ']) {
    if ((value ?? '').trim().isEmpty) return '$field est requis';
    return null;
  }

  static String? minLength(
    String? value,
    int min, [
    String field = 'Ce champ',
  ]) {
    if ((value ?? '').length < min)
      return '$field doit contenir au moins $min caractères';
    return null;
  }

  static String? maxLength(
    String? value,
    int max, [
    String field = 'Ce champ',
  ]) {
    if ((value ?? '').length > max)
      return '$field doit contenir au plus $max caractères';
    return null;
  }

  static String? name(String? value) {
    final v = value?.trim() ?? '';
    if (v.isEmpty) return 'Nom requis';
    if (v.length > 80) return 'Trop long';
    return null;
  }
}
