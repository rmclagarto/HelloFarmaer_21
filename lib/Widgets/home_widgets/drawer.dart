import 'package:flutter/material.dart';
import 'package:projeto_cm/Core/constants.dart';
import 'package:projeto_cm/Core/image_assets.dart';
import 'package:projeto_cm/Core/routes.dart';
import 'package:projeto_cm/Screens/market_screens/main_market_screen.dart';
import 'package:projeto_cm/Screens/store_screens/all_store_panel_screen.dart';
import 'package:projeto_cm/Model/custom_user.dart';

class AppDrawer extends StatelessWidget {
  final CustomUser user;
  final ValueNotifier<ThemeMode> themeNotifier;

  const AppDrawer({
    super.key, 
    required this.user,
    required this.themeNotifier,
  });

  @override
  Widget build(BuildContext context) {
    final navigator = Navigator.of(context); // Guarda o NavigatorState
    final String userName = user.name;
    final String userPhotoUrl = ImageAssets.agricultor;

    // Lista dentro do build para poder usar o context nas funções onTap
    final List<Map<String, dynamic>> menuItems = [
      {
        'icon':Icons.person,
        'title':'Minha Conta',
        'onTap': () {
          navigator.pop();
          Navigator.pushNamed(context, Routes.myAccount, arguments: user);
        }
      },
      {
        'icon': Icons.shopping_basket,
        'title': 'Mercado',
        'onTap': () {
          navigator.pop();
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => MarketScreen(user: user)),
          );
        },
      },
      {
        'icon': Icons.shop,
        'title': 'Loja',
        'onTap': () {
          navigator.pop(context);
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => const ListStorePanelScreen(),
            ),
          );
        },
      },
      {
        'icon': Icons.help,
        'title': 'Ajuda',
        'onTap': () {
          navigator.pop();
          // ação para Ajuda
        },
      },
      {
        'icon': Icons.settings,
        'title': 'Definições',
        'onTap': () {
          navigator.pop();
          Navigator.pushNamed(
            context,
            Routes.setting,
            arguments: {
              'isDarkTheme': themeNotifier.value == ThemeMode.dark,
              'onThemeChanged': (bool isDark) {
                themeNotifier.value = isDark ? ThemeMode.dark : ThemeMode.light;
              },
            },
          );
        },
      },
      {
        'icon': Icons.logout,
        'title': 'Sair',
        'onTap': () async {
          // await AuthService().logout();
          navigator.pop();
          navigator.pushReplacementNamed(Routes.login);
        },
      },
    ];

    return Drawer(
      child: ListView(
        padding: EdgeInsets.zero,
        children: [
          DrawerHeader(
            decoration: const BoxDecoration(color: Constants.primaryColor),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundImage: AssetImage(userPhotoUrl),
                ),
                const SizedBox(height: 10),
                Text(
                  userName,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ),
          ...menuItems.map(
            (Map<String, dynamic> item) => ListTile(
              leading: Icon(item['icon'] as IconData),
              title: Text(item['title'] as String),
              onTap: item['onTap'] as VoidCallback,
            ),
          ),
        ],
      ),
    );
  }
}
