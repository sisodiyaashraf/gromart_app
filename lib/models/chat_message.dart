class ChatMessage {
  final String text;
  final String role; // "user" or "assistant"

  ChatMessage({required this.text, required this.role});

  Map<String, dynamic> toJson() => {
        "role": role,
        "text": text,
      };
}
