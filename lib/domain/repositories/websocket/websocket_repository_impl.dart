import 'dart:async';

import 'package:invest_academy/domain/entities/websocket/websocket_connection.dart';
import 'package:invest_academy/domain/repositories/websocket/websocket_repository.dart';
import 'package:web_socket_channel/web_socket_channel.dart';

class WebSocketRepositoryImpl implements WebSocketRepository {
  WebSocketChannel? _channel;
  late final StreamController<dynamic> _messageController;

  WebSocketRepositoryImpl() {
    _messageController = StreamController<dynamic>.broadcast();
  }

  @override
  bool get isConnected => _channel != null;

  @override
  Future<void> connect(WebSocketConnection connection) async {
    _channel = WebSocketChannel.connect(Uri.parse(connection.url));
    sendMessage(connection.message);
    
    _channel!.stream.listen((message) {
      _messageController.add(message);
    });
  }

  @override
  Future<void> disconnect() async {
    await _channel?.sink.close();
    _channel = null;
  }

  @override
  void sendMessage(String message) {
    _channel?.sink.add(message);
  }

  @override
  Stream<dynamic> get messageStream => _messageController.stream;

  void dispose() {
    _messageController.close();
  }
}