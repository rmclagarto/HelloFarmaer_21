import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hellofarmer/Model/produtos.dart';
import 'package:image_picker/image_picker.dart';


class ProdutoForm extends StatefulWidget {
  final GlobalKey<FormState> formKey;

  const ProdutoForm({
    super.key, 
    required this.formKey
  });

  @override
  ProdutoFormState createState() => ProdutoFormState();
}

class ProdutoFormState extends State<ProdutoForm> {
  String? _selectedCategory;
  String? _selectedUnit;
  final List<bool> _deliveryOptions = [false, false, false];
  final ImagePicker _picker = ImagePicker();
  final List<XFile?> _selectedImages = List<XFile?>.filled(
    3,
    null,
    growable: false,
  );

  // Controladores de texto
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();
  final TextEditingController _localizacaoController = TextEditingController();
  final TextEditingController _nomeController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();
  final TextEditingController _quantidadeMinController =
      TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  final List<String> _deliveryLabels = [
    'Entrega Domicílio (Produtor)',
    'Comprador recolher num local à sua escolha',
    'Entrega realizada por Transportadora',
  ];

  @override
  Widget build(BuildContext context) {
    return Form(
      key: widget.formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSectionHeader('Título'),
          _buildTextField(
            controller: _tituloController,
            hint: 'Adicione um título',
          ),
          SizedBox(height: 16),

          _buildSectionHeader('Categoria'),
          _buildCategoryDropdown(),
          Divider(thickness: 2, height: 40),

          _buildSectionHeader('Imagens'),
          _buildImagePlaceholders(),
          Divider(thickness: 2, height: 40),

          _buildSectionHeader('Descrição'),
          _buildTextField(
            controller: _descricaoController,
            hint: 'Escreva uma descrição',
            maxLines: 4,
          ),
          Divider(thickness: 2, height: 40),

          _buildSectionHeader('Localização'),
          _buildTextField(
            controller: _localizacaoController,
            hint: 'Adicione a localização',
          ),
          SizedBox(height: 16),

          _buildSectionHeader('Selecione opções de entrega'),
          ..._buildDeliveryOptions(),
          Divider(thickness: 2, height: 40),

          _buildSectionHeader('Detalhes de Venda'),
          _buildSectionHeader('Quantidade mínima', fontSize: 14),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: _buildTextField(
                  controller: _quantidadeMinController,
                  hint: 'Quantidade mínima',
                ),
              ),
              SizedBox(width: 10),
              Expanded(flex: 1, child: _buildUnitDropdown()),
            ],
          ),
          SizedBox(height: 16),

          _buildSectionHeader('Preço', fontSize: 14),
          _buildPriceField(),
          Divider(thickness: 2, height: 40),

          _buildSectionHeader('Detalhes de Contacto'),
          _buildSectionHeader('Nome', fontSize: 14),
          _buildTextField(
            controller: _nomeController,
            hint: 'Introduza o seu nome',
          ),
          SizedBox(height: 16),

          _buildSectionHeader('Telefone', fontSize: 14),
          _buildTextField(
            controller: _telefoneController,
            hint: 'Introduza o telefone',
          ),
          SizedBox(height: 24),

          Center(
            child: Row(
              children: [
                Expanded(
                  child: ElevatedButton(
                    onPressed: _previewForm,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: Colors.blueAccent,
                    ),
                    child: Text(
                      'PRÉ-VISUALIZAR',
                      style: TextStyle(color: Colors.white),
                    ),
                  
                  ),
                ),
                SizedBox(width: 16),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _submitForm,
                    style: ElevatedButton.styleFrom(
                      padding: EdgeInsets.symmetric(vertical: 14),
                      backgroundColor: Colors.green,
                    ),
                    child: Text('CRIAR', style: TextStyle(color: Colors.white)),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _previewForm() {
    if (widget.formKey.currentState!.validate()) {
      widget.formKey.currentState!.save();
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Pré-visualização pronta!')));
    }
  }

  void _submitForm() {
    if (widget.formKey.currentState!.validate()) {
      widget.formKey.currentState!.save();

      final produto = Produtos(
        title: _tituloController.text,
        price: '€${_priceController.text}',
        image: _selectedImages[0]?.path ?? 'assets/images/placeholder.png',
        isAsset:
            _selectedImages[0] ==
            null, // true se for imagem de asset, false se for do dispositivo
        date:
            "Publicado em ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}",
        description: _descricaoController.text,
        stats: {
          'views': 0,
          'clicks': 0,
          'conversions': 0,
          'history': [0, 0, 0, 0, 0],
        },
      );

      Navigator.pop(context, produto); // <- ✅ Retorna para ProdutosSection
    }
  }

  Widget _buildSectionHeader(String text, {double fontSize = 16}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: TextStyle(fontWeight: FontWeight.bold, fontSize: fontSize),
      ),
    );
  }

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
  }) {
    return TextFormField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(hintText: hint, border: OutlineInputBorder()),
      validator: (value) => value?.isEmpty ?? true ? 'Campo obrigatório' : null,
    );
  }

  Widget _buildCategoryDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedCategory,
      hint: Text('Escolha uma categoria'),
      items:
          ['Vegetais','Frutas']
              .map(
                (category) =>
                    DropdownMenuItem(value: category, child: Text(category)),
              )
              .toList(),
      onChanged: (value) => setState(() => _selectedCategory = value),
      validator: (value) => value == null ? 'Selecione uma categoria' : null,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 12),
      ),
    );
  }

  Future<void> _pickImage(int index) async {
    final XFile? image = await _picker.pickImage(source: ImageSource.gallery);
    if (image != null) {
      setState(() {
        _selectedImages[index] = image;
      });
    }
  }

  Widget _buildImagePlaceholder(int index) {
    return GestureDetector(
      onTap: () => _pickImage(index),
      child: Container(
        width: 100,
        height: 100,
        decoration: BoxDecoration(
          color: Colors.grey[200],
          border: Border.all(color: Colors.grey),
        ),
        child:
            _selectedImages[index] != null
                ? Image.file(
                  File(_selectedImages[index]!.path),
                  fit: BoxFit.cover,
                )
                : Icon(Icons.add_a_photo, size: 40, color: Colors.grey[500]),
      ),
    );
  }

  Widget _buildImagePlaceholders() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(1, (index) => _buildImagePlaceholder(index)),
    );
  }

  List<Widget> _buildDeliveryOptions() {
    return List.generate(
      3,
      (index) => CheckboxListTile(
        contentPadding: EdgeInsets.zero,
        title: Text(_deliveryLabels[index]),
        value: _deliveryOptions[index],
        onChanged: (value) => setState(() => _deliveryOptions[index] = value!),
        controlAffinity: ListTileControlAffinity.leading,
      ),
    );
  }

  Widget _buildUnitDropdown() {
    return DropdownButtonFormField<String>(
      value: _selectedUnit,
      hint: Text('Unidade'),
      items:
          ['KG', 'Unidade']
              .map((unit) => DropdownMenuItem(value: unit, child: Text(unit)))
              .toList(),
      onChanged: (value) => setState(() => _selectedUnit = value),
      validator: (value) => value == null ? 'Selecione uma unidade' : null,
      decoration: InputDecoration(
        border: OutlineInputBorder(),
        contentPadding: EdgeInsets.symmetric(horizontal: 12),
      ),
    );
  }

  Widget _buildPriceField() {
    return TextFormField(
      controller: _priceController,
      decoration: InputDecoration(
        prefixIcon: Padding(
          padding: const EdgeInsets.only(left: 15, top: 15),
          child: Text('€', style: TextStyle(fontSize: 18)),
        ),
        hintText: '0.00',
        border: OutlineInputBorder(),
      ),
      keyboardType: TextInputType.numberWithOptions(decimal: true),
      validator: (value) {
        if (value?.isEmpty ?? true) return 'Preço obrigatório';
        if (double.tryParse(value!) == null) return 'Valor inválido';
        return null;
      },
    );
  }
}
