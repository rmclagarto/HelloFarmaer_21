// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String get settingsTitle => 'Configuración';

  @override
  String get languageAndTranslations => 'Idiomas y Traducciones';

  @override
  String get currentLanguage => 'Idioma Actual';

  @override
  String get languageDescription =>
      'Seleccione el idioma preferido para la interfaz y las traducciones.';

  @override
  String get portuguese => 'Portugués';

  @override
  String get english => 'Inglés';

  @override
  String get spanish => 'Español';

  @override
  String get french => 'Francés';

  @override
  String get access => 'Accesos';

  @override
  String get managePermissions => 'Gestionar permisos';

  @override
  String get open => 'Abrir';

  @override
  String get openAccessManagement => 'Abrir gestión de accesos';

  @override
  String get appearance => 'Apariencia';

  @override
  String get darkTheme => 'Tema oscuro';

  @override
  String get appearanceDescription =>
      'Cambie entre modo claro y oscuro para una mejor experiencia visual.';

  @override
  String get notifications => 'Notificaciones';

  @override
  String get enableNotifications => 'Activar notificaciones';

  @override
  String get notificationsDescription =>
      'Aquí vendrán las configuraciones detalladas de notificaciones.';

  @override
  String get myActivity => 'Mi Actividad';

  @override
  String get activitySummary => 'Resumen de actividad';

  @override
  String get last7Days => 'Últimos 7 días';

  @override
  String get viewActivity => 'Ver actividad';

  @override
  String get purchaseHistory => 'Historial de Compras';

  @override
  String get viewFullHistory => 'Ver historial completo';

  @override
  String get viewPurchaseHistory => 'Ver historial de compras';

  @override
  String get commentHistory => 'Historial de Comentarios';

  @override
  String get commentsMade => 'Comentarios realizados';

  @override
  String get viewComments => 'Ver comentarios';

  @override
  String get timeManagement => 'Gestión del Tiempo';

  @override
  String get totalTimeToday => 'Tiempo total hoy';

  @override
  String get enableLimit => 'Activar límite';

  @override
  String get setLimit => 'Definir límite (minutos)';

  @override
  String get limitReached => 'Límite Alcanzado';

  @override
  String limitMessage(Object time) {
    return '¡Has usado la app por $time hoy!';
  }

  @override
  String get ok => 'OK';

  @override
  String get myAccountTitle => 'Mi Cuenta';

  @override
  String get saveChanges => 'Guardar Cambios';

  @override
  String get changePassword => 'Cambiar Contraseña';

  @override
  String get deleteAccount => 'Eliminar Cuenta';

  @override
  String get name => 'Nombre';

  @override
  String get email => 'Correo electrónico';

  @override
  String get gpsPermission => 'Ubicación (GPS)';

  @override
  String get gpsPermissionDescription => 'Permitir acceso a tu ubicación';

  @override
  String get galleryPermission => 'Galería';

  @override
  String get galleryPermissionDescription => 'Permitir acceso a tus fotos';

  @override
  String get cameraPermission => 'Cámara';

  @override
  String get cameraPermissionDescription => 'Permitir acceso a la cámara';

  @override
  String get microphonePermission => 'Micrófono';

  @override
  String get microphonePermissionDescription => 'Permitir acceso al micrófono';

  @override
  String get contactsPermission => 'Contactos';

  @override
  String get contactsPermissionDescription => 'Permitir acceso a tus contactos';

  @override
  String get reportErrors => 'Reportar Errores';

  @override
  String get describeProblem => 'Describe el problema aquí...';

  @override
  String get cancel => 'Cancelar';

  @override
  String get send => 'Enviar';

  @override
  String get thankYouReport => '¡Gracias por reportar el error!';
}
