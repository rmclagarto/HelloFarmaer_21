// main_store.dart
import 'package:flutter/material.dart';
import 'package:projeto_cm/Core/constants.dart';
import 'package:projeto_cm/Model/conversa.dart';
import 'package:projeto_cm/Model/menssagens.dart';

import 'package:projeto_cm/Model/store.dart';
import 'package:projeto_cm/Screens/store_screens/lista_conversas_screen.dart';
import 'package:projeto_cm/Widgets/store_widgets/gestao_section.dart';
import 'package:projeto_cm/Widgets/store_widgets/store_details.dart';

class MainStoreScreen extends StatefulWidget {
  final Store loja;

  const MainStoreScreen({super.key, required this.loja});

  @override
  State<MainStoreScreen> createState() => _MainStoreScreenState();
}

class _MainStoreScreenState extends State<MainStoreScreen> {
  final ScrollController _scrollController = ScrollController();
  int _currentIndex = 0;

  final List<Widget> _sections = [];
  final List<GlobalKey> _sectionsKeys = [
    GlobalKey(), // MINHA BANCA
    GlobalKey(), // GESTÂO
  ];

  @override
  void initState() {
    super.initState();
    _sections.addAll([
      StoreDetails(key: _sectionsKeys[0], store: widget.loja), // Minha BANCA
      GestaoSection(key: _sectionsKeys[1], store: widget.loja), // GESTÂO
    ]);
  }

  void _scrollToSection(int index) {
    setState(() {
      _currentIndex = index;
    });

    if (index == 2) {
    // Lista de conversas aqui mesmo
    final List<Conversa> conversas = [
      Conversa(
        id: '1',
        title: 'João Silva',
        unreadCount: 0,
        messages: [
          Message(sender: 'João', text: 'Oi, preciso de ajuda', time: DateTime.now().subtract(Duration(minutes: 5))),
          Message(sender: 'Suporte', text: 'Claro, em que posso ajudar?', time: DateTime.now()),
        ],
      ),
      Conversa(
        id: '2',
        title: 'Maria Oliveira',
        unreadCount: 1,
        messages: [
          Message(sender: 'Maria', text: 'Meu pedido atrasou', time: DateTime.now().subtract(Duration(hours: 1))),
        ],
      ),
    ];

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (_) => ListaConversasScreen(conversas: conversas),
      ),
    );
    return;
  }
  
    // Scroll para as seções normais
    final sectionContext = _sectionsKeys[index].currentContext;
    if (sectionContext != null) {
      Scrollable.ensureVisible(
        sectionContext,
        duration: const Duration(milliseconds: 500),
        curve: Curves.bounceInOut,
        alignment: 0.1,
      );
    }
  }

  void _confirmarExclusaoLoja() async {
    final confimar = await showDialog<bool>(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Confirmação de Exclusão"),
            content: const Text("Tem certeza que deseja eleminar esta loja?"),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: const Text("Cancelar"),
              ),
              TextButton(
                onPressed: () {
                  // Aqui você pode adicionar a lógica para excluir a loja
                  Navigator.pop(context, true);
                },
                child: const Text(
                  "Eliminar",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );

    if (!mounted) return;

    if (confimar == true) {
      // Lógica para excluir a loja
      Navigator.pop(context, {'delete': true, 'storeId': widget.loja.id});
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.loja.nome,
          style: theme.textTheme.headlineSmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Constants.primaryColor,
        elevation: 0,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              controller: _scrollController,
              child: Column(
                children: [
                  ..._sections,
                  const SizedBox(height: 20),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: ElevatedButton.icon(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        minimumSize: const Size.fromHeight(50),
                      ),
                      icon: Icon(Icons.delete, color: Colors.white),
                      label: const Text(
                        'Eliminar Loja',
                        style: TextStyle(color: Colors.white, fontSize: 16),
                      ),
                      onPressed: _confirmarExclusaoLoja,
                    ),
                  ),
                  const SizedBox(height: 30),
                ],
              ),
            ),
          ),
          _buildBottomNavigationBar(),
        ],
      ),
    );
  }

  Widget _buildBottomNavigationBar() {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.grey,
            blurRadius: 10,
            offset: const Offset(0, -5),
          ),
        ],
      ),
      child: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              _buildNavButton(
                icon: Icons.store,
                label: "Minha banca",
                isActive: _currentIndex == 0,
                onPressed: () => _scrollToSection(0),
              ),
              _buildNavButton(
                icon: Icons.bar_chart,
                label: "Gestão",
                isActive: _currentIndex == 1,
                onPressed: () => _scrollToSection(1),
              ),
              _buildNavButton(
                icon: Icons.support_agent,
                label: "Suporte",
                isActive: _currentIndex == 2,
                onPressed: () => _scrollToSection(2),
              ),

              // _buildNavButton(
              //   icon:Icons.shopping_cart,
              //   label: "Vender",
              //   isActive: _currentIndex == 2,
              //   onPressed: () => _scrollToSection(2),
              // ),

              // _buildNavButton(
              //   icon:Icons.shopping_bag,
              //   label: "Produtos",
              //   isActive: _currentIndex == 3,
              //   onPressed: () => _scrollToSection(3),
              // ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavButton({
    required IconData icon,
    required String label,
    required bool isActive,
    required VoidCallback onPressed,
  }) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        foregroundColor: isActive ? Constants.primaryColor : Colors.grey,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, size: 24),
          const SizedBox(height: 4),
          Text(label, style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}
