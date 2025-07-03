// import 'package:flutter/material.dart';
// import 'package:projeto_cm/Core/constants.dart';
// import 'package:projeto_cm/main.dart';

// class SettingsScreen extends StatefulWidget {
//   final bool isDarkTheme;
//   final ValueChanged<bool> onThemeChanged;

//   const SettingsScreen({
//     super.key,
//     required this.isDarkTheme,
//     required this.onThemeChanged,
//   });

//   @override
//   State<SettingsScreen> createState() => _SettingsScreenState();
// }

// class _SettingsScreenState extends State<SettingsScreen> {
//   // Estados de alguns switches como exemplo:
//   bool _notificationsEnabled = true;
//   bool _timeManagementEnabled = false;
//   String _selectedLanguage = 'Português';

//   DateTime? _entradaApp;
//   Duration _tempoTotal = Duration.zero;
//   bool _limiteAtivo = false;
//   int _limiteMinutos = 60; // Limite padrão de 1 hora

//   @override
//   void initState(){
//     super.initState();
//     _entradaApp = DateTime.now();
//   }

//   @override
// void dispose() {
//   // Calcula o tempo quando o usuário sai
//   if (_entradaApp != null) {
//     final tempoSessao = DateTime.now().difference(_entradaApp!);
//     setState(() {
//       _tempoTotal += tempoSessao;
//     });
//   }
//   super.dispose();
// }

//   @override
//   Widget build(BuildContext context) {
//     final isDarkTheme = themeNotifier.value == ThemeMode.dark;
//     return Scaffold(
//       appBar: AppBar(
//         backgroundColor: Constants.primaryColor,
//         elevation: 0,
//         centerTitle: true,
//         iconTheme: const IconThemeData(color: Colors.white),
//         title: const Text(
//           'Definições',
//           style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
//         ),
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//         ),
//       ),

