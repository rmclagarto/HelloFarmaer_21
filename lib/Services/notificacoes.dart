import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin _notificacoes = FlutterLocalNotificationsPlugin();


// Inicializa o sistema de notificações locais
Future<void> inicializarNotificacoes() async {
  const AndroidInitializationSettings definicoesAndroid = 
      AndroidInitializationSettings('@mipmap/ic_launcher');
  
  await _notificacoes.initialize(
    const InitializationSettings(android: definicoesAndroid),
  );
}

// Mostra uma notificação com uma determinada mensagem.
Future<void> mostrarNotificacao(String mensagem, BuildContext context) async {
  const AndroidNotificationChannel canal = AndroidNotificationChannel(
    'canal_pedidos',
    'Notificações de Pedido',
    importance: Importance.max,
    playSound: true,
  );

  // Cria o canal, se ainda não existir
  await _notificacoes
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(canal);

  // Configuração da notificação
  const AndroidNotificationDetails detalhesAndroid = AndroidNotificationDetails(
    'canal_pedidos',
    'Notificações de Pedido',
    channelDescription: 'Notificações sobre status de pedidos',
    importance: Importance.max,
    priority: Priority.high,
    playSound: true,
  );

  const NotificationDetails detalhesNotificacao = NotificationDetails(
    android: detalhesAndroid,
  );

  try {
    await _notificacoes.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      'Pedido Confirmado',
      'Código: $mensagem',
      detalhesNotificacao,
    );
  } catch (e) {
    debugPrint('Erro ao mostrar notificação: $e');
    if (context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Erro ao enviar notificação: ${e.toString()}')),
      );
    }
  }
}

// Solicita permissões para mostrar notificações.
Future<void> solicitarPermissoesNotificacoes() async {
  try {
    final androidPlugin = _notificacoes.resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>();
    
    if (androidPlugin != null) {
      // Verifica se as notificações estão habilitadas
      final bool? estaAtivo = await androidPlugin.areNotificationsEnabled();
      
      if (estaAtivo == false) {
        // Solicita permissão
        await androidPlugin.requestNotificationsPermission();
      }
    }
  } catch (e) {
    debugPrint('Erro ao solicitar permissões: $e');
  }
}
