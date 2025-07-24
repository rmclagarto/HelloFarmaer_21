import 'package:flutter/material.dart';
import 'package:hellofarmer/Core/constants.dart';
// import 'package:hellofarmer/l10n/app_localizations.dart';
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

  // Future<void> _checkPermissions() async {
  //   await Permission.location.status;
  //   await Permission.photos.status;
  //   await Permission.camera.status;
  //   await Permission.contacts.status;
  // }

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
    // final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        backgroundColor: PaletaCores.corPrimaria,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        title: Text(
          "Definições",
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
            title: Text("Idiomas e Traduções"),
            children: [
              ListTile(
                title: Text("Idioma Atual"),
                trailing: DropdownButton<String>(
                  value: _selectedLanguage,
                  items: [
                    DropdownMenuItem(value: 'pt', child: Text("Português")),
                    DropdownMenuItem(value: 'es', child: Text("Espanhol")),
                    DropdownMenuItem(value: 'en', child: Text("Inglês")),
                    DropdownMenuItem(value: 'fr', child: Text("Francês")),
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
                  "Selecione o idioma preferido para a interface e traduções.",
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
            ],
          ),
          ExpansionTile(
            leading: const Icon(Icons.vpn_key, color: Colors.orange),
            title: Text("Acessos"),
            children: [
              SwitchListTile(
                title: Text("Localização (GPS)"),
                subtitle: Text("Permitir acesso à sua localização"),
                value: _gpsEnabled,
                onChanged:
                    (value) => _requestPermission(
                      Permission.location,
                      (enabled) => setState(() => _gpsEnabled = enabled),
                    ),
              ),
              SwitchListTile(
                title: Text("Galeria"),
                subtitle: Text("Permitir acesso às suas fotos"),
                value: _galleryEnabled,
                onChanged:
                    (value) => _requestPermission(
                      Permission.photos,
                      (enabled) => setState(() => _galleryEnabled = enabled),
                    ),
              ),
              SwitchListTile(
                title: Text("Câmera"),
                subtitle: Text("Permitir acesso à câmera"),
                value: _cameraEnabled,
                onChanged:
                    (value) => _requestPermission(
                      Permission.camera,
                      (enabled) => setState(() => _cameraEnabled = enabled),
                    ),
              ),
              SwitchListTile(
                title: Text( "Contatos"),
                subtitle: Text("Permitir acesso aos seus contatos"),
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
            title: Text("Aparência"),
            children: [
              SwitchListTile(
                title: Text("Tema escuro"),
                value: isDarkTheme,
                activeColor: PaletaCores.corPrimaria,
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
                  "Altere entre o modo claro e escuro para uma melhor experiência visual.",
                  style: TextStyle(color: Colors.grey[600]),
                ),
              ),
            ],
          ),
          ExpansionTile(
            leading: const Icon(Icons.notifications, color: Colors.redAccent),
            title: Text("Notificações"),
            children: [
              SwitchListTile(
                title: Text("Ativar notificações"),
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
                    "Configurações detalhadas de notificações virão aqui.",
                    style: TextStyle(color: Colors.grey[600]),
                  ),
                ),
            ],
          ),
          // BOTÃO PARA REPORTAR ERROS
          ListTile(
            leading: const Icon(Icons.bug_report, color: Colors.redAccent),
            title: Text("Reportar Erros"),
            onTap: () {
              showDialog(
                context: context,
                builder: (ctx) {
                  TextEditingController reportController =
                      TextEditingController();
                  return AlertDialog(
                    title: Text("Reportar Erros"),
                    content: TextField(
                      controller: reportController,
                      maxLines: 4,
                      decoration: InputDecoration(
                        hintText: "Descreve o problema aqui...",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                    actions: [
                      TextButton(
                        child: Text("Cancelar"),
                        onPressed: () => Navigator.of(ctx).pop(),
                      ),
                      ElevatedButton(
                        child: Text("Enviar"),
                        onPressed: () {
                          final reportText = reportController.text.trim();
                          if (reportText.isNotEmpty) {
                            Navigator.of(ctx).pop();
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(content: Text("Obrigado por reportar o erro!")),
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
