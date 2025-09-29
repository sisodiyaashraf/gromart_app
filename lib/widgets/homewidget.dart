import 'dart:async';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:gif/gif.dart';
import 'package:project_01/models/categories.dart';
import 'package:project_01/models/product.dart';
import 'package:project_01/pages/product_list_screen.dart';
import 'package:project_01/screens/chat_screen.dart';
import 'package:project_01/widgets/SearchResultsPage.dart';
import 'package:project_01/widgets/SeeAllCategoriesPage.dart';
import 'package:project_01/widgets/searchbar.dart';
import 'package:project_01/widgets/tabbar.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'side_menu.dart';

class Homewidget extends StatefulWidget {
  const Homewidget({super.key});

  @override
  State<Homewidget> createState() => _HomewidgetState();
}

class _HomewidgetState extends State<Homewidget> with TickerProviderStateMixin {
  final List<CategoryModel> categories = CategoryModel.getCategories();
  final List<ProductModel> product = ProductModel.getProducts();

  final List<String> imgList = [
    "assets/images/sale.png",
    "assets/images/Screenshot3.png",
    "assets/images/Screenshot2.png",
    "assets/images/Screenshot41.png",
    "assets/images/Screenshot3.png",
  ];

  GifController? _gifController;
  bool _isMenuOpen = false;
  String _searchQuery = "";

  // ✅ Logged in user
  String _userName = "Guest";

  @override
  void initState() {
    super.initState();
    _gifController = GifController(vsync: this);

    _loadUser(); // load supabase user

    Timer.periodic(const Duration(seconds: 5), (_) {
      if (mounted && _gifController != null) {
        _gifController!.reset();
        _gifController!.forward();
      }
    });
  }

  Future<void> _loadUser() async {
    final user = Supabase.instance.client.auth.currentUser;
    if (user != null) {
      setState(() {
        _userName = user.userMetadata?['name'] ?? "Guest";
      });
    }
  }

  @override
  void dispose() {
    _gifController?.dispose();
    super.dispose();
  }

  void _onMenuSelected(String menuTitle) {
    setState(() {
      _isMenuOpen = false;
    });
  }

  // 👉 Navigate to results page
  void _navigateToSearch(String query) {
    if (query.isEmpty) return;
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SearchResultsPage(
          query: query,
          products: product,
        ),
      ),
    );
  }

  // 👉 Live typing update
  void _updateTyping(String query) {
    setState(() {
      _searchQuery = query;
    });
  }

  // 👉 Suggestions list
  Widget _buildSuggestions(String query) {
    if (query.isEmpty) return const SizedBox.shrink();

    final results = product.where((p) {
      return p.name.toLowerCase().contains(query.toLowerCase());
    }).toList();

    return results.isEmpty
        ? const Padding(
            padding: EdgeInsets.all(16),
            child: Text("No suggestions found"),
          )
        : ListView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: results.length,
            itemBuilder: (context, index) {
              final item = results[index];
              return ListTile(
                leading: Image.asset(item.image, width: 40, height: 40),
                title: Text(item.name),
                subtitle: Text("\$${item.price}"),
                onTap: () => _navigateToSearch(item.name),
              );
            },
          );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AnimatedPositioned(
            duration: const Duration(milliseconds: 300),
            left: _isMenuOpen ? 0 : -250,
            top: 0,
            bottom: 0,
            child: SideMenu(
              onMenuSelected: _onMenuSelected,
              selectedMenu: '',
              userName: _userName, // ✅ Pass username to side menu
            ),
          ),
          AnimatedContainer(
            duration: const Duration(milliseconds: 300),
            transform: Matrix4.translationValues(_isMenuOpen ? 220 : 0, 0, 0)
              ..scale(_isMenuOpen ? 0.9 : 1.0),
            child: AbsorbPointer(
              absorbing: _isMenuOpen,
              child: Scaffold(
                appBar: AppBar(
                  backgroundColor: Colors.white,
                  elevation: 0,
                  toolbarHeight: 90,
                  leading: IconButton(
                    icon: const Icon(Icons.sort, color: Colors.black87),
                    onPressed: () {
                      setState(() => _isMenuOpen = !_isMenuOpen);
                    },
                  ),
                  title: Text(
                    "Welcome, $_userName 👋",
                    style: const TextStyle(color: Colors.black87),
                  ),
                  actions: [
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const ChatScreen()),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: _gifController == null
                            ? const SizedBox.shrink()
                            : Gif(
                                controller: _gifController!,
                                autostart: Autostart.no,
                                image:
                                    const AssetImage("assets/images/robot.gif"),
                                height: 45,
                                width: 45,
                              ),
                      ),
                    ),
                  ],
                ),
                body: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SearchSection(
                        onSearch: _navigateToSearch,
                        onTyping: _updateTyping,
                      ),
                      _buildSuggestions(_searchQuery),
                      const SizedBox(height: 10),
                      content(),
                      const SizedBox(height: 10),
                      content2(),
                      const SizedBox(height: 7),
                      const CustomTabs(),
                      const SizedBox(height: 7),
                      const Padding(
                        padding:
                            EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                        child: Text(
                          "Products",
                          style: TextStyle(
                              fontSize: 22, fontWeight: FontWeight.w600),
                        ),
                      ),
                      ProductList(products: product),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget content() {
    return CarouselSlider(
      items: imgList.map((item) {
        return Container(
          margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 5),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(13),
            image: DecorationImage(image: AssetImage(item), fit: BoxFit.cover),
          ),
        );
      }).toList(),
      options: CarouselOptions(
        height: 250,
        autoPlay: true,
        enlargeCenterPage: true,
        aspectRatio: 16 / 9,
        viewportFraction: 0.9,
      ),
    );
  }

  Widget content2() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Categories',
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.w600,
                ),
              ),
              GestureDetector(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => const SeeAllCategoriesPage(),
                    ),
                  );
                },
                child: const Text(
                  'See all',
                  style: TextStyle(
                    color: Colors.green,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 10),
        SizedBox(
          height: 110,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            itemCount: categories.length,
            itemBuilder: (context, index) {
              final category = categories[index];
              return Padding(
                padding: const EdgeInsets.symmetric(horizontal: 10),
                child: Column(
                  children: [
                    Container(
                      width: 70,
                      height: 70,
                      decoration: BoxDecoration(
                        color: category.boxColor,
                        borderRadius: BorderRadius.circular(20),
                        image: DecorationImage(
                          image: AssetImage(category.image),
                          fit: BoxFit.cover,
                        ),
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      category.title,
                      style: const TextStyle(
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}
