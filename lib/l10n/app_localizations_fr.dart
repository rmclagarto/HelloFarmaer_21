// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get languageAndTranslations => 'Langues et traductions';

  @override
  String get currentLanguage => 'Langue actuelle';

  @override
  String get languageDescription =>
      'Sélectionnez la langue préférée pour l\'interface et les traductions.';

  @override
  String get portuguese => 'Portugais';

  @override
  String get english => 'Anglais';

  @override
  String get spanish => 'Espagnol';

  @override
  String get french => 'Français';

  @override
  String get access => 'Accès';

  @override
  String get managePermissions => 'Gérer les autorisations';

  @override
  String get open => 'Ouvrir';

  @override
  String get openAccessManagement => 'Ouvrir la gestion des accès';

  @override
  String get appearance => 'Apparence';

  @override
  String get darkTheme => 'Thème sombre';

  @override
  String get appearanceDescription =>
      'Passez entre le mode clair et sombre pour une meilleure expérience visuelle.';

  @override
  String get notifications => 'Notifications';

  @override
  String get enableNotifications => 'Activer les notifications';

  @override
  String get notificationsDescription =>
      'Les paramètres détaillés des notifications apparaîtront ici.';

  @override
  String get myActivity => 'Mon activité';

  @override
  String get activitySummary => 'Résumé de l\'activité';

  @override
  String get last7Days => '7 derniers jours';

  @override
  String get viewActivity => 'Voir l\'activité';

  @override
  String get purchaseHistory => 'Historique des achats';

  @override
  String get viewFullHistory => 'Voir l\'historique complet';

  @override
  String get viewPurchaseHistory => 'Voir l\'historique des achats';

  @override
  String get commentHistory => 'Historique des commentaires';

  @override
  String get commentsMade => 'Commentaires faits';

  @override
  String get viewComments => 'Voir les commentaires';

  @override
  String get timeManagement => 'Gestion du temps';

  @override
  String get totalTimeToday => 'Temps total aujourd\'hui';

  @override
  String get enableLimit => 'Activer la limite';

  @override
  String get setLimit => 'Définir la limite (minutes)';

  @override
  String get limitReached => 'Limite atteinte';

  @override
  String limitMessage(Object time) {
    return 'Vous avez utilisé l\'application pendant $time aujourd\'hui !';
  }

  @override
  String get ok => 'OK';

  @override
  String get myAccountTitle => 'Mon compte';

  @override
  String get saveChanges => 'Enregistrer les modifications';

  @override
  String get changePassword => 'Changer le mot de passe';

  @override
  String get deleteAccount => 'Supprimer le compte';

  @override
  String get name => 'Nom';

  @override
  String get email => 'Email';

  @override
  String get gpsPermission => 'Localisation (GPS)';

  @override
  String get gpsPermissionDescription =>
      'Autoriser l\'accès à votre localisation';

  @override
  String get galleryPermission => 'Galerie';

  @override
  String get galleryPermissionDescription => 'Autoriser l\'accès à vos photos';

  @override
  String get cameraPermission => 'Caméra';

  @override
  String get cameraPermissionDescription => 'Autoriser l\'accès à la caméra';

  @override
  String get microphonePermission => 'Microphone';

  @override
  String get microphonePermissionDescription =>
      'Autoriser l\'accès au microphone';

  @override
  String get contactsPermission => 'Contacts';

  @override
  String get contactsPermissionDescription =>
      'Autoriser l\'accès à vos contacts';

  @override
  String get reportErrors => 'Signaler des erreurs';

  @override
  String get describeProblem => 'Décrivez le problème ici...';

  @override
  String get cancel => 'Annuler';

  @override
  String get send => 'Envoyer';

  @override
  String get thankYouReport => 'Merci d\'avoir signalé l\'erreur !';
}
