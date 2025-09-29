import 'dart:convert';
import 'package:http/http.dart' as http;

const String GEMINI_API_KEY = "YOUR_GEMINI_API_KEY_HERE";
const String GEMINI_URL =
    "https://generativelanguage.googleapis.com/v1beta/models/gemini-2.5-flash:generateContent";

Future<String> sendGroceryMessage(String userText) async {
  final url = "$GEMINI_URL?key=$GEMINI_API_KEY";

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
