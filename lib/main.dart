import 'package:flutter/material.dart';
import 'package:invest_academy/core/services/stock_tick_service.dart';
import 'package:invest_academy/domain/repositories/websocket/websocket_repository_impl.dart';
import 'package:invest_academy/domain/usecases/stock/subscribe_to_stock_tick.dart';
import 'package:invest_academy/domain/usecases/websocket/connect_websocket.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'InvestAcademy',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const ConnectionPage(),
    );
  }
}

class ConnectionPage extends StatefulWidget {
  const ConnectionPage({super.key});

  @override
  State<ConnectionPage> createState() => _ConnectionPageState();
}

class _ConnectionPageState extends State<ConnectionPage> {
  late WebSocketRepositoryImpl _webSocketRepository;
  late ConnectWebSocket _connectWebSocket;
  late SubscribeToStockTick _subscribeToStockTick;

  late StockTickService _stockTickService;

  bool _isConnected = false;
  bool _isLoading = false;

  Future<void> _connect() async {
    setState(() {
      _isLoading = true;
    });

    try {
      bool result = await _connectWebSocket.execute();
      setState(() {
        _isConnected = result;
        if (result) {
          _subscribeToStockTick.execute('XF000FET0011.BHS');
          _subscribeToStockTick.execute('XF000BTC0017.BHS');
        }
      });
    } catch (e) {
      // Handle any errors here
      print('Error connecting: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  void initState() {
    super.initState();
    _webSocketRepository = WebSocketRepositoryImpl();
    _connectWebSocket = ConnectWebSocket(_webSocketRepository);
    _stockTickService = StockTickService(_webSocketRepository);
    _subscribeToStockTick = SubscribeToStockTick(
        _webSocketRepository, _stockTickService.subscribedStockTicks);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('WebSocket Connection'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              _isConnected ? 'Connected' : 'Not Connected',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
                color: _isConnected ? Colors.green : Colors.red,
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _isConnected || _isLoading ? null : _connect,
              style: ElevatedButton.styleFrom(
                backgroundColor: _isConnected || _isLoading
                    ? Colors.grey[300]
                    : Theme.of(context).primaryColor,
                foregroundColor: _isConnected || _isLoading
                    ? Colors.grey[600]
                    : Colors.white,
                disabledBackgroundColor: Colors.grey[300],
                disabledForegroundColor: Colors.grey[600],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (_isConnected || _isLoading)
                    Icon(Icons.lock, size: 16, color: Colors.grey[600]),
                  SizedBox(width: 8),
                  _isLoading
                      ? CircularProgressIndicator(color: Colors.grey[600])
                      : Text('Connect to WebSocket'),
                ],
              ),
            ),
            SizedBox(height: 20),
            _isConnected
                ? Column(
                    children:
                        _stockTickService.subscribedStockTicks.map((stockId) {
                      final stockTickId = _stockTickService.subscribedStockTicks
                              .indexOf(stockId) +
                          1;
                      return StreamBuilder(
                        stream: _stockTickService.tickStream(stockTickId),
                        builder: (context, snapshot) {
                          if (snapshot.hasData) {
                            final stockTick = snapshot.data!;
                            return Column(
                              children: [
                                Text('Bid Price: ${stockTick.bidPrice}'),
                                Text('Ask Price: ${stockTick.askPrice}'),
                                Text('Open Price: ${stockTick.openPrice}'),
                                Text('Timestamp: ${stockTick.timestamp}'),
                              ],
                            );
                          } else if (snapshot.hasError) {
                            return Text('Error: ${snapshot.error}');
                          } else {
                            return CircularProgressIndicator();
                          }
                        },
                      );
                    }).toList(),
                  )
                : SizedBox(),
          ],
        ),
      ),
    );
  }
}
