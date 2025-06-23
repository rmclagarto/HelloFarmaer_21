import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:projeto_cm/Core/constants.dart';
import 'package:projeto_cm/Model/conversa.dart';
import 'package:projeto_cm/Model/menssagens.dart';
import 'package:projeto_cm/Screens/store_screens/full_screen_imagem_screen.dart';


class ChatScreen extends StatefulWidget {
  final Conversa conversa;

  const ChatScreen({super.key, required this.conversa});

  @override
  State<ChatScreen> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  late List<Message> messages;
  final TextEditingController _controller = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final ImagePicker _picker = ImagePicker();
  

  @override
  void initState() {
    super.initState();
    messages = List.from(widget.conversa.messages);
  }

  void _enviarMensagem() {
    final texto = _controller.text.trim();
    if (texto.isEmpty) return;

    final novaMensagem = Message(
      sender: 'Você',
      text: texto,
      time: DateTime.now(),
      imagePath: null,
    );

    setState(() {
      messages.add(novaMensagem);
      _controller.clear();
    });

    _scrollToBottom();
  }

  Future<void> _enviarImagem() async {
    final XFile? imagemSelecionada =
        await _picker.pickImage(source: ImageSource.gallery);
    if (imagemSelecionada == null) return;

    final novaMensagem = Message(
      sender: 'Você',
      text: null,
      time: DateTime.now(),
      imagePath: imagemSelecionada.path,
    );

    setState(() {
      messages.add(novaMensagem);
    });

    _scrollToBottom();
  }

  void _scrollToBottom() {
    Future.delayed(const Duration(milliseconds: 100), () {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.conversa.title, style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        )),
        backgroundColor: Constants.primaryColor,
        centerTitle: true,
        iconTheme: const IconThemeData(color: Colors.white),

      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              itemCount: messages.length,
              itemBuilder: (context, index) {
                final msg = messages[index];
                final isMe = msg.sender == 'Você';

                return Container(
                  alignment: isMe ? Alignment.centerRight : Alignment.centerLeft,
                  padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                  child: Container(
                    decoration: BoxDecoration(
                      // color:  Colors.grey.shade300,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: msg.imagePath != null
                        ? GestureDetector(
                            onTap: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) => FullscreenImageScreen(imagePath: msg.imagePath!),
                                ),
                              );
                            },
                            child: ClipRRect(
                              borderRadius: BorderRadius.circular(12),
                              child: Image.file(
                                File(msg.imagePath!),
                                width: 200,
                                height: 200,
                                fit: BoxFit.cover,
                              ),
                            ),
                          )
                        : Text(
                            msg.text ?? '',
                            style: TextStyle(
                              color:  Colors.black87,
                              fontSize: 16,
                            ),
                          ),
                  ),
                );
              },
            ),
          ),
          const Divider(height: 1),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.photo),
                  color: Colors.blueAccent,
                  onPressed: _enviarImagem,
                ),
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(
                      hintText: 'Digite sua mensagem',
                      border: InputBorder.none,
                    ),
                    onSubmitted: (_) => _enviarMensagem(),
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  color: Colors.blueAccent,
                  onPressed: _enviarMensagem,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
