// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get settingsTitle => 'Settings';

  @override
  String get languageAndTranslations => 'Language and Translations';

  @override
  String get currentLanguage => 'Current Language';

  @override
  String get languageDescription =>
      'Select your preferred language for the interface and translations.';

  @override
  String get portuguese => 'Portuguese';

  @override
  String get english => 'English';

  @override
  String get spanish => 'Spanish';

  @override
  String get access => 'Access';

  @override
  String get managePermissions => 'Manage permissions';

  @override
  String get open => 'Open';

  @override
  String get openAccessManagement => 'Open access management';

  @override
  String get appearance => 'Appearance';

  @override
  String get darkTheme => 'Dark theme';

  @override
  String get appearanceDescription =>
      'Switch between light and dark mode for better visual experience.';

  @override
  String get notifications => 'Notifications';

  @override
  String get enableNotifications => 'Enable notifications';

  @override
  String get notificationsDescription =>
      'Detailed notification settings will appear here.';

  @override
  String get myActivity => 'My Activity';

  @override
  String get activitySummary => 'Activity summary';

  @override
  String get last7Days => 'Last 7 days';

  @override
  String get viewActivity => 'View activity';

  @override
  String get purchaseHistory => 'Purchase History';

  @override
  String get viewFullHistory => 'View full history';

  @override
  String get viewPurchaseHistory => 'View purchase history';

  @override
  String get commentHistory => 'Comment History';

  @override
  String get commentsMade => 'Comments made';

  @override
  String get viewComments => 'View comments';

  @override
  String get timeManagement => 'Time Management';

  @override
  String get totalTimeToday => 'Total time today';

  @override
  String get enableLimit => 'Enable limit';

  @override
  String get setLimit => 'Set limit (minutes)';

  @override
  String get limitReached => 'Limit Reached';

  @override
  String limitMessage(Object time) {
    return 'You\'ve used the app for $time today!';
  }

  @override
  String get ok => 'OK';
}
