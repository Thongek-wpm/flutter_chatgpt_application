enum ChatMessenerType { user, bot }

class ChatMessener {
  final String text;
  final ChatMessener chatMessageType;
  ChatMessener(
    this.text, {
    required this.chatMessageType,
  });
}
