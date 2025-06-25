import 'package:flutter/material.dart';
import 'package:projeto_cm/Core/constants.dart';
import 'package:projeto_cm/Model/custom_user.dart';
import 'package:projeto_cm/Widgets/home_widgets/button_panel.dart';
import 'package:projeto_cm/Widgets/home_widgets/drawer.dart';
import 'package:projeto_cm/Widgets/home_widgets/map_widget.dart';
import 'package:projeto_cm/Widgets/ad_widgets/notification_botton.dart';
import 'package:projeto_cm/Widgets/home_widgets/notification_panel.dart';
import 'package:projeto_cm/Widgets/home_widgets/seach_bar.dart';

class Home extends StatefulWidget {
  final CustomUser user;
  const Home({super.key, required this.user});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  final TextEditingController searchController = TextEditingController();

  late CustomUser user;

  @override
  void initState(){
    super.initState();
    user = widget.user;
  }

 
  // Simulando uma lista de notificações
  final List<String> _notifications = [
    "Notificação 1: Pedido enviado",
    "Notificação 2: Novo anúncio disponível",
  ];

  final List<String> _ads = [
    "Anúncio 1: Vendo batatas biológicas",
    "Anúncio 2: Serviço de colheita disponível",
    "Anúncio 3: Aluguer de trator",
    "Anúncio 1: Vendo batatas biológicas",
    "Anúncio 2: Serviço de colheita disponível",
    "Anúncio 3: Aluguer de trator",
    "Anúncio 1: Vendo batatas biológicas",
    "Anúncio 2: Serviço de colheita disponível",
    "Anúncio 3: Aluguer de trator",
    "Anúncio 1: Vendo batatas biológicas",
    "Anúncio 2: Serviço de colheita disponível",
    "Anúncio 3: Aluguer de trator",

    "Anúncio 1: Vendo batatas biológicas",
    "Anúncio 2: Serviço de colheita disponível",
    "Anúncio 3: Aluguer de trator",
    "Anúncio 1: Vendo batatas biológicas",
    "Anúncio 2: Serviço de colheita disponível",
    "Anúncio 3: Aluguer de trator",
    "Anúncio 1: Vendo batatas biológicas",
    "Anúncio 2: Serviço de colheita disponível",
    "Anúncio 3: Aluguer de trator",
    "Anúncio 1: Vendo batatas biológicas",
    "Anúncio 2: Serviço de colheita disponível",
    "Anúncio 3: Aluguer de trator",
    "Anúncio 1: Vendo batatas biológicas",
    "Anúncio 2: Serviço de colheita disponível",
    "Anúncio 3: Aluguer de trator",
    "Anúncio 1: Vendo batatas biológicas",
    "Anúncio 2: Serviço de colheita disponível",
    "Anúncio 3: Aluguer de trator",
    "Anúncio 1: Vendo batatas biológicas",
    "Anúncio 2: Serviço de colheita disponível",
    "Anúncio 3: Aluguer de trator",
    "Anúncio 1: Vendo batatas biológicas",
    "Anúncio 2: Serviço de colheita disponível",
    "Anúncio 3: Aluguer de trator",
    "Anúncio 1: Vendo batatas biológicas",
    "Anúncio 2: Serviço de colheita disponível",
    "Anúncio 3: Aluguer de trator",
    "Anúncio 1: Vendo batatas biológicas",
    "Anúncio 2: Serviço de colheita disponível",
    "Anúncio 3: Aluguer de trator",
    "Anúncio 1: Vendo batatas biológicas",
    "Anúncio 2: Serviço de colheita disponível",
    "Anúncio 3: Aluguer de trator",
    "Anúncio 1: Vendo batatas biológicas",
    "Anúncio 2: Serviço de colheita disponível",
    "Anúncio 3: Aluguer de trator",
  ];

  void _showNotifications() {
    showModalBottomSheet(
      context: context,
      builder: (context) => NotificationPanel(notifications: _notifications),
    );
  }

  @override
  Widget build(BuildContext context) {


    return Scaffold(
      appBar: AppBar(
        
        title: const Text(
            'HelloFarmer',
            style:  TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          backgroundColor: Constants.primaryColor,
          elevation: 0,
          centerTitle: true,
          iconTheme: const IconThemeData(color: Colors.white),
        actions: [
          NotificationButton(
            notificationCount: _notifications.length,
            onPressed: _showNotifications, // alterar aqui para a função
          ),
        ],
      ),
      drawer: AppDrawer(user: user),
      body: Stack(
        children: [
          MapWidget(),
          Positioned(
            top: 16,
            left: 16,
            right: 16,
            child: CustomSearchBar(searchController: searchController),
          ),
          BottomPanel(ads: _ads),
        ],
      ),
    );
  }
}
