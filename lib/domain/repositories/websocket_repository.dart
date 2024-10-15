import 'package:invest_academy/domain/entities/websocket_connection.dart';

abstract class WebSocketRepository {
  Future<void> connect(WebSocketConnection connection);
  Future<void> disconnect();
  void sendMessage(String message);
  Stream<dynamic> get messageStream;
}