import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:flutter/services.dart';

class ChatPage extends StatefulWidget {
  @override
  _ChatPageState createState() => _ChatPageState();
}

class _ChatPageState extends State<ChatPage> {
  final TextEditingController _controller = TextEditingController();
  final List<Map<String, dynamic>> _messages = [];
  bool _isHovered = false;

  void _sendMessage([String? text]) {
    final messageText = text ?? _controller.text;
    if (messageText.isNotEmpty) {
      setState(() {
        _messages.insert(0, {
          'text': messageText,
          'isMe': true,
          'timestamp': DateTime.now(),
        });
      });
      _controller.clear();

      // Simulate receiving a message from another user after 2 seconds
      Future.delayed(Duration(seconds: 2), _receiveMessage);
    }
  }

  // Simulate receiving a message from another user
  void _receiveMessage() {
    setState(() {
      _messages.insert(0, {
        'text': "This is a reply from the other user!",
        'isMe': false,
        'timestamp': DateTime.now(),
      });
    });
  }

  void _onKeyPress(RawKeyEvent event) {
    if (event is RawKeyDownEvent && event.logicalKey == LogicalKeyboardKey.enter) {
      if (event.isShiftPressed) {
        // Allow multiline input with Shift + Enter
      } else {
        // Send message on Enter
        _sendMessage();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Chat", style: TextStyle(color: Colors.white)),
        centerTitle: true,
        backgroundColor: const Color.fromARGB(255, 161, 187, 239),
        elevation: 4.0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(bottom: Radius.circular(20)),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              reverse: true,
              itemCount: _messages.length,
              itemBuilder: (ctx, index) {
                final messageData = _messages[index];
                final messageDate = messageData['timestamp'] as DateTime;

                // Determine if we should display a date label
                bool showDateLabel = false;
                if (index == _messages.length - 1 || !_isSameDay(messageDate, _messages[index + 1]['timestamp'])) {
                  showDateLabel = true;
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    if (showDateLabel) _buildDateLabel(messageDate),
                    MessageBubble(
                      messageData['text'],
                      messageData['isMe'],
                      messageDate,
                      key: ValueKey(index),
                    ),
                  ],
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                Expanded(
                  child: MouseRegion(
                    onEnter: (_) => setState(() => _isHovered = true),
                    onExit: (_) => setState(() => _isHovered = false),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(
                        maxHeight: 150,
                      ),
                      child: RawKeyboardListener(
                        focusNode: FocusNode(),
                        onKey: _onKeyPress,
                        child: TextField(
                          controller: _controller,
                          minLines: 1,
                          maxLines: null,
                          decoration: InputDecoration(
                            labelText: 'Send a message...',
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: const Color.fromARGB(255, 16, 13, 13)),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: const Color.fromARGB(255, 13, 13, 14), width: 2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            hoverColor: Colors.blue.withOpacity(0.1),
                            border: OutlineInputBorder(
                              borderSide: BorderSide(
                                  color: _isHovered ? const Color.fromARGB(255, 25, 26, 27) : const Color.fromARGB(255, 31, 30, 30),
                                  width: _isHovered ? 2 : 1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          onSubmitted: (value) => _sendMessage(value),
                        ),
                      ),
                    ),
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.send, color: Colors.blueAccent),
                  onPressed: () => _sendMessage(),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  // Widget to build the date label
  Widget _buildDateLabel(DateTime date) {
    final formattedDate = DateFormat('EEEE, MMM d, y').format(date);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: Center(
        child: Text(
          formattedDate,
          style: TextStyle(
            fontSize: 14,
            fontWeight: FontWeight.bold,
            color: Colors.grey[600],
          ),
        ),
      ),
    );
  }

  // Helper method to check if two dates are the same day
  bool _isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year && date1.month == date2.month && date1.day == date2.day;
  }
}

class MessageBubble extends StatelessWidget {
  final String message;
  final bool isMe;
  final DateTime timestamp;

  MessageBubble(this.message, this.isMe, this.timestamp, {Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final formattedTime = DateFormat('hh:mm a').format(timestamp);
    
    return Column(
      crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: isMe ? MainAxisAlignment.end : MainAxisAlignment.start,
          children: [
            Flexible(
              child: Container(
                decoration: BoxDecoration(
                  gradient: isMe
                      ? LinearGradient(
                          colors: [const Color.fromARGB(255, 60, 144, 239)!, const Color.fromARGB(255, 64, 156, 237)!],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        )
                      : LinearGradient(
                          colors: [Colors.lightBlue[300]!, const Color.fromARGB(255, 154, 216, 245)!],
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                        ),
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(12),
                    topRight: Radius.circular(12),
                    bottomLeft: isMe ? Radius.circular(12) : Radius.circular(0),
                    bottomRight: isMe ? Radius.circular(0) : Radius.circular(12),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 4,
                      offset: Offset(2, 2),
                    ),
                  ],
                ),
                padding: EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                margin: EdgeInsets.symmetric(vertical: 4, horizontal: 8),
                child: Column(
                  crossAxisAlignment: isMe ? CrossAxisAlignment.end : CrossAxisAlignment.start,
                  children: [
                    Text(
                      message,
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                        color: Colors.white,
                      ),
                    ),
                    SizedBox(height: 5),
                    Text(
                      formattedTime,
                      style: TextStyle(
                        fontSize: 10,
                        color: Colors.white70,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}
