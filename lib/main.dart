import 'package:flutter/material.dart';
import 'package:invest_academy/domain/usecases/connect_websocket.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);

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
  const ConnectionPage({Key? key}) : super(key: key);

  @override
  State<ConnectionPage> createState() => _ConnectionPageState();
}

class _ConnectionPageState extends State<ConnectionPage> {
  final ConnectWebSocket _connectWebSocket = ConnectWebSocket();
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
            )
          ],
        ),
      ),
    );
  }
}
