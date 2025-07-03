import 'package:flutter/material.dart';
import 'package:projeto_cm/Model/custom_user.dart';

class MyAccountScreen extends StatefulWidget {
  final CustomUser user;

  const MyAccountScreen({super.key, required this.user});

  @override
  _MyAccountScreenState createState() => _MyAccountScreenState();
}

class _MyAccountScreenState extends State<MyAccountScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  // late TextEditingController _phoneController;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.name);
    _emailController = TextEditingController(text: widget.user.email);
    // _phoneController = TextEditingController(text: widget.user.phone ?? '');
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    // _phoneController.dispose();
    super.dispose();
  }

  void _saveChanges() {
    // Substitua print por logger se for produção
    print('Salvar nome: ${_nameController.text}');
    // print('Salvar telefone: ${_phoneController.text}');
    // lógica para salvar alterações aqui
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Minha Conta')),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: ListView(
          children: [
            CircleAvatar(
              radius: 50,
              backgroundImage: const AssetImage('assets/img/user_photo.jpg'),
            ),
            TextButton(
              onPressed: () {
                // função para alterar foto
              },
              child: const Text('Alterar Foto'),
            ),
            TextField(
              controller: _nameController,
              decoration: const InputDecoration(labelText: 'Nome'),
            ),
            TextField(
              controller: _emailController,
              decoration: const InputDecoration(labelText: 'Email'),
              readOnly: true,
            ),
            // TextField(
            //   controller: _phoneController,
            //   decoration: const InputDecoration(labelText: 'Telefone'),
            //   keyboardType: TextInputType.phone,
            // ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _saveChanges,
              child: const Text('Salvar Alterações'),
            ),
            TextButton(
              onPressed: () {
                // abrir tela para alterar senha
              },
              child: const Text('Alterar Senha'),
            ),
            TextButton(
              onPressed: () {
                // excluir conta
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text('Excluir Conta'),
            ),
          ],
        ),
      ),
    );
  }
}
