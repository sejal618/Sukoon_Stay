import 'package:flutter/material.dart';
import '../data/chat_data.dart';

class ChatScreen extends StatefulWidget {
  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, String>> _messages = [];

  // Function to get current time in HH:mm format
  String _getCurrentTime() {
    final now = DateTime.now();
    return '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
  }

  void _sendMessage() {
    if (_controller.text.trim().isEmpty) return;

    String userMessage = _controller.text.trim();
    String botResponse = ChatData.getResponse(userMessage);
    String currentTime = _getCurrentTime();

    setState(() {
      _messages.add({
        "sender": "user",
        "message": userMessage,
        "time": currentTime,
      });
      _messages.add({
        "sender": "bot",
        "message": botResponse,
        "time": currentTime,
      });
    });

    _controller.clear();
  }

  Widget _buildMessage(Map<String, String> message) {
    bool isUser = message['sender'] == 'user';
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Container(
        margin: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
        padding: EdgeInsets.all(14),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.75),
        decoration: BoxDecoration(
          color: isUser ? Colors.blueAccent : Colors.grey.shade200,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomLeft: isUser ? Radius.circular(16) : Radius.zero,
            bottomRight: isUser ? Radius.zero : Radius.circular(16),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              offset: Offset(2, 2),
              blurRadius: 4,
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: isUser ? CrossAxisAlignment.end : CrossAxisAlignment.start,
          children: [
            Text(
              message['message']!,
              style: TextStyle(
                fontSize: 16,
                color: isUser ? Colors.white : Colors.black87,
              ),
            ),
            SizedBox(height: 4),
            Text(
              message['time']!,
              style: TextStyle(
                fontSize: 12,
                color: isUser ? Colors.white70 : Colors.black54,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Hotel Booking Chatbot',
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        backgroundColor: Colors.deepPurple,
        centerTitle: true,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: _messages.length,
              reverse: true, // Recent messages at the bottom
              itemBuilder: (context, index) {
                return _buildMessage(_messages[_messages.length - 1 - index]);
              },
            ),
          ),
          Container(
            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 10),
            color: Colors.grey.shade100,
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: InputDecoration(
                      hintText: 'Ask me anything...',
                      filled: true,
                      fillColor: Colors.white,
                      contentPadding: EdgeInsets.symmetric(horizontal: 20, vertical: 12),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30),
                        borderSide: BorderSide.none,
                      ),
                    ),
                  ),
                ),
                SizedBox(width: 8),
                GestureDetector(
                  onTap: _sendMessage,
                  child: Container(
                    padding: EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: Colors.deepPurple,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(Icons.send, color: Colors.white),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
