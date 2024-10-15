import 'package:web_socket_channel/web_socket_channel.dart';
import 'package:invest_academy/domain/entities/websocket_connection.dart';
import 'package:invest_academy/domain/repositories/websocket_repository.dart';

class WebSocketRepositoryImpl implements WebSocketRepository {
  WebSocketChannel? _channel;

  @override
  Future<void> connect(WebSocketConnection connection) async {
    _channel = WebSocketChannel.connect(Uri.parse(connection.url));
    _channel?.sink.add(connection.message);
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
  Stream<dynamic> get messageStream => _channel?.stream ?? const Stream.empty();
}
