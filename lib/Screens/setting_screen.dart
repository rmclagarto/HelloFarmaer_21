import 'package:flutter/material.dart';
import 'package:hellofarmer/Core/constants.dart';
import 'package:hellofarmer/l10n/app_localizations.dart';
import 'package:hellofarmer/main.dart';
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
  String _selectedLanguage = 'pt';

  bool _gpsEnabled = false;
  bool _galleryEnabled = false;
  bool _cameraEnabled = false;
  bool _contactsEnabled = false;

  Future<void> _checkPermissions() async {
    await Permission.location.status;
    await Permission.photos.status;
    await Permission.camera.status;
    await Permission.contacts.status;
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<void> _requestPermission(
    Permission permission,
    Function(bool) setStateCallback,
  ) async {
    final status = await permission.request();
    setStateCallback(status.isGranted);

    if (!status.isGranted && status.isPermanentlyDenied) {
      await openAppSettings();
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = themeNotifier.value == ThemeMode.dark;
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Constants.primaryColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          l10n.settingsTitle,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
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
                    DropdownMenuItem(value: 'es', child: Text(l10n.spanish)),
                    DropdownMenuItem(value: 'en', child: Text(l10n.english)),
                    DropdownMenuItem(value: 'fr', child: Text(l10n.french)),
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
          // BOTÃO PARA REPORTAR ERROS
          ListTile(
            leading: const Icon(Icons.bug_report, color: Colors.redAccent),
            title: Text(l10n.reportErrors),
            onTap: () {
              showDialog(
                context: context,
                builder: (ctx) {
                  TextEditingController reportController =
                      TextEditingController();
                  return AlertDialog(
                    title: Text(l10n.reportErrors),
                    content: TextField(
                      controller: reportController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: l10n.describeProblem,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    actions: [
                      TextButton(
                        child: Text(l10n.cancel),
                        onPressed: () => Navigator.of(ctx).pop(),
                      ),
                      ElevatedButton(
                        child: Text(l10n.send),
                        onPressed: () {
                          final reportText = reportController.text.trim();
                          if (reportText.isNotEmpty) {
                            Navigator.of(ctx).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text(l10n.thankYouReport)),
                            );
                          }
                        },
                      ),
                    ],
                  );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}
