import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:crypto_tracking/models/coin_model.dart';

class CoinService {
  Future<List<Coin>> fetchCoins() async {
    final url = Uri.parse("https://api.coingecko.com/api/v3/coins/markets?vs_currency=usd&sparkline=true");

    final response = await http.get(url);

    if(response.statusCode ==200) {
      final List data = jsonDecode(response.body);
      return data.map((json) => Coin.fromJson(json)).toList();
    }
    else {
      throw Exception("Failed to load coins");
    }
  }
}