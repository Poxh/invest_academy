class StockTick {
  final double bidPrice;
  final double askPrice;
  final double openPrice;
  final DateTime timestamp;

  StockTick({
    required this.bidPrice,
    required this.askPrice,
    required this.openPrice,
    required this.timestamp,
  });

  factory StockTick.fromJson(Map<String, dynamic> json) {
    return StockTick(
      bidPrice: double.parse(json['bid']['price']),
      askPrice: double.parse(json['ask']['price']),
      openPrice: double.parse(json['open']['price']),
      timestamp: DateTime.fromMillisecondsSinceEpoch(json['last']['time']),
    );
  }
}