import 'package:invest_academy/domain/entities/websocket/websocket_connection.dart';
import 'package:invest_academy/domain/repositories/websocket/websocket_repository.dart';
import 'package:logger/web.dart';

class ConnectWebSocket {
  final WebSocketRepository _repository;
  final logger = Logger(printer: PrettyPrinter());

  ConnectWebSocket(this._repository);

  Future<bool> execute() async {
    final connection = WebSocketConnection(
      url: 'wss://api.traderepublic.com',
      message: 'connect 31 {"locale":"de","platformId":"webtrading","platformVersion":"chrome - 129.0.0","clientId":"app.traderepublic.com","clientVersion":"3.109.1"}',
    );

    if (!_repository.isConnected) {
      await _repository.connect(connection);
    }

    String response = await _repository.messageStream.first;
    return response == 'connected';
  }
}