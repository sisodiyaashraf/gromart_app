import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_dotenv/flutter_dotenv.dart';

final String geminiApiKey = dotenv.env['GEMINI_API_KEY'] ?? '';
final String geminiUrl = "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent";

Future<String> sendGroceryMessage(String userText) async {
final String url = "${geminiUrl}?key=$geminiApiKey";

  final body = jsonEncode({
    "contents": [
      {
        "role": "system",
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
      {
        "role": "user",
        "parts": [
          {"text": userText}
        ]
      }
    ]
  });

  final resp = await http.post(
    Uri.parse(url),
    headers: {"Content-Type": "application/json"},
    body: body,
  );

  if (resp.statusCode == 200) {
    final data = jsonDecode(resp.body);
    return data["candidates"]?[0]?["content"]?["parts"]?[0]?["text"] ??
        "No reply";
  } else {
    return "Error ${resp.statusCode}: ${resp.body}";
  }
}
