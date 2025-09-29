import 'package:flutter/material.dart';
import 'homewidget.dart'; // 👈 import your Homewidget screen

class MenuItemModel {
  final String title;
  final IconData icon;

  MenuItemModel({required this.title, required this.icon});

  static List<MenuItemModel> menuItems = [
    MenuItemModel(title: "Home", icon: Icons.home),
    MenuItemModel(title: "Search", icon: Icons.search),
    MenuItemModel(title: "Favorites", icon: Icons.favorite),
    MenuItemModel(title: "Profile", icon: Icons.person),
    MenuItemModel(title: "History", icon: Icons.history),
  ];
}

class SideMenu extends StatefulWidget {
  final Function(String menuTitle)? onMenuSelected;
  final String selectedMenu;

  const SideMenu({
    super.key,
    this.onMenuSelected,
    required this.selectedMenu,
  });

  @override
  State<SideMenu> createState() => _SideMenuState();
}

class _SideMenuState extends State<SideMenu> {
  late String _selectedMenu;

  @override
  void initState() {
    super.initState();
    _selectedMenu = widget.selectedMenu;
  }

  void onMenuPress(MenuItemModel menu) {
    setState(() {
      _selectedMenu = menu.title;
    });
    widget.onMenuSelected?.call(menu.title);
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 250,
      color: Colors.blueGrey[900],
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // ✅ Drawer Header with Back Button
          DrawerHeader(
            child: Row(
              children: [
                IconButton(
                  icon: const Icon(Icons.arrow_back, color: Colors.white),
                  onPressed: () {
                    // 👇 Navigate directly to Homewidget
                    Navigator.pushAndRemoveUntil(
                      context,
                      MaterialPageRoute(
                          builder: (context) => const Homewidget()),
                      (route) => false, // clear back stack
                    );
                  },
                ),
                const SizedBox(width: 8),
                const CircleAvatar(
                  radius: 24,
                  backgroundColor: Colors.white,
                  child: Icon(Icons.person, color: Colors.black),
                ),
                const SizedBox(width: 12),
                const Text(
                  "Ashraf",
                  style: TextStyle(color: Colors.white, fontSize: 18),
                ),
              ],
            ),
          ),

          // ✅ Menu Items
          Expanded(
            child: ListView(
              children: MenuItemModel.menuItems.map((menu) {
                return ListTile(
                  leading: Icon(menu.icon, color: Colors.white),
                  title: Text(
                    menu.title,
                    style: TextStyle(
                      color: _selectedMenu == menu.title
                          ? Colors.greenAccent
                          : Colors.white,
                    ),
                  ),
                  onTap: () => onMenuPress(menu),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}
