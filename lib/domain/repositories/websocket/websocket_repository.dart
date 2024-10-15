import 'package:invest_academy/domain/entities/websocket/websocket_connection.dart';

abstract class WebSocketRepository {
  bool get isConnected;
  Future<void> connect(WebSocketConnection connection);
  Future<void> disconnect();
  void sendMessage(String message);
  Stream<dynamic> get messageStream;
}