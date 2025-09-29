import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart'; // import flutter_svg
import 'package:project_01/widgets/cartpage.dart';
import 'package:project_01/widgets/homewidget.dart';
import 'package:project_01/widgets/order.dart';
import 'package:project_01/widgets/profile.dart';

class Homepage extends StatefulWidget {
  @override
  _HomepageState createState() => _HomepageState();
}

class _HomepageState extends State<Homepage> {
  int _selectedIndex = 0;

  // Pages
  final List<Widget> _pages = [
    Homewidget(),
    CartPage(),
    OrdersPage(),
    ProfilePage(),
  ];

  // Labels
  final List<String> _labels = ["Home", "Cart", "Orders", "Profile"];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.black87,
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(30),
            topRight: Radius.circular(30),
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: List.generate(_labels.length, (index) {
            final isSelected = _selectedIndex == index;

            // ✅ Select either Icon or SVG
            Widget iconWidget;
            if (index == 1) {
              // Cart icon from SVG
              iconWidget = SvgPicture.asset(
                "assets/icons/conversation-svgrepo-com.svg",
                width: 24,
                height: 24,
                color: isSelected ? Colors.black : Colors.white,
              );
            } else if (index == 2) {
              // Orders icon from SVG
              iconWidget = SvgPicture.asset(
                "assets/icons/NO959h01.svg",
                width: 24,
                height: 24,
                color: isSelected ? Colors.black : Colors.white,
              );
            } else if (index == 0) {
              // Home as Material Icon
              iconWidget = Icon(
                Icons.home,
                color: isSelected ? Colors.black : Colors.white,
              );
            } else {
              // Profile as Material Icon
              iconWidget = Icon(
                Icons.person,
                color: isSelected ? Colors.black : Colors.white,
              );
            }

            return GestureDetector(
              onTap: () {
                setState(() {
                  _selectedIndex = index;
                });
              },
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 300),
                padding: const EdgeInsets.symmetric(
                  horizontal: 16,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.white : Colors.transparent,
                  borderRadius: BorderRadius.circular(30),
                ),
                child: Row(
                  children: [
                    iconWidget, // 👈 replaced with dynamic widget
                    if (isSelected) ...[
                      const SizedBox(width: 6),
                      Text(
                        _labels[index],
                        style: const TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            );
          }),
        ),
      ),
    );
  }
}
