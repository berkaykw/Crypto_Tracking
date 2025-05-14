import 'package:crypto_tracking/styles/text_styles.dart';
import 'package:flutter/material.dart';
import 'package:crypto_tracking/screens/coinlist.dart';
import 'package:crypto_tracking/screens/portfolio.dart';

class TradeView extends StatefulWidget {
  const TradeView({super.key});

  @override
  State<TradeView> createState() => _TradeViewState();
}

class _TradeViewState extends State<TradeView> {
  int _selectedIndex = 2;

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
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
         
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
