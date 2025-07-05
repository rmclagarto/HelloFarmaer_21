import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';

final FlutterLocalNotificationsPlugin notifications = 
    FlutterLocalNotificationsPlugin();

Future<void> initNotifications() async {
  const AndroidInitializationSettings androidSettings = 
      AndroidInitializationSettings('@mipmap/ic_launcher');
  
  await notifications.initialize(
    const InitializationSettings(android: androidSettings),
  );
}

Future<void> mostrarNotificacao(String mensagem, BuildContext context) async {
  // Criação do canal de notificação
  const AndroidNotificationChannel channel = AndroidNotificationChannel(
    'pedidos_channel',
    'Notificações de Pedido',
    importance: Importance.max,
    playSound: true,
  );

  await notifications
      .resolvePlatformSpecificImplementation<
          AndroidFlutterLocalNotificationsPlugin>()
      ?.createNotificationChannel(channel);

  // Configuração da notificação
  const AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
    'pedidos_channel',
    'Notificações de Pedido',
    channelDescription: 'Notificações sobre status de pedidos',
    importance: Importance.max,
    priority: Priority.high,
    playSound: true,
  );

  const NotificationDetails platformDetails = NotificationDetails(
    android: androidDetails,
  );

  try {
    await notifications.show(
      DateTime.now().millisecondsSinceEpoch ~/ 1000,
      'Pedido Confirmado',
      'Código: $mensagem',
      platformDetails,
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

// Nova versão da função de permissões
Future<void> solicitarPermissoesNotificacoes() async {
  try {
    final androidPlugin = notifications.resolvePlatformSpecificImplementation<
      AndroidFlutterLocalNotificationsPlugin>();
    
    if (androidPlugin != null) {
      // Verifica se as notificações estão habilitadas
      final bool? enabled = await androidPlugin.areNotificationsEnabled();
      
      if (enabled == false) {
        // Solicita permissão (método disponível a partir da versão 13+)
        await androidPlugin.requestNotificationsPermission();
      }
    }
  } catch (e) {
    debugPrint('Erro ao solicitar permissões: $e');
  }
}