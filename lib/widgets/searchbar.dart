import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class SearchSection extends StatelessWidget {
  final Function(String) onSearch; // enter key → results page
  final Function(String) onTyping; // live suggestions

  const SearchSection({
    super.key,
    required this.onSearch,
    required this.onTyping,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 40, left: 20, right: 20),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: const Color(0xff1DF16F17).withOpacity(0.11),
            blurRadius: 40,
            spreadRadius: 0,
          ),
        ],
      ),
      child: TextField(
        onChanged: onTyping, // typing → suggestions
        onSubmitted: onSearch, // enter → results page
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          contentPadding: const EdgeInsets.all(15),
          hintText: 'Search Gromart',
          hintStyle: const TextStyle(color: Color(0xffDDDADA), fontSize: 14),
          prefixIcon: Padding(
            padding: const EdgeInsets.all(12),
            child: SvgPicture.asset("assets/icons/Search.svg"),
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(15),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }
}
