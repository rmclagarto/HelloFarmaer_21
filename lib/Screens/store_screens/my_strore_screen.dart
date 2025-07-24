// main_store.dart

import 'package:flutter/material.dart';
import 'package:hellofarmer/Model/store.dart';
import 'package:hellofarmer/Core/constants.dart';
import 'package:hellofarmer/Providers/store_provider.dart';
import 'package:hellofarmer/Providers/user_provider.dart';
import 'package:hellofarmer/Widgets/store_widgets/gestao_section.dart';
import 'package:hellofarmer/Widgets/store_widgets/store_details.dart';
import 'package:provider/provider.dart';

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

    if (!mounted || confimar != true) return;

    final storeProvider = Provider.of<StoreProvider>(context, listen: false);
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      await storeProvider.deleteStore(
        userID: userProvider.user!.idUtilizador,
        storeID: widget.loja.idLoja,
      );

      if (mounted) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text("Erro ao excluir loja")));
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(
          widget.loja.nomeLoja,
          style: theme.textTheme.headlineSmall?.copyWith(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: PaletaCores.corPrimaria,
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
        foregroundColor: isActive ? PaletaCores.corPrimaria : Colors.grey,
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
