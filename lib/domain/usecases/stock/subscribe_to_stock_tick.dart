import 'package:invest_academy/domain/repositories/websocket/websocket_repository.dart';
import 'package:logger/web.dart';

class SubscribeToStockTick {
  final WebSocketRepository _repository;
  final List<String> _subscribedStockTicks;

  int _lastSubMessageId = 0;
  final List<int> _subMessages = [];

  SubscribeToStockTick(this._repository, this._subscribedStockTicks);

  var logger = Logger(printer: PrettyPrinter());

  void execute(String stockId) {
    _lastSubMessageId++;
    final message = 'sub $_lastSubMessageId {"type":"ticker","id":"$stockId"}';
    _repository.sendMessage(message);
    _subMessages.add(_lastSubMessageId);
    _subscribedStockTicks.add(stockId);
  }
}