import 'package:flutter/material.dart';

class ChatbotPage extends StatefulWidget {
  @override
  _ChatbotPageState createState() => _ChatbotPageState();
}

class _ChatbotPageState extends State<ChatbotPage> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];
  bool _isBotTyping = false;

  void _sendMessage(String message) {
    if (message.trim().isEmpty) return;

    setState(() {
      _messages.add({'sender': 'user', 'text': message});
      _controller.clear();
      _isBotTyping = true;
    });

    _getBotResponse(message);
  }

  void _getBotResponse(String userMessage) async {
    await Future.delayed(Duration(seconds: 1)); // Simulate typing delay

    String botMessage;

    if (userMessage.toLowerCase().contains("hello")) {
      botMessage = "👋 Hello! How can I help you today with your food orders?";
    } else if (userMessage.toLowerCase().contains("subscription")) {
      botMessage = "📅 You can manage or upgrade your subscription on the Subscription page.";
    } else if (userMessage.toLowerCase().contains("order")) {
      botMessage = "🛒 Please provide your order ID to check the current status.";
    } else if (userMessage.toLowerCase().contains("thank you")) {
      botMessage = "😊 You're welcome! Have a great day!";
    } else {
      botMessage = "🤖 I'm not sure I understand. Try asking about your order, subscription, or support.";
    }

    setState(() {
      _messages.add({'sender': 'bot', 'text': botMessage});
      _isBotTyping = false;
    });
  }

  Widget _buildMessage(Map<String, String> msg) {
    final isUser = msg['sender'] == 'user';
    final alignment = isUser ? Alignment.centerRight : Alignment.centerLeft;
    final bgColor = isUser ? Colors.deepPurpleAccent : Colors.grey[200];
    final textColor = isUser ? Colors.white : Colors.black87;
    final avatar = CircleAvatar(
      backgroundColor: isUser ? Colors.deepPurple : Colors.grey[400],
      child: Icon(isUser ? Icons.person : Icons.smart_toy, color: Colors.white),
    );

    return Align(
      alignment: alignment,
      child: Row(
        mainAxisAlignment:
        isUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isUser) avatar,
          SizedBox(width: 8),
          Flexible(
            child: Container(
              margin: EdgeInsets.symmetric(vertical: 6),
              padding: EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: bgColor,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(16),
                  topRight: Radius.circular(16),
                  bottomLeft: Radius.circular(isUser ? 16 : 0),
                  bottomRight: Radius.circular(isUser ? 0 : 16),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black12,
                    blurRadius: 4,
                    offset: Offset(2, 2),
                  ),
                ],
              ),
              child: Text(
                msg['text']!,
                style: TextStyle(color: textColor, fontSize: 16),
              ),
            ),
          ),
          if (isUser) SizedBox(width: 8),
          if (isUser) avatar,
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dabbawala Assistant'),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              colors: [Colors.deepPurple, Colors.deepPurpleAccent],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
          ),
        ),
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(12),
              itemCount: _messages.length + (_isBotTyping ? 1 : 0),
              itemBuilder: (context, index) {
                if (_isBotTyping && index == _messages.length) {
                  return Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 6, horizontal: 12),
                      child: Row(
                        children: [
                          CircleAvatar(
                            backgroundColor: Colors.grey[400],
                            child: Icon(Icons.smart_toy, color: Colors.white),
                          ),
                          SizedBox(width: 8),
                          Text("Bot is typing...",
                              style: TextStyle(fontStyle: FontStyle.italic)),
                        ],
                      ),
                    ),
                  );
                }
                return _buildMessage(_messages[index]);
              },
            ),
          ),
          Divider(height: 1),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            color: Colors.white,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: "Type your message...",
                      border: InputBorder.none,
                    ),
                    onSubmitted: _sendMessage,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.deepPurple),
                  onPressed: () => _sendMessage(_controller.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
