import 'package:flutter/material.dart';
import 'package:crypto_tracking/models/coin_model.dart';

class WalletProvider extends ChangeNotifier {
  List<Coin> _wallet = [];

  List<Coin> get wallet => _wallet;

  void addToWallet(Coin coin) {
    _wallet.add(coin);
    notifyListeners(); 
  }

  void removeFromWallet(Coin coin) {
    _wallet.remove(coin);
    notifyListeners();
  }
}
