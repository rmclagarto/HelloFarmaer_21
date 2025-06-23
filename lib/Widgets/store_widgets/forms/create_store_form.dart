import 'package:flutter/material.dart';
import 'package:projeto_cm/Core/constants.dart';
import 'package:projeto_cm/Model/store.dart';

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
              _buildSectionTitle('Informações Básicas'),
              _buildNameField(),
              const SizedBox(height: Constants.spacingMedium),
              _buildDescricaoField(),
              const SizedBox(height: Constants.spacingMedium),
              _buildTelefoneField(),
              const SizedBox(height: Constants.spacingMedium),
              _buildSectionTitle('Endereço'),
              _buildStreetField(),
              const SizedBox(height: Constants.spacingMedium),
              Row(
                children: [
                  Expanded(flex: 3, child: _buildNumberField()),
                  const SizedBox(width: Constants.spacingMedium),
                  Expanded(flex: 4, child: _buildNeighborhoodField()),
                ],
              ),
              const SizedBox(height: Constants.spacingMedium),
              Row(children: [Expanded(flex: 5, child: _buildCityField())]),
              const SizedBox(height: Constants.spacingLarge),
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
          borderRadius: BorderRadius.circular(Constants.spacingMedium),
        ),
      ),
      validator: (value) {
        if (value == null || value.isEmpty) return 'Campo obrigatório';
        if (value.length < 3) return 'Mínimo 3 caracteres';
        return null;
      },
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
          borderRadius: BorderRadius.circular(Constants.spacingMedium),
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
          borderRadius: BorderRadius.circular(Constants.spacingMedium),
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
          borderRadius: BorderRadius.circular(Constants.spacingMedium),
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
          borderRadius: BorderRadius.circular(Constants.spacingMedium),
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
          borderRadius: BorderRadius.circular(Constants.spacingMedium),
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
          borderRadius: BorderRadius.circular(Constants.spacingMedium),
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
          backgroundColor: Constants.primaryColor, // Corrigido aqui
          padding: const EdgeInsets.symmetric(vertical: 16),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(Constants.spacingMedium),
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

  void _submitForm() {
    if (_formKey.currentState!.validate()) {
      final loja = Store(
        id: DateTime.now().millisecondsSinceEpoch.toString(),
        nome: _nameController.text,
        descricao: _descricaoController.text,
        telefone: _telefoneController.text,
        endereco: {
          'rua': _streetController.text,
          'numero': _numberController.text,
          'bairro': _neighborhoodController.text,
          'cidade': _cityController.text,
          'estado': _stateController.text.toUpperCase(),
        },
        avaliacoes: 4.1,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Loja criada com sucesso!'),
          backgroundColor: Colors.green,
        ),
      );

      Navigator.pop(context, loja);
    }
  }
}
