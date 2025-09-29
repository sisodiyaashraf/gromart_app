import 'package:flutter/material.dart';

class CustomTabs extends StatefulWidget {
  const CustomTabs({super.key});

  @override
  State<CustomTabs> createState() => _CustomTabsState();
}

class _CustomTabsState extends State<CustomTabs> {
  int selectedIndex = 0;

  final List<Map<String, dynamic>> tabs = [
    {"icon": Icons.flash_on, "label": "Flash sales"},
    {"label": "For you"},
    {"label": "Popular"},
    {"label": "New"},
    {"label": "Trending"},
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 45,
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: List.generate(tabs.length, (index) {
            final tab = tabs[index];
            final bool isSelected = selectedIndex == index;

            return GestureDetector(
              onTap: () {
                setState(() {
                  selectedIndex = index;
                });
              },
              child: Container(
                margin: const EdgeInsets.symmetric(horizontal: 6),
                padding: const EdgeInsets.symmetric(
                  horizontal: 14,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: isSelected ? Colors.black : Colors.grey.shade200,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Row(
                  children: [
                    if (tab["icon"] != null)
                      Icon(
                        tab["icon"],
                        size: 18,
                        color: isSelected ? Colors.white : Colors.orange,
                      ),
                    if (tab["icon"] != null) const SizedBox(width: 6),
                    Text(
                      tab["label"],
                      style: TextStyle(
                        color: isSelected ? Colors.white : Colors.black,
                        fontSize: 14,
                        fontWeight: isSelected
                            ? FontWeight.w600
                            : FontWeight.w400,
                      ),
                    ),
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
