import 'package:flutter/material.dart';
import 'side_menu.dart'; // 👈 your SideMenu

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _scaleAnimation;
  late Animation<Offset> _slideAnimation;
  bool _isSideMenuOpen = false;

  // 👇 Track current page
  String _currentPage = "Home";

  @override
  void initState() {
    super.initState();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );

    _scaleAnimation =
        Tween<double>(begin: 1.0, end: 0.8).animate(_animationController);
    _slideAnimation =
        Tween<Offset>(begin: const Offset(-1, 0), end: Offset.zero)
            .animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void toggleMenu() {
    setState(() {
      _isSideMenuOpen = !_isSideMenuOpen;
      if (_isSideMenuOpen) {
        _animationController.forward();
      } else {
        _animationController.reverse();
      }
    });
  }

  void _onMenuSelected(String menuTitle) {
    setState(() {
      _currentPage = menuTitle;
      _isSideMenuOpen = false;
      _animationController.reverse();
    });
  }

  Widget _buildPageContent() {
    // ✅ Show back-to-home button on all pages except Home
    if (_currentPage == "Home") {
      return const Center(child: Text("🏠 Home Page"));
    }

    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            "📄 $_currentPage Page",
            style: const TextStyle(fontSize: 22),
          ),
          const SizedBox(height: 20),
          ElevatedButton.icon(
            onPressed: () => _onMenuSelected("Home"),
            icon: const Icon(Icons.home),
            label: const Text("Back to Home"),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black87,
      body: Stack(
        children: [
          // ✅ Side Menu with callback
          SlideTransition(
            position: _slideAnimation,
            child: SideMenu(
              onMenuSelected: _onMenuSelected,
              selectedMenu: '', // 👈 connect menu tap
            ),
          ),

          // ✅ Main Content
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            transform: Matrix4.translationValues(
              _isSideMenuOpen ? 250 : 0,
              0,
              0,
            ),
            child: ScaleTransition(
              scale: _scaleAnimation,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(_isSideMenuOpen ? 20 : 0),
                child: Scaffold(
                  appBar: AppBar(
                    title: Text(_currentPage),
                    leading: IconButton(
                      icon: const Icon(Icons.dashboard_customize_rounded),
                      onPressed: toggleMenu,
                    ),
                  ),
                  body: _buildPageContent(),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
