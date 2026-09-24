// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get appName => 'LangApp';

  @override
  String get appTagline => 'Apprendre les langues, un jour à la fois';

  @override
  String get commonOk => 'OK';

  @override
  String get commonCancel => 'Annuler';

  @override
  String get commonConfirm => 'Confirmer';

  @override
  String get commonSave => 'Enregistrer';

  @override
  String get commonDelete => 'Supprimer';

  @override
  String get commonRetry => 'Réessayer';

  @override
  String get commonClose => 'Fermer';

  @override
  String get commonContinue => 'Continuer';

  @override
  String get commonBack => 'Retour';

  @override
  String get commonNext => 'Suivant';

  @override
  String get commonSkip => 'Passer';

  @override
  String get commonFinish => 'Terminer';

  @override
  String get commonLoading => 'Chargement…';

  @override
  String get commonError => 'Une erreur est survenue';

  @override
  String get commonNoInternet => 'Pas de connexion internet';

  @override
  String get splashLoading => 'Chargement…';

  @override
  String get navHome => 'Accueil';

  @override
  String get navLearn => 'Apprendre';

  @override
  String get navReview => 'Réviser';

  @override
  String get navStatistics => 'Statistiques';

  @override
  String get navProfile => 'Profil';

  @override
  String get homeGreeting => 'Bonjour !';

  @override
  String get homeContinueLearning => 'Continuer l’apprentissage';

  @override
  String get homeReviewsToday => 'À réviser aujourd’hui';

  @override
  String get homeDailyGoal => 'Objectif du jour';

  @override
  String get homeProgress => 'Progression';

  @override
  String get homeStreak => 'Série';

  @override
  String homeStreakDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count jours',
      one: '1 jour',
    );
    return '$_temp0';
  }

  @override
  String get errorNetwork => 'Impossible de joindre le serveur. Réessayez.';

  @override
  String get errorUnknown => 'Une erreur inattendue est survenue.';

  @override
  String get errorUnauthorized => 'Veuillez vous reconnecter.';
}
