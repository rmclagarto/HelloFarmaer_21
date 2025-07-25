import 'dart:io';

import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:hellofarmer/Core/cores.dart';
import 'package:hellofarmer/Model/loja.dart';
import 'package:hellofarmer/Providers/loja_provider.dart';
import 'package:hellofarmer/Providers/utilizador_provider.dart';
import 'package:hellofarmer/Services/basedados.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';

class CriarLojaForm extends StatefulWidget {
  const CriarLojaForm({super.key});

  @override
  State<CriarLojaForm> createState() => _CriarLojaFormState();
}

class _CriarLojaFormState extends State<CriarLojaForm> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _controladorNome = TextEditingController();
  final TextEditingController _controladorDescricao = TextEditingController();
  final TextEditingController _controladorTelefone = TextEditingController();
  final TextEditingController _controladorBairro = TextEditingController();
  final TextEditingController _controladorCidade = TextEditingController();
  // final TextEditingController _stateController = TextEditingController();
  final TextEditingController _controladorRua = TextEditingController();
  final TextEditingController _controladorNumero = TextEditingController();

  File? _imagemSelecionada;

  @override
  void dispose() {
    _controladorNome.dispose();
    _controladorDescricao.dispose();
    _controladorTelefone.dispose();
    _controladorBairro.dispose();
    _controladorCidade.dispose();
    // _stateController.dispose();
    _controladorRua.dispose();
    _controladorNumero.dispose();
    super.dispose();
  }

  Future<void> _pickImage() async {
    final picker = ImagePicker();
    final pickedFile = await picker.pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imagemSelecionada = File(pickedFile.path);
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
        backgroundColor: PaletaCores.corPrimaria(context),
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
      controller: _controladorNome,
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
                _imagemSelecionada == null
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
                        _imagemSelecionada!,
                        fit: BoxFit.cover,
                        width: double.infinity,
                        height: double.infinity,
                      ),
                    ),
          ),
        ),
        if (_imagemSelecionada != null)
          TextButton(onPressed: _pickImage, child: const Text("Alterar foto")),
      ],
    );
  }

  Widget _buildDescricaoField() {
    return TextFormField(
      controller: _controladorDescricao,
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
      controller: _controladorTelefone,
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
      controller: _controladorRua,
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
      controller: _controladorNumero,
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
      controller: _controladorBairro,
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
      controller: _controladorCidade,
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
          backgroundColor: PaletaCores.corPrimaria(context),
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

        final minhaNovaLoja = Loja.minhaLoja(
          idLoja: idLoja,
          nomeLoja: _controladorNome.text.trim(),
          descricao: _controladorDescricao.text.trim(),
          telefone: _controladorTelefone.text,
          endereco: {
            "rua": _controladorRua.text,
            "bairro": _controladorBairro.text,
            "cidade": _controladorCidade.text,
            "numero": int.tryParse(_controladorNumero.text) ?? 0,
          },
          avaliacoes: 0.0,
          faturamento: 0.0,
        );

        // final _dbService = DatabaseService();
        await BancoDadosServico().create(
          caminho: "stores/$idLoja",
          dados: minhaNovaLoja.toJson(),
        );

        if (!mounted) return;
        final usr = Provider.of<UtilizadorProvider>(context, listen: false);
        await usr.adicionarLojaAoUtilizador(minhaNovaLoja.idLoja);

        
        if (!mounted) return;
        Provider.of<LojaProvider>(context,listen: false,).adicionarLoja(minhaNovaLoja);

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