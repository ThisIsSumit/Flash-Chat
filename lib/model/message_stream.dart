import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flash_chat/model/message_bubble.dart';
import 'package:flash_chat/screens/chat_screen.dart';
import 'package:flutter/material.dart';

class MessageStream extends StatelessWidget {
  const MessageStream({
    super.key,
    required FirebaseFirestore firestore,
  }) : _firestore = firestore;

  final FirebaseFirestore _firestore;

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<QuerySnapshot>(
        stream: _firestore.collection('messages').snapshots(),
        builder: (context, snapshot) {
          List<MessageBubble> messageWidgets = [];
          if (!snapshot.hasData) {
            return const Center(
              child: CircularProgressIndicator(
                backgroundColor: Colors.lightBlueAccent,
              ),
            );
          }

          final messages = snapshot.data?.docs.reversed;

          for (var message in messages!) {
            final messageData = message.data() as Map<String, dynamic>;
            final messageSender = messageData['sender'];
            final messageText = messageData['text'];
            final currentUser = loggedInUser.email;

            final messageWidget = MessageBubble(
              sender: messageSender,
              text: messageText,
              isMe: (currentUser == messageSender),
            );
            messageWidgets.add(messageWidget);
          }

          return Expanded(
            child: ListView(
              padding: EdgeInsets.symmetric(horizontal: 10, vertical: 20),
              reverse: true,
              children: messageWidgets,
            ),
          );
        });
  }
}

