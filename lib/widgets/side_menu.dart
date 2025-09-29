import 'package:flutter/material.dart';
import 'package:project_01/pages/login_pages/login.dart';
import 'homewidget.dart'; // 👈 import your Homewidget screen
import 'package:supabase_flutter/supabase_flutter.dart';

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
  final String userName; // ✅ added

  const SideMenu({
    super.key,
    this.onMenuSelected,
    required this.selectedMenu,
    required this.userName,
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

  Future<void> _logout() async {
    await Supabase.instance.client.auth.signOut();
    if (mounted) {
      Navigator.pushAndRemoveUntil(
        context,
        MaterialPageRoute(builder: (context) => const PhoneLoginScreen()),
        (route) => false,
      );
    }
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
                Expanded(
                  child: Text(
                    widget.userName, // ✅ dynamic name from Supabase
                    style: const TextStyle(
                      color: Colors.white,
                      fontSize: 18,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ),
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

          // ✅ Logout button at bottom
          ListTile(
            leading: const Icon(Icons.logout, color: Colors.redAccent),
            title: const Text(
              "Logout",
              style: TextStyle(color: Colors.redAccent),
            ),
            onTap: _logout,
          ),
        ],
      ),
    );
  }
}
