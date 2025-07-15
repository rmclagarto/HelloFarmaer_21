import 'dart:io';
import 'package:flutter/material.dart';
import 'package:hellofarmer/Core/routes.dart';
import 'package:hellofarmer/Providers/user_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:hellofarmer/Core/constants.dart';
import 'package:hellofarmer/Model/custom_user.dart';
import 'package:hellofarmer/l10n/app_localizations.dart';
import 'package:provider/provider.dart';

class MyAccountScreen extends StatefulWidget {
  final CustomUser user;

  const MyAccountScreen({super.key, required this.user});

  @override
  _MyAccountScreenState createState() => _MyAccountScreenState();
}

class _MyAccountScreenState extends State<MyAccountScreen> {
  late TextEditingController _nameController;
  late TextEditingController _emailController;
  late TextEditingController _passwordController;
  bool _obscurePassword = true;

  File? _selectedImage;

  @override
  void initState() {
    super.initState();
    _nameController = TextEditingController(text: widget.user.nomeUser);
    _emailController = TextEditingController(text: widget.user.email);
    _passwordController = TextEditingController();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  void _togglePasswordVisibility() {
    setState(() => _obscurePassword = !_obscurePassword);
  }

  Future<void> _deleteAccount() async {
    final confirm = await showDialog<bool>(
      context: context,
      builder:
          (ctx) => AlertDialog(
            title: const Text("Confirmar eleminação"),
            content: const Text(
              "Tens a certeza que queres eleminar a tua conta?",
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(ctx, false),
                child: const Text("Cancelar"),
              ),
              TextButton(
                onPressed: () => Navigator.pop(ctx, true),
                child: const Text(
                  "Eleminar",
                  style: TextStyle(color: Colors.red),
                ),
              ),
            ],
          ),
    );

    if (confirm != true) return;

    try {
      final userProvider = Provider.of<UserProvider>(context, listen: false);
      await userProvider.deleteUserAccount();
      if (!mounted) return;

      Navigator.of(
        context,
      ).pushNamedAndRemoveUntil(Routes.login, (route) => false);
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Erro ao apagar conta. Tenta novamente."),
          backgroundColor: Colors.red,
        ),
      );
    }
  }

  // NOVO: Selecionar imagem da galeria
  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });

      
      final userProvider = Provider.of<UserProvider>(context, listen: false);

    if (userProvider.user != null && _selectedImage != null) {
      final updatedUser = userProvider.user!.copyWith(imagemPerfil: _selectedImage!.path);
      userProvider.updateUser(updatedUser);
    }
      // Aqui você pode fazer upload da imagem para o servidor, se quiser
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;

    return Scaffold(
      appBar: AppBar(
        title: Text(
          l10n.myAccountTitle,
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Constants.primaryColor,
        centerTitle: true,
        elevation: 2,
        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 32),
        child: Column(
          children: [
            // Avatar com botão editar
            Center(
              child: Stack(
                alignment: Alignment.bottomRight,
                children: [
                  CircleAvatar(
                    radius: 60,
                    backgroundColor: Colors.grey[200],
                    backgroundImage:
                        _selectedImage != null
                            ? FileImage(_selectedImage!)
                            : null,
                    child:
                        _selectedImage == null
                            ? Image.asset('assets/img/AgricultorAvatar.jpg')
                            : null,
                  ),

                  Positioned(
                    bottom: 4,
                    right: 4,
                    child: GestureDetector(
                      onTap: _pickImage,
                      child: CircleAvatar(
                        radius: 20,
                        backgroundColor: Constants.primaryColor,
                        child: const Icon(
                          Icons.edit,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),

            const SizedBox(height: 32),

            // Campos nome, email, senha...
            TextFormField(
              controller: _nameController,
              decoration: InputDecoration(
                labelText: l10n.name,
                prefixIcon: Icon(Icons.person, color: Constants.primaryColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),
            const SizedBox(height: 20),

            TextFormField(
              controller: _emailController,
              decoration: InputDecoration(
                labelText: l10n.email,
                prefixIcon: Icon(Icons.email, color: Constants.primaryColor),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              keyboardType: TextInputType.emailAddress,
            ),
            const SizedBox(height: 20),

            TextFormField(
              controller: _passwordController,
              obscureText: _obscurePassword,
              decoration: InputDecoration(
                labelText: "l10n.password",
                prefixIcon: Icon(Icons.lock, color: Constants.primaryColor),
                suffixIcon: IconButton(
                  icon: Icon(
                    _obscurePassword ? Icons.visibility : Icons.visibility_off,
                  ),
                  onPressed: _togglePasswordVisibility,
                ),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
            ),

            const SizedBox(height: 30),

            // Seções: mensagens, avaliações, encomendas
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                _buildMenuIcon(
                  icon: Icons.message,
                  label: 'Mensagens',
                  onTap: () {},
                ),
                _buildMenuIcon(
                  icon: Icons.star,
                  label: 'Avaliações',
                  onTap: () {},
                ),
                _buildMenuIcon(
                  icon: Icons.shopping_bag,
                  label: 'Encomendas',
                  onTap: () {},
                ),
              ],
            ),

            const SizedBox(height: 40),

            // Botões: Histórico e Moradas
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.history, color: Colors.white),
                    label: const Text(
                      'Histórico',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Constants.primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: () {},
                    icon: const Icon(Icons.location_on, color: Colors.white),
                    label: const Text(
                      'Moradas',
                      style: TextStyle(color: Colors.white),
                    ),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Constants.primaryColor,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                  ),
                ),
              ],
            ),

            const SizedBox(height: 40),

            // Botão para Apagar conta
            SizedBox(
              width: double.infinity,
              child: OutlinedButton.icon(
                onPressed: _deleteAccount,
                icon: Icon(Icons.delete_outline, color: Colors.red.shade700),
                label: Text(
                  'Encerrar Conta',
                  style: TextStyle(
                    color: Colors.red.shade700,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                style: OutlinedButton.styleFrom(
                  side: BorderSide(color: Colors.red.shade700),
                  padding: const EdgeInsets.symmetric(vertical: 16),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildMenuIcon({
    required IconData icon,
    required String label,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: Constants.primaryColor,
            child: Icon(icon, size: 32, color: Colors.white),
          ),
          const SizedBox(height: 8),
          Text(label, style: const TextStyle(fontWeight: FontWeight.w600)),
        ],
      ),
    );
  }
}
