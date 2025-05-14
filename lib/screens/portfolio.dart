import 'package:crypto_tracking/models/walletProvider.dart';
import 'package:crypto_tracking/screens/coinlist.dart';
import 'package:crypto_tracking/screens/trade.dart';
import 'package:crypto_tracking/styles/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:crypto_tracking/services/coin_service.dart';
import 'package:crypto_tracking/models/coin_model.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:provider/provider.dart';

class PortfolioPage extends StatefulWidget {
  const PortfolioPage({super.key});

  @override
  State<PortfolioPage> createState() => _PortfolioPageState();
}

class _PortfolioPageState extends State<PortfolioPage> {
  List<Coin> coins = [];
  bool isLoading = true;
  int _selectedIndex = 0;

  final List<Widget> navigationBarScreens = [
    PortfolioPage(),
    CoinList(),
    TradeView(),
    TradeView(),
  ];

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
  void initState() {
    super.initState();
    loadCoins();
  }

  void loadCoins() async {
    // Bu fonksiyon, coin verilerini alır.
    await CoinService().fetchCoins();
    setState(() {
      isLoading = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    final wallet = Provider.of<WalletProvider>(context).wallet;
    return Scaffold(
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 60, left: 20, right: 20),
            child: Row(
              children: [
                Container(
                  width: 60,
                  height: 60,
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey[900]!, width: 3.0),
                  ),
                  child: CircleAvatar(
                    backgroundImage: NetworkImage(
                      'https://i.pinimg.com/564x/36/1b/21/361b2137a421f76b013d0c4ea6d5d5ca.jpg',
                    ),
                  ),
                ),
                SizedBox(width: 10),
                Text(
                  "Olivia O'Connell",
                  style: TextStyle(
                    fontFamily: FontStyles.fontFamily,
                    fontSize: 20,
                    color: Colors.black,
                  ),
                ),
                Spacer(),
                Icon(Icons.api_rounded, size: 28),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 25.0, top: 25.0),
            child: Text(
              "Total Balance",
              style: TextStyle(
                fontFamily: FontStyles.fontFamily,
                fontSize: 16,
                color: Colors.black45,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 25.0),
            child: Row(
              children: [
                Text(
                  "\$597,866.34",
                  style: TextStyle(
                    fontFamily: FontStyles.fontFamily,
                    fontSize: 26,
                    color: Colors.black,
                  ),
                ),
                SizedBox(width: 10),
                Text(
                  "USD",
                  style: TextStyle(
                    fontFamily: FontStyles.fontFamily,
                    fontWeight: FontWeight.bold,
                    fontSize: 15,
                    color: Colors.black54,
                  ),
                ),
                Icon(
                  Icons.keyboard_arrow_down,
                  size: 18,
                  color: Colors.black54,
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 25.0, top: 10.0),
            child: Container(
              width: 150,
              height: 35,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(20),
                color: Color.fromARGB(255, 184, 224, 55),
              ),
              child: Padding(
                padding: EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Icon(Icons.trending_up, size: 20),
                    Text(
                      " 4,512.50",
                      style: TextStyle(
                        fontFamily: FontStyles.fontFamily,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      " (13.78%)",
                      style: TextStyle(fontFamily: FontStyles.fontFamily),
                    ),
                  ],
                ),
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(left: 25.0, top: 35.0, right: 25.0),
            child: Row(
              children: [
                Text(
                  "Wallet",
                  style: TextStyle(
                    fontSize: 20,
                    fontFamily: FontStyles.fontFamily,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Spacer(),
                Text(
                  "Edit",
                  style: TextStyle(
                    color: Colors.black45,
                    fontSize: 15,
                    fontFamily: FontStyles.fontFamily,
                  ),
                ),
              ],
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.black,
                borderRadius: BorderRadius.circular(25),
              ),
              width: 400,
              height: 250,
              child:
                  wallet.isEmpty
                      ? Center(
                        child: Text(
                          "Your wallet is empty",
                          style: TextStyle(
                            color: Colors.white,
                            fontFamily: FontStyles.fontFamily,
                          ),
                        ),
                      )
                      : ListView.builder(
                        physics: BouncingScrollPhysics(),
                        scrollDirection: Axis.horizontal,
                        itemCount: wallet.length,
                        itemBuilder: (context, index) {
                          final coin = wallet[index];
                          return Padding(
                            padding: EdgeInsets.all(15.0),
                            child: Card(
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: Container(
                                width: 250,
                                padding: EdgeInsets.all(15),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Image.network(
                                          coin.image,
                                          width: 40,
                                          height: 40,
                                          fit: BoxFit.cover,
                                        ),
                                        SizedBox(width: 10),
                                        Text(
                                          coin.name,
                                          style: TextStyle(
                                            fontFamily: FontStyles.fontFamily,
                                            fontSize: 16,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        Spacer(),
                                        IconButton(
                                          onPressed: () {
                                            Provider.of<WalletProvider>(
                                              context,
                                              listen: false,
                                            ).removeFromWallet(coin);
                                            ScaffoldMessenger.of(
                                              context,
                                            ).showSnackBar(
                                              SnackBar(
                                                content: Center(
                                                  child: Text(
                                                    '${coin.name} removed from wallet!',
                                                    style: TextStyle(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                ),
                                                backgroundColor:
                                                    Colors.redAccent,
                                                duration: Duration(seconds: 3),
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(20),
                                                ),
                                                margin: EdgeInsets.only(
                                                  bottom: 25,
                                                  left: 10,
                                                  right: 10,
                                                ),
                                                behavior:
                                                    SnackBarBehavior.floating,
                                              ),
                                            );
                                          },
                                          icon: Icon(
                                            Icons.delete_outline_rounded,
                                          ),
                                          color: Colors.red,
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: 10),
                                    Text(
                                      '\$${coin.price.toStringAsFixed(2)}',
                                      style: TextStyle(
                                        fontFamily: FontStyles.fontFamily,
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(height: 2),
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
                                              belowBarData: BarAreaData(
                                                show: false,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
              left: MediaQuery.of(context).size.width / 2.6,
              top: 15.0,
            ),
            child: Text(
              "Wallet ID",
              style: TextStyle(
                fontSize: 20,
                fontFamily: FontStyles.fontFamily,
                fontWeight: FontWeight.bold,
                color: Colors.black,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.all(10.0),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(15.0),
                color: Colors.indigo[200],
              ),
              width: MediaQuery.of(context).size.width,
              height: 50,
              child: Center(
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                  "3FZbgi12pdGjwV38eynkL-4dktZc5",
                  style: TextStyle(
                    fontFamily: FontStyles.fontFamily,
                    fontSize: 18,
                  ),
                ),
                IconButton(onPressed: () {}, icon: Icon(Icons.copy,color: Colors.black))
                  ],
                ),
              ),
            ),
          ),
        ],
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
