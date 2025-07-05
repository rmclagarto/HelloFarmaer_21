// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Portuguese (`pt`).
class AppLocalizationsPt extends AppLocalizations {
  AppLocalizationsPt([String locale = 'pt']) : super(locale);

  @override
  String get settingsTitle => 'Definições';

  @override
  String get languageAndTranslations => 'Idiomas e Traduções';

  @override
  String get currentLanguage => 'Idioma Atual';

  @override
  String get languageDescription =>
      'Selecione o idioma preferido para a interface e traduções.';

  @override
  String get portuguese => 'Português';

  @override
  String get english => 'Inglês';

  @override
  String get spanish => 'Espanhol';

  @override
  String get access => 'Acessos';

  @override
  String get managePermissions => 'Gerir permissões';

  @override
  String get open => 'Abrir';

  @override
  String get openAccessManagement => 'Abrir gestão de acessos';

  @override
  String get appearance => 'Aparência';

  @override
  String get darkTheme => 'Tema escuro';

  @override
  String get appearanceDescription =>
      'Altere entre o modo claro e escuro para uma melhor experiência visual.';

  @override
  String get notifications => 'Notificações';

  @override
  String get enableNotifications => 'Ativar notificações';

  @override
  String get notificationsDescription =>
      'Configurações detalhadas de notificações virão aqui.';

  @override
  String get myActivity => 'A Minha Atividade';

  @override
  String get activitySummary => 'Resumo da atividade';

  @override
  String get last7Days => 'Últimos 7 dias';

  @override
  String get viewActivity => 'Ver atividade';

  @override
  String get purchaseHistory => 'Histórico de Compras';

  @override
  String get viewFullHistory => 'Ver histórico completo';

  @override
  String get viewPurchaseHistory => 'Ver histórico de compras';

  @override
  String get commentHistory => 'Histórico de Comentários';

  @override
  String get commentsMade => 'Comentários realizados';

  @override
  String get viewComments => 'Ver comentários';

  @override
  String get timeManagement => 'Gestão do Tempo';

  @override
  String get totalTimeToday => 'Tempo total hoje';

  @override
  String get enableLimit => 'Ativar limite';

  @override
  String get setLimit => 'Definir limite (minutos)';

  @override
  String get limitReached => 'Limite Atingido';

  @override
  String limitMessage(Object time) {
    return 'Você usou a app por $time hoje!';
  }

  @override
  String get ok => 'OK';

  @override
  String get myAccountTitle => 'Minha Conta';

  @override
  String get saveChanges => 'Salvar Alterações';

  @override
  String get changePassword => 'Alterar Senha';

  @override
  String get deleteAccount => 'Excluir Conta';

  @override
  String get name => 'Nome';

  @override
  String get email => 'Email';

  @override
  String get gpsPermission => 'Localização (GPS)';

  @override
  String get gpsPermissionDescription => 'Permitir acesso à sua localização';

  @override
  String get galleryPermission => 'Galeria';

  @override
  String get galleryPermissionDescription => 'Permitir acesso às suas fotos';

  @override
  String get cameraPermission => 'Câmera';

  @override
  String get cameraPermissionDescription => 'Permitir acesso à câmera';

  @override
  String get contactsPermission => 'Contatos';

  @override
  String get contactsPermissionDescription =>
      'Permitir acesso aos seus contatos';
}