//       body: ListView(
//         padding: const EdgeInsets.all(12),
//         children: [
//           ExpansionTile(
//             leading: const Icon(Icons.language, color: Colors.blue),
//             title: const Text('Idiomas e Traduções'),
//             children: [
//               ListTile(
//                 title: const Text('Idioma Atual'),
//                 trailing: DropdownButton<String>(
//                   value: _selectedLanguage,
//                   items: const [
//                     DropdownMenuItem(
//                       value: 'Português',
//                       child: Text('Português'),
//                     ),
//                     DropdownMenuItem(value: 'Inglês', child: Text('Inglês')),
//                     DropdownMenuItem(
//                       value: 'Espanhol',
//                       child: Text('Espanhol'),
//                     ),
//                   ],
//                   onChanged: (value) {
//                     setState(() {
//                       if (value != null) _selectedLanguage = value;
//                     });
//                   },
//                 ),
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(
//                   horizontal: 16.0,
//                   vertical: 8,
//                 ),
//                 child: Text(
//                   'Selecione o idioma preferido para a interface e traduções.',
//                   style: TextStyle(color: Colors.grey[600]),
//                 ),
//               ),
//             ],
//           ),
//           ExpansionTile(
//             leading: const Icon(Icons.vpn_key, color: Colors.orange),
//             title: const Text('Acessos'),
//             children: [
//               ListTile(
//                 title: const Text('Gerir permissões'),
//                 trailing: ElevatedButton(
//                   child: const Text('Abrir'),
//                   onPressed: () {
//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(content: Text('Abrir gestão de acessos')),
//                     );
//                   },
//                 ),
//               ),
//             ],
//           ),
//          ExpansionTile(
//             leading: const Icon(Icons.brightness_6, color: Colors.amber),
//             title: const Text('Aparência'),
//             children: [
//               SwitchListTile(
//                 title: const Text('Tema escuro'),
//                 value: isDarkTheme,
//                 onChanged: (value) {
//                   setState(() {
//                     themeNotifier.value =
//                         value ? ThemeMode.dark : ThemeMode.light;
//                   });
//                 },
//               ),
//               Padding(
//                 padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
//                 child: Text(
//                   'Altere entre o modo claro e escuro para uma melhor experiência visual.',
//                   style: TextStyle(color: Colors.grey[600]),
//                 ),
//               ),
//             ],
//           ),

//           ExpansionTile(
//             leading: const Icon(Icons.notifications, color: Colors.redAccent),
//             title: const Text('Notificações'),
//             children: [
//               SwitchListTile(
//                 title: const Text('Ativar notificações'),
//                 value: _notificationsEnabled,
//                 onChanged: (val) {
//                   setState(() {
//                     _notificationsEnabled = val;
//                   });
//                 },
//               ),
//               if (_notificationsEnabled)
//                 Padding(
//                   padding: const EdgeInsets.symmetric(
//                     horizontal: 16,
//                     vertical: 8,
//                   ),
//                   child: Text(
//                     'Configurações detalhadas de notificações virão aqui.',
//                     style: TextStyle(color: Colors.grey[600]),
//                   ),
//                 ),
//             ],
//           ),
//           ExpansionTile(
//             leading: const Icon(Icons.timeline, color: Colors.green),
//             title: const Text('A Minha Atividade'),
//             children: [
//               ListTile(
//                 title: const Text('Resumo da atividade'),
//                 subtitle: const Text('Últimos 7 dias'),
//                 onTap: () {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(content: Text('Visualizar atividade')),
//                   );
//                 },
//               ),
//             ],
//           ),
//           ExpansionTile(
//             leading: const Icon(Icons.shopping_cart, color: Colors.purple),
//             title: const Text('Histórico de Compras'),
//             children: [
//               ListTile(
//                 title: const Text('Ver histórico completo'),
//                 onTap: () {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                       content: Text('Visualizar histórico de compras'),
//                     ),
//                   );
//                 },
//               ),
//             ],
//           ),
//           ExpansionTile(
//             leading: const Icon(Icons.comment, color: Colors.teal),
//             title: const Text('Histórico de Comentários'),
//             children: [
//               ListTile(
//                 title: const Text('Comentários realizados'),
//                 onTap: () {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(content: Text('Visualizar comentários')),
//                   );
//                 },
//               ),
//             ],
//           ),
//           ExpansionTile(
//   leading: Icon(Icons.timer),
//   title: Text("Tempo na App"),
//   children: [
//     ListTile(
//       title: Text("Tempo total hoje"),
//       subtitle: Text(_formatarTempo(_tempoTotal)),
//     ),
//     SwitchListTile(
//       title: Text("Ativar limite"),
//       value: _limiteAtivo,
//       onChanged: (valor) {
//         setState(() => _limiteAtivo = valor);
//       },
//     ),
//     if (_limiteAtivo)
//       ListTile(
//         title: Text("Definir limite (minutos)"),
//         trailing: DropdownButton<int>(
//           value: _limiteMinutos,
//           items: [30, 60, 90, 120].map((min) {
//             return DropdownMenuItem(
//               value: min,
//               child: Text("$min min"),
//             );
//           }).toList(),
//           onChanged: (val) {
//             setState(() => _limiteMinutos = val!);
//           },
//         ),
//       ),
//   ],
// ),
//     );
//   }
// }

// if (_limiteAtivo && _tempoTotal.inMinutes >= _limiteMinutos) {
//   WidgetsBinding.instance.addPostFrameCallback((_) {
//     showDialog(
//       context: context,
//       builder: (ctx) => AlertDialog(
//         title: Text("Limite Atingido"),
//         content: Text("Você usou a app por ${_formatarTempo(_tempoTotal)} hoje!"),
//         actions: [
//           TextButton(
//             child: Text("OK"),
//             onPressed: () => Navigator.pop(ctx),
//           ),
//         ],
//       ),
//     );
//   });
// }

import 'package:flutter/material.dart';
import 'package:projeto_cm/Core/constants.dart';
import 'package:projeto_cm/main.dart';
import 'package:projeto_cm/l10n/app_localizations.dart';

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
  bool _timeManagementEnabled = false;
  String _selectedLanguage = 'pt';

  DateTime? _entradaApp;
  Duration _tempoTotal = Duration.zero;
  bool _limiteAtivo = false;
  int _limiteMinutos = 60;

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

  void _changeLanguage(String? languageCode) {
    if (languageCode == null) return;

    setState(() {
      _selectedLanguage = languageCode;
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDarkTheme = themeNotifier.value == ThemeMode.dark;

    final l10n = AppLocalizations.of(context)!;

    // Check time limit after build completes
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
              ListTile(
                title: Text(l10n.managePermissions),
                trailing: ElevatedButton(
                  child: Text(l10n.open),
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text(l10n.openAccessManagement)),
                    );
                  },
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
                activeTrackColor:
                    Colors.grey[400], 
                inactiveThumbColor: Colors.grey, 
                inactiveTrackColor:
                    Colors.grey[400],

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
