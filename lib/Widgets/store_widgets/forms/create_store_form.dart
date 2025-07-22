import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hellofarmer/Core/constants.dart';
import 'package:hellofarmer/Model/store.dart';
import 'package:hellofarmer/Providers/store_provider.dart';
import 'package:hellofarmer/Providers/user_provider.dart';
import 'package:hellofarmer/Services/database_service.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class CreateStoreForm extends StatefulWidget {
  const CreateStoreForm({super.key});

  @override
  State<CreateStoreForm> createState() => _CreateStoreFormState();
}

class _CreateStoreFormState extends State<CreateStoreForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  final TextEditingController _neighborhoodController = TextEditingController();
  final TextEditingController _cityController = TextEditingController();
  final TextEditingController _stateController = TextEditingController();
  final TextEditingController _streetController = TextEditingController();
  final TextEditingController _numberController = TextEditingController();

  File? _selectedImage;

  @override
  void dispose() {
    _nameController.dispose();
    _descricaoController.dispose();
    _telefoneController.dispose();
    _neighborhoodController.dispose();
    _cityController.dispose();
    _stateController.dispose();
    _streetController.dispose();
    _numberController.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _selectedImage = File(pickedFile.path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Criação de Loja",
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Constants.primaryColor,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildImagePicker(),
              const SizedBox(height: 20),
              _buildSectionTitle('Informações Básicas'),
              _buildNameField(),
              const SizedBox(height: 20),
              _buildDescricaoField(),
              const SizedBox(height: 20),
              _buildTelefoneField(),
              const SizedBox(height: 20),
              _buildSectionTitle('Endereço'),
              _buildStreetField(),
              const SizedBox(height: 20),
              Row(
                children: [
                  Expanded(flex: 3, child: _buildNumberField()),
                  const SizedBox(width: 20),
                  Expanded(flex: 4, child: _buildNeighborhoodField()),
                ],
              ),
              const SizedBox(height: 20),
              Row(children: [Expanded(flex: 5, child: _buildCityField())]),
              const SizedBox(height: 40),
              _buildSubmitButton(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String text) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        text,
        style: const TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.bold,
          color: Colors.blueGrey,
        ),
      ),
    );
  }

  Widget _buildNameField() {
    return TextFormField(
      controller: _nameController,
      decoration: InputDecoration(
        labelText: 'Nome da Loja*',
        prefixIcon: const Icon(Icons.store),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Campo obrigatório';
        if (value.length < 3) return 'Mínimo 3 caracteres';
        return null;
      },
    );
  }

  Widget _buildImagePicker() {
    return Column(
      children: [
        GestureDetector(
          onTap: _pickImage,
          child: Container(
            height: 150,
            width: double.infinity,
            decoration: BoxDecoration(
              color: Colors.grey[200],
              borderRadius: BorderRadius.circular(20),
              border: Border.all(color: Colors.grey[400]!),
            ),
            child:
                _selectedImage == null
                    ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.add_a_photo, size: 40, color: Colors.grey),
                        SizedBox(height: 8),
                        Text("Adicionar foto da loja"),
                      ],
                    )
                    : ClipRRect(
                      borderRadius: BorderRadius.circular(
                        20,
                      ),
                      child: Image.file(
                        _selectedImage!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
          ),
        ),
        if (_selectedImage != null)
          TextButton(onPressed: _pickImage, child: const Text("Alterar foto")),
      ],
    );
  }

  Widget _buildDescricaoField() {
    return TextFormField(
      controller: _descricaoController,
      maxLines: 3,
      decoration: InputDecoration(
        labelText: 'Descrição*',
        alignLabelWithHint: true,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ), // <-- close decoration here
      validator: (value) {
        if (value == null || value.isEmpty) return 'Campo obrigatório';
        if (value.length < 10) return 'Descreva melhor sua loja';
        return null;
      },
    );
  }

  Widget _buildTelefoneField() {
    return TextFormField(
      controller: _telefoneController,
      keyboardType: TextInputType.phone,
      decoration: InputDecoration(
        labelText: 'Telefone*',
        prefixIcon: const Icon(Icons.phone),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        hintText: '(00) 00000-0000',
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Campo obrigatório';
        if (value.length < 11) return 'Telefone incompleto';
        return null;
      },
    );
  }

  Widget _buildStreetField() {
    return TextFormField(
      controller: _streetController,
      decoration: InputDecoration(
        labelText: 'Rua/Avenida*',
        prefixIcon: const Icon(Icons.streetview),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Campo obrigatório';
        return null;
      },
    );
  }

  Widget _buildNumberField() {
    return TextFormField(
      controller: _numberController,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: 'Número*',
        prefixIcon: const Icon(Icons.numbers),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Campo obrigatório';
        return null;
      },
    );
  }

  Widget _buildNeighborhoodField() {
    return TextFormField(
      controller: _neighborhoodController,
      decoration: InputDecoration(
        labelText: 'Bairro*',
        prefixIcon: const Icon(Icons.location_city),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ), // <-- close decoration here
      validator: (value) {
        if (value == null || value.isEmpty) return 'Campo obrigatório';
        return null;
      },
    );
  }

  Widget _buildCityField() {
    return TextFormField(
      controller: _cityController,
      decoration: InputDecoration(
        labelText: 'Cidade*',
        prefixIcon: const Icon(Icons.location_city),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(20),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Campo obrigatório';
        return null;
      },
    );
  }

  Widget _buildSubmitButton() {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: Constants.primaryColor,
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
        ),
        onPressed: _submitForm,
        child: const Text(
          'CRIAR LOJA',
          style: TextStyle(color: Colors.white, fontSize: 16),
        ),
      ),
    );
  }

  void _submitForm() async {
    if (_formKey.currentState!.validate()) {
      try {
        final storeRef = FirebaseDatabase.instance.ref().child("stores").push();
        
        final String idLoja = storeRef.key!;

        final minhaNovaLoja = Store.myStore(
          idLoja: idLoja,
          nomeLoja: _nameController.text.trim(),
          descricao: _descricaoController.text.trim(),
          telefone: _telefoneController.text,
          endereco: {
            "rua": _streetController.text,
            "bairro": _neighborhoodController.text,
            "cidade": _cityController.text,
            "numero": int.tryParse(_numberController.text) ?? 0,
          },
          avaliacoes: 0.0,
          faturamento: 0.0,
        );

        // final _dbService = DatabaseService();
        await DatabaseService().create(
          path: "stores/$idLoja",
          data: minhaNovaLoja.toJson(),
        );

        if (!mounted) return;
        final usr = Provider.of<UserProvider>(context, listen: false);
        await usr.addStoreToUser(minhaNovaLoja.idLoja);

        
        if (!mounted) return;
        Provider.of<StoreProvider>(context,listen: false,).addStore(minhaNovaLoja);

        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Loja criada com sucesso!'),
            backgroundColor: Colors.green,
          ),
        );

        if (!mounted) return;

        Navigator.pop(context, minhaNovaLoja);
    } catch (e) {
        if (!mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Erro ao criar loja: ${e.toString()}'),
            backgroundColor: Colors.red,
          ),
        );
      }
  }
}
}