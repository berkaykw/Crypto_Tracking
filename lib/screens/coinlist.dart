import 'package:crypto_tracking/models/walletProvider.dart';
import 'package:crypto_tracking/screens/portfolio.dart';
import 'package:crypto_tracking/screens/trade.dart';
import 'package:crypto_tracking/styles/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:crypto_tracking/services/coin_service.dart';
import 'package:crypto_tracking/models/coin_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';

class CoinList extends StatefulWidget {
  const CoinList({super.key});
  @override
  State<CoinList> createState() => _CoinListState();
}

class _CoinListState extends State<CoinList> {
  List<Coin> coins = [];
  bool isLoading = true;
  int _selectedIndex = 1;

  @override
  void initState() {
    super.initState();
    loadCoins();
  }

  void loadCoins() async {
    final data = await CoinService().fetchCoins();
    setState(() {
      coins = data;
      isLoading = false;
    });
  }

  void onItemTapped(int index) async {
    if (index != _selectedIndex) {
      setState(() {
        _selectedIndex = index;
      });
      if (index == 0) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => PortfolioPage()),
        );
      } else if (index == 1) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => CoinList()),
        );
      } else if (index == 2) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => TradeView()),
        );
      } else if (index == 3) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => TradeView()),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.only(
              bottomLeft: Radius.circular(30),
              bottomRight: Radius.circular(30),
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: Offset(0, 5),
              ),
            ],
          ),
          child: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: Padding(
              padding: EdgeInsets.only(left: 20),
              child: IconButton(
                icon: Icon(Icons.arrow_back_ios_new_outlined, size: 20,color: Colors.white),
                onPressed: () {},
              ),
            ),
            centerTitle: true,
            title: Text(
              'Coin Markets',
              style: TextStyle(
                fontFamily: FontStyles.fontFamily,
                fontSize: 20,
                color: Colors.white
              ),
            ),
          ),
        ),
      ),
      body:
          isLoading
              ? Center(child: CircularProgressIndicator())
              : ListView.builder(
                itemCount: coins.length,
                itemBuilder: (context, index) {
                  final coin = coins[index];
                  return Card(
                    elevation: 5,
                    color: Colors.white,
                    margin: EdgeInsets.all(12),
                    child: ListTile(
                      leading: Image.network(coin.image, width: 40),
                      title: Text(coin.name),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(coin.symbol.toUpperCase()),
                          Text('\$${coin.price.toStringAsFixed(2)}'),
                          SizedBox(
                            height: 60,
                            child: LineChart(
                              LineChartData(
                                gridData: FlGridData(show: false),
                                titlesData: FlTitlesData(show: false),
                                borderData: FlBorderData(show: false),
                                lineBarsData: [
                                  LineChartBarData(
                                    spots:
                                        coin.sparkline
                                            .asMap()
                                            .entries
                                            .map(
                                              (e) => FlSpot(
                                                e.key.toDouble(),
                                                e.value,
                                              ),
                                            )
                                            .toList(),
                                    isCurved: true,
                                    color: Colors.deepPurple[900],
                                    barWidth: 2,
                                    dotData: FlDotData(show: false),
                                    belowBarData: BarAreaData(show: false),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                      trailing: IconButton(
                        onPressed: () async {
                          final walletProvider = Provider.of<WalletProvider>(
                            context,
                            listen: false,
                          );

                          if (walletProvider.wallet.any(
                            (c) => c.name == coin.name,
                          )) {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Center(
                                  child: Text(
                                    '${coin.name} is already in your wallet!',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                backgroundColor: Colors.redAccent,
                                duration: Duration(seconds: 3),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                margin: EdgeInsets.only(
                                  bottom: 25,
                                  left: 10,
                                  right: 10,
                                ),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          } else {
                            walletProvider.addToWallet(coin);
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Center(
                                  child: Text(
                                    '${coin.name} added to wallet!',
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                                backgroundColor: Colors.greenAccent[400],
                                duration: Duration(seconds: 3),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                margin: EdgeInsets.only(
                                  bottom: 25,
                                  left: 10,
                                  right: 10,
                                ),
                                behavior: SnackBarBehavior.floating,
                              ),
                            );
                          }
                        },
                        icon: Icon(Icons.arrow_forward_ios),
                      ),
                    ),
                  );
                },
              ),
      bottomNavigationBar: Padding(
        padding: EdgeInsets.all(10.0),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
          decoration: BoxDecoration(
            color: Colors.black,
            borderRadius: BorderRadius.circular(30),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.2),
                blurRadius: 10,
                offset: Offset(0, -5),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(50),
            child: NavigationBarTheme(
              data: NavigationBarThemeData(
                indicatorColor: Color(0xFFB8E037),
                indicatorShape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(25),
                ),
                labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>((
                  Set<WidgetState> states,
                ) {
                  if (states.contains(WidgetState.selected)) {
                    return TextStyle(
                      color: Colors.white,
                      fontFamily: FontStyles.fontFamily,
                      fontSize: 12,
                    );
                  }
                  return TextStyle(
                    color: Colors.white,
                    fontFamily: FontStyles.fontFamily,
                    fontSize: 12,
                  );
                }),
              ),
              child: NavigationBar(
                height: 70,
                elevation: 0,
                backgroundColor: Colors.black,
                selectedIndex: _selectedIndex,
                onDestinationSelected: onItemTapped,
                labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
                destinations: [
                  NavigationDestination(
                    icon: Icon(
                      Icons.home_outlined,
                      color: _selectedIndex == 0 ? Colors.black : Colors.white,
                    ),
                    selectedIcon: Icon(Icons.home, color: Colors.black),
                    label: "Dashboard",
                  ),
                  NavigationDestination(
                    icon: Icon(
                      Icons.space_dashboard_outlined,
                      color: _selectedIndex == 1 ? Colors.black : Colors.white,
                    ),
                    selectedIcon: Icon(
                      Icons.space_dashboard_rounded,
                      color: Colors.black,
                    ),
                    label: "Markets",
                  ),
                  NavigationDestination(
                    icon: Icon(
                      Icons.swap_horiz,
                      color: _selectedIndex == 2 ? Colors.black : Colors.white,
                    ),
                    selectedIcon: Icon(Icons.swap_horiz, color: Colors.black),
                    label: "Trade",
                  ),
                  NavigationDestination(
                    icon: Icon(
                      Icons.person_outline,
                      color: _selectedIndex == 3 ? Colors.black : Colors.white,
                    ),
                    selectedIcon: Icon(Icons.person, color: Colors.black),
                    label: "Account",
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
