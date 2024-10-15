import 'package:invest_academy/domain/entities/websocket_connection.dart';
import 'package:invest_academy/domain/repositories/websocket_repository_impl.dart';
import 'package:logger/web.dart';

class ConnectWebSocket {
  var logger = Logger(printer: PrettyPrinter());

  Future<bool> execute() async {
    final repository = WebSocketRepositoryImpl();
    final connection = WebSocketConnection(
      url: 'wss://api.traderepublic.com',
      message: 'connect 31 {"locale":"de","platformId":"webtrading","platformVersion":"chrome - 129.0.0","clientId":"app.traderepublic.com","clientVersion":"3.109.1"}',
    );
    await repository.connect(connection);

    String response = await repository.messageStream.first;
    logger.i('Response: $response');
    return response == 'connected';
  }
}