class Coin {
  final String name;
  final String symbol;
  final String image;
  final double price;
  final List<double> sparkline;

  Coin({
    required this.name,
    required this.symbol,
    required this.image,
    required this.price,
    required this.sparkline,
  });

  factory Coin.fromJson(Map<String, dynamic> json) {
    return Coin(
      name: json['name'],
      symbol: json['symbol'],
      image: json['image'],
      price: json['current_price'].toDouble(),
      sparkline: List<double>.from(json['sparkline_in_7d']['price']),
    );
  }

}