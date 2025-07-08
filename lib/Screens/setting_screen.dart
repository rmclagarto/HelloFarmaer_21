import 'package:projeto_cm/main.dart';
import 'package:flutter/material.dart';
import 'package:projeto_cm/Core/constants.dart';
import 'package:projeto_cm/l10n/app_localizations.dart';
import 'package:permission_handler/permission_handler.dart';



class SettingsScreen extends StatefulWidget {
  final bool isDarkTheme;
  final ValueChanged<bool> onThemeChanged;

  const SettingsScreen({
    super.key,
    required this.isDarkTheme,
    required this.onThemeChanged,
  });

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notificationsEnabled = true;
  // bool _timeManagementEnabled = false;
  String _selectedLanguage = 'pt';

  DateTime? _entradaApp;
  Duration _tempoTotal = Duration.zero;
  bool _limiteAtivo = false;
  int _limiteMinutos = 60;

  bool _gpsEnabled = false;
  bool _galleryEnabled = false;
  bool _cameraEnabled = false;
  // bool _microphoneEnabled = false;
  bool _contactsEnabled = false;

  Future<void> _checkPermissions() async {
    final gpsStatus = await Permission.location.status;
    final galleryStatus = await Permission.photos.status;
    final cameraStatus = await Permission.camera.status;
    // final microphoneStatus = await Permission.microphone.status;
    final contactStatus = await Permission.contacts.status;
  }

  @override
  void initState() {
    super.initState();
    _entradaApp = DateTime.now();
  }

  @override
  void dispose() {
    if (_entradaApp != null) {
      final tempoSessao = DateTime.now().difference(_entradaApp!);
      setState(() {
        _tempoTotal += tempoSessao;
      });
    }
    super.dispose();
  }

  String _formatarTempo(Duration duracao) {
    return '${duracao.inHours}h ${duracao.inMinutes.remainder(60)}min';
  }

  // void _changeLanguage(String? languageCode) {
  //   if (languageCode == null) return;

  //   setState(() {
  //     _selectedLanguage = languageCode;
  //   });
  // }

  Future<void> _requestPermission(
    Permission permission,
    Function(bool) setStateCallbeck,
  ) async {
    final status = await permission.request();
    setStateCallbeck(status.isGranted);

    if (!status.isGranted && status.isPermanentlyDenied) {
      await openAppSettings();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = themeNotifier.value == ThemeMode.dark;
    final l10n = AppLocalizations.of(context)!;

    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_limiteAtivo && _tempoTotal.inMinutes >= _limiteMinutos) {
        showDialog(
          context: context,
          barrierDismissible: false,
          builder:
              (ctx) => AlertDialog(
                title: Text(l10n.limitReached),
                content: Text(l10n.limitMessage(_formatarTempo(_tempoTotal))),
                actions: [
                  TextButton(
                    child: const Text("OK"),
                    onPressed: () => Navigator.pop(ctx),
                  ),
                ],
              ),
        );
      }
    });

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants.primaryColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          l10n.settingsTitle,
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.all(12),
        children: [
          ExpansionTile(
            leading: const Icon(Icons.language, color: Colors.blue),
            title: Text(l10n.languageAndTranslations),
            children: [
              ListTile(
                title: Text(l10n.currentLanguage),
                trailing: DropdownButton<String>(
                  value: _selectedLanguage,
                  items: [
                    DropdownMenuItem(value: 'pt', child: Text(l10n.portuguese)),
                    DropdownMenuItem(value: 'en', child: Text(l10n.english)),
                    DropdownMenuItem(value: 'es', child: Text(l10n.spanish)),
                  ],
                  onChanged: (value) {
                    setState(() {
                      if (value != null) {
                        _selectedLanguage = value;
                        localeNotifier.value = Locale(_selectedLanguage);
                      }
                    });
                  },
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16.0,
                  vertical: 8,
                ),
                child: Text(
                  l10n.languageDescription,
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
            ],
          ),
          ExpansionTile(
            leading: const Icon(Icons.vpn_key, color: Colors.orange),
            title: Text(l10n.access),
            children: [
              SwitchListTile(
                title: Text(l10n.gpsPermission),
                subtitle: Text(l10n.gpsPermissionDescription),
                value: _gpsEnabled,
                onChanged:
                    (value) => _requestPermission(
                      Permission.location,
                      (enabled) => setState(() => _gpsEnabled = enabled),
                    ),
              ),
              SwitchListTile(
                title: Text(l10n.galleryPermission),
                subtitle: Text(l10n.galleryPermissionDescription),
                value: _galleryEnabled,

                onChanged:
                    (value) => _requestPermission(
                      Permission.photos,
                      (enabled) => setState(() => _galleryEnabled = enabled),
                    ),
              ),
              SwitchListTile(
                title: Text(l10n.cameraPermission),
                subtitle: Text(l10n.cameraPermissionDescription),
                value: _cameraEnabled,
                onChanged:
                    (value) => _requestPermission(
                      Permission.camera,
                      (enabled) => setState(() => _cameraEnabled = enabled),
                    ),
              ),
              SwitchListTile(
                title: Text(l10n.contactsPermission),
                subtitle: Text(l10n.contactsPermissionDescription),
                value: _contactsEnabled,
                onChanged:
                    (value) => _requestPermission(
                      Permission.contacts,
                      (enabled) => setState(() => _contactsEnabled = enabled),
                    ),
              ),
            ],
          ),
          ExpansionTile(
            leading: const Icon(Icons.brightness_6, color: Colors.amber),
            title: Text(l10n.appearance),
            children: [
              SwitchListTile(
                title: Text(l10n.darkTheme),
                value: isDarkTheme,
                activeColor: Constants.primaryColor,
                activeTrackColor: Colors.grey[400],
                inactiveThumbColor: Colors.grey,
                inactiveTrackColor: Colors.grey[400],

                onChanged: (value) {
                  setState(() {
                    themeNotifier.value =
                        value ? ThemeMode.dark : ThemeMode.light;
                  });
                },
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                child: Text(
                  l10n.appearanceDescription,
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
            ],
          ),
          ExpansionTile(
            leading: const Icon(Icons.notifications, color: Colors.redAccent),
            title: Text(l10n.notifications),
            children: [
              SwitchListTile(
                title: Text(l10n.enableNotifications),
                value: _notificationsEnabled,
                onChanged: (val) {
                  setState(() {
                    _notificationsEnabled = val;
                  });
                },
              ),
              if (_notificationsEnabled)
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: Text(
                    l10n.notificationsDescription,
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
            ],
          ),
          ExpansionTile(
            leading: const Icon(Icons.timeline, color: Colors.green),
            title: Text(l10n.myActivity),
            children: [
              ListTile(
                title: Text(l10n.activitySummary),
                subtitle: Text(l10n.last7Days),
                onTap: () {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(l10n.viewActivity)));
                },
              ),
            ],
          ),
          ExpansionTile(
            leading: const Icon(Icons.shopping_cart, color: Colors.purple),
            title: Text(l10n.purchaseHistory),
            children: [
              ListTile(
                title: Text(l10n.viewFullHistory),
                onTap: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(l10n.viewPurchaseHistory)),
                  );
                },
              ),
            ],
          ),
          ExpansionTile(
            leading: const Icon(Icons.comment, color: Colors.teal),
            title: Text(l10n.commentHistory),
            children: [
              ListTile(
                title: Text(l10n.commentsMade),
                onTap: () {
                  ScaffoldMessenger.of(
                    context,
                  ).showSnackBar(SnackBar(content: Text(l10n.viewComments)));
                },
              ),
            ],
          ),
          ExpansionTile(
            leading: const Icon(Icons.timer, color: Colors.indigo),
            title: Text(l10n.timeManagement),
            children: [
              ListTile(
                title: Text(l10n.totalTimeToday),
                subtitle: Text(_formatarTempo(_tempoTotal)),
              ),
              SwitchListTile(
                title: Text(l10n.enableLimit),
                value: _limiteAtivo,
                onChanged: (valor) {
                  setState(() => _limiteAtivo = valor);
                },
              ),
              if (_limiteAtivo)
                ListTile(
                  title: Text(l10n.setLimit),
                  trailing: DropdownButton<int>(
                    value: _limiteMinutos,
                    items:
                        [1, 30, 60, 90, 120].map((min) {
                          return DropdownMenuItem(
                            value: min,
                            child: Text('$min min'),
                          );
                        }).toList(),
                    onChanged: (val) {
                      setState(() => _limiteMinutos = val!);
                    },
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}
