import 'dart:async';
import 'dart:convert';

import 'package:invest_academy/domain/entities/stock/stock_tick.dart';
import 'package:invest_academy/domain/repositories/websocket/websocket_repository.dart';
import 'package:logger/web.dart';

class StockTickService {
  final WebSocketRepository _repository;
  final logger = Logger(printer: PrettyPrinter());
  late final StreamSubscription _subscription;

  final List<String> _subscribedStockTicks = [];
  final Map<int, StreamController<StockTick>> _tickControllers = {};

  StockTickService(this._repository) {
    _subscription = _repository.messageStream.listen(_handleMessage);
  }

  Stream<StockTick> tickStream(int stockTickId) {
    return _tickControllers.putIfAbsent(stockTickId, () => StreamController<StockTick>.broadcast()).stream;
  }

  void _handleMessage(dynamic message) {
    if (message is String) {
      final match = RegExp(r'^(\d+) A').firstMatch(message);
      if (match != null) {
        final stockTickId = int.parse(match.group(1)!);
        final jsonStr = message.substring(message.indexOf('{'));
        final json = jsonDecode(jsonStr);
        final tick = StockTick.fromJson(json);
        _tickControllers[stockTickId]?.add(tick);
      }
    }
  }

  void dispose() {
    _subscription.cancel();
    for (var controller in _tickControllers.values) {
      controller.close();
    }
    _tickControllers.clear();
  }

  List<String> get subscribedStockTicks => _subscribedStockTicks;
}