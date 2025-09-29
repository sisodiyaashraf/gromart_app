import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../models/chat_message.dart';

// 🔑 Hardcoded Gemini API Key & URL
const String GEMINI_API_KEY = "AIzaSyD4WA7V0vI8RcpxxBFm1PPGbkPzqYkg3o4";
const String GEMINI_URL =
    "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent";

class ChatProvider extends ChangeNotifier {
  final List<ChatMessage> _messages = [];
  List<ChatMessage> get messages => _messages;

  bool isLoading = false;

  Future<void> sendUserMessage(String text) async {
    if (text.trim().isEmpty) return;

    _messages.add(ChatMessage(text: text, role: "user"));
    isLoading = true;
    notifyListeners();

    try {
      final url = "$GEMINI_URL?key=$GEMINI_API_KEY";

      final body = jsonEncode({
        "contents": [
          {
            "role": "user",
            "parts": [
              {
                "text": """
You are GroceryGuru, a helpful grocery shopping and recipe assistant.
Always restrict answers to grocery items, product suggestions, healthy eating tips, or recipes.
Never answer unrelated questions (politics, math, coding, etc).
If the user asks something off-topic, politely say: "I can only help with groceries and recipes."
"""
              }
            ]
          },
          ..._messages.map((m) => {
                "role": m.role == "assistant" ? "model" : "user", // ✅ FIXED
                "parts": [
                  {"text": m.text}
                ]
              }),
        ]
      });

      final resp = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: body,
      );

      if (resp.statusCode == 200) {
        final data = jsonDecode(resp.body);
        final reply = data["candidates"]?[0]?["content"]?["parts"]?[0]
                ?["text"] ??
            "No reply";

        _messages.add(ChatMessage(text: reply, role: "assistant"));
      } else {
        _messages.add(ChatMessage(
            text: "Error ${resp.statusCode}: ${resp.body}", role: "assistant"));
      }
    } catch (e) {
      _messages.add(ChatMessage(text: "Network error: $e", role: "assistant"));
    }

    isLoading = false;
    notifyListeners();
  }

  void clear() {
    _messages.clear();
    notifyListeners();
  }
}
