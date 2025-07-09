import 'package:flutter/material.dart';
import 'package:hellofarmer/main.dart';
import 'package:hellofarmer/Core/constants.dart';
import 'package:hellofarmer/Model/custom_user.dart';
import 'package:hellofarmer/Widgets/home_widgets/drawer.dart';
import 'package:hellofarmer/Widgets/home_widgets/map_widget.dart';
import 'package:hellofarmer/Widgets/home_widgets/button_panel.dart';

class Home extends StatefulWidget {
  final CustomUser user;
  const Home({super.key, required this.user});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController searchController = TextEditingController();
  final GlobalKey<MapWidgetState> _mapKey = GlobalKey<MapWidgetState>();

  late CustomUser user;

  @override
  void initState() {
    super.initState();
    user = widget.user;
  }

  final List<String> _ads = [
    "Anúncio 1: Vendo batatas biológicas",
    "Anúncio 2: Serviço de colheita disponível",
    "Anúncio 3: Aluguer de trator",
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'HelloFarmer',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Constants.primaryColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      drawer: AppDrawer(user: user, themeNotifier: themeNotifier),
      body: Stack(
        children: [
          MapWidget(key: _mapKey),

          BottomPanel(
            ads: _ads,
            onAdTap: (ad) {
              _mapKey.currentState?.addRandomMarker();
            },
          ),
        ],
      ),
    );
  }
}
