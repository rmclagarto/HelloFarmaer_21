import 'package:flutter/material.dart';
import 'package:projeto_cm/Core/constants.dart';
import 'package:projeto_cm/Screens/ad_screens/pre_ver_anuncio.dart';

class PublicarAnuncioScreen extends StatefulWidget {
  const PublicarAnuncioScreen({super.key});

  @override
  State<PublicarAnuncioScreen> createState() => _PublicarAnuncioScreenState();
}

class _PublicarAnuncioScreenState extends State<PublicarAnuncioScreen> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _tituloController = TextEditingController();
  final TextEditingController _descricaoController = TextEditingController();
  final TextEditingController _localizacaoController = TextEditingController();
  final TextEditingController _quantidadeController = TextEditingController();
  final TextEditingController _precoController = TextEditingController();
  final TextEditingController _telefoneController = TextEditingController();

  String? _selectedCategory;
  String? _selectedUnit;
  bool _deliveryByProducer = false;
  bool _deliveryByCarrier = false;

  final List<String> _categories = [
    'Frutas',
    'Legumes',
    'Carnes',
    'Laticínios',
  ];
  final List<String> _units = ['Kg', 'Unidade', 'Litro', 'Caixa'];

  void _publicarAnuncio() {
    // Implemente aqui a lógica para publicar o anúncio
    // Pode ser uma chamada à API ou salvar localmente

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Anúncio publicado com sucesso!'),
        duration: Duration(seconds: 2),
      ),
    );

    // Opcional: voltar para a tela anterior após publicar
    Navigator.pop(context);
  }



  @override
  void dispose(){
    _tituloController.dispose();
    _descricaoController.dispose();
    _telefoneController.dispose();
    _quantidadeController.dispose();
    _precoController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Container(
          width: double.infinity,
          alignment: Alignment.center,
          child: const Text(
            'Publicar Anúncio',
            style: TextStyle(color: Colors.white),
          ),
        ),
        backgroundColor: Constants.primaryColor,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Título
              _buildSectionTitle('Título'),
              TextFormField(
                controller: _tituloController,
                decoration: const InputDecoration(
                  hintText: 'Adicione um título',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira um título';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Categoria
              _buildSectionTitle('Categoria'),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Selecione uma categoria',
                ),
                value: _selectedCategory,
                items:
                    _categories.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedCategory = newValue;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, selecione uma categoria';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Imagens
              _buildSectionTitle('Imagens'),
              Row(
                children: [
                  _buildImagePlaceholder(),
                  const SizedBox(width: 10),
                  _buildImagePlaceholder(),
                  const SizedBox(width: 10),
                  _buildImagePlaceholder(),
                ],
              ),
              const SizedBox(height: 20),

              // Descrição
              _buildSectionTitle('Descrição'),
              TextFormField(
                controller: _descricaoController,
                maxLines: 4,
                decoration: const InputDecoration(
                  hintText: 'Escreva uma descrição',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira uma descrição';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Localização
              _buildSectionTitle('Localização'),
              TextFormField(
                controller: _localizacaoController,
                decoration: const InputDecoration(
                  hintText: 'Adicione a localização',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a localização';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Opções de entrega
              _buildSectionTitle('Selecione opções de entrega'),
              CheckboxListTile(
                title: const Text('Entrega Domicílio (Produtor)'),
                subtitle: const Text(
                  'Consumidor recolhe num local à sua escolha',
                ),
                value: _deliveryByProducer,
                onChanged: (bool? value) {
                  setState(() {
                    _deliveryByProducer = value ?? false;
                  });
                },
              ),
              CheckboxListTile(
                title: const Text('Entrega realizada por Transportadora'),
                value: _deliveryByCarrier,
                onChanged: (bool? value) {
                  setState(() {
                    _deliveryByCarrier = value ?? false;
                  });
                },
              ),
              const SizedBox(height: 20),

              // Detalhes de Venda
              _buildSectionTitle('Detalhes de Venda'),
              // Quantidade mínima
              _buildSectionSubtitle('Quantidade mínima'),
              TextFormField(
                controller: _quantidadeController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  hintText: 'Introduza a quantidade mínima de venda',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira a quantidade mínima';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),

              // Unidade de medida
              _buildSectionSubtitle('Selecione unidade de medida'),
              DropdownButtonFormField<String>(
                decoration: const InputDecoration(
                  border: OutlineInputBorder(),
                  hintText: 'Selecione a unidade',
                ),
                value: _selectedUnit,
                items:
                    _units.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                onChanged: (newValue) {
                  setState(() {
                    _selectedUnit = newValue;
                  });
                },
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, selecione uma unidade';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 10),

              // Preço
              _buildSectionSubtitle('Preço'),
              TextFormField(
                controller: _precoController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  prefixText: '€ ',
                  hintText: '0.00',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o preço';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 20),

              // Detalhes de Contacto
              _buildSectionTitle('Detalhes de Contacto'),
              // Nome
              const SizedBox(height: 10),

              // Telefone
              _buildSectionSubtitle('Telefone'),
              TextFormField(
                controller: _telefoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  hintText: 'Ex: 912 345 678',
                  border: OutlineInputBorder(),
                ),
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Por favor, insira o telefone';
                  }
                  return null;
                },
              ),

              const SizedBox(height: 30),

              // Botão Pré-visualizar
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      // Lógica para pré-visualizar
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PreviewAd(
                            nome: _tituloController.text,
                            descricao: _descricaoController.text,
                            localizacao: _localizacaoController.text,
                            telefone: _telefoneController.text,
                            quantidade: double.tryParse(_quantidadeController.text) ?? 0,
                            preco: double.tryParse(_precoController.text) ?? 0,
                            
                          ),
                        ),
                      );
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Constants.primaryColor,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'PRÉ-VISUALIZAR',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              // Botão Confirmar
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _publicarAnuncio();
                    }
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  child: const Text(
                    'CONFIRMAR E PUBLICAR',
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        title,
        style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
      ),
    );
  }

  Widget _buildSectionSubtitle(String subtitle) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Text(
        subtitle,
        style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500),
      ),
    );
  }

  Widget _buildImagePlaceholder() {
    return GestureDetector(
      onTap: () {
        // Lógica para adicionar imagem
      },
      child: Container(
        width: 80,
        height: 80,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.grey),
          borderRadius: BorderRadius.circular(8),
        ),
        child: const Icon(Icons.add, size: 30),
      ),
    );
  }
}
