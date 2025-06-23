import 'package:projeto_cm/Model/menssagens.dart';

class Conversa {
  final String id;
  final String title;
  final List<Message> messages;
  final int unreadCount;

  Conversa({
    required this.id,
    required this.title,
    required this.messages,
    this.unreadCount = 0,
  });

  Conversa copyWith({
    String? id,
    String? title,
    List<Message>? messages,
    int? unreadCount,
  }) {
    return Conversa(
      id: id ?? this.id,
      title: title ?? this.title,
      messages: messages ?? this.messages,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }
}
