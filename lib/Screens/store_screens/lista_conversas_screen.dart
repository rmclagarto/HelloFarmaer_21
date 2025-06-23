import 'package:flutter/material.dart';
import 'package:projeto_cm/Core/constants.dart';
import 'package:projeto_cm/Model/conversa.dart';
import 'package:projeto_cm/Screens/store_screens/chat_screen.dart';

class ListaConversasScreen extends StatefulWidget {
  final List<Conversa> conversas;

  const ListaConversasScreen({super.key, required this.conversas});

  @override
  State<ListaConversasScreen> createState() => _ListaConversasScreenState();
}

class _ListaConversasScreenState extends State<ListaConversasScreen> {
  late List<Conversa> conversas;

  @override
  void initState() {
    super.initState();
    conversas = widget.conversas;
  }

  void novaMensagemRecebida(Conversa conversaAtualizada) {
    setState(() {
      final index = conversas.indexWhere((c) => c.id == conversaAtualizada.id);
      if (index != -1) {
        conversas[index] = conversaAtualizada;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Suporte ao Cliente',
          style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
        ),
        backgroundColor: Constants.primaryColor,
        centerTitle: true,

        iconTheme: const IconThemeData(color: Colors.white),
      ),
      body: ListView.builder(
        itemCount: conversas.length,
        itemBuilder: (context, index) {
          final conversa = conversas[index];
          final ultimaMensagem =
              conversa.messages.isNotEmpty
                  ? conversa.messages.last.text ?? 'Mensagem sem texto'
                  : 'Nenhuma mensagem';
          final temMensagemNova = conversa.unreadCount > 0;

          return Card(
            margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
            ),
            elevation: temMensagemNova ? 6 : 1,
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor:
                    temMensagemNova ? Colors.green : Colors.grey.shade400,
                child: Text(
                  conversa.title.isNotEmpty
                      ? conversa.title[0].toUpperCase()
                      : '?',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              title: Text(
                conversa.title,
                style: TextStyle(
                  fontWeight:
                      temMensagemNova ? FontWeight.bold : FontWeight.normal,
                  color: temMensagemNova ? Colors.black : Colors.grey.shade800,
                ),
              ),
              subtitle: Text(
                ultimaMensagem,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                  fontWeight:
                      temMensagemNova ? FontWeight.w600 : FontWeight.normal,
                  color:
                      temMensagemNova ? Colors.black87 : Colors.grey.shade600,
                ),
              ),
              trailing:
                  temMensagemNova
                      ? Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 10,
                          vertical: 6,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.red,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          conversa.unreadCount.toString(),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      )
                      : null,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => ChatScreen(conversa: conversa),
                  ),
                ).then((_) {
                  setState(() {
                    conversas[index] = conversa.copyWith(unreadCount: 0);
                  });
                });
              },
            ),
          );
        },
      ),
    );
  }
}
