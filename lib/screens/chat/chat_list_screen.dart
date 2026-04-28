import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:volunteer_match_ai/screens/chat/chat_screen.dart';
import 'package:volunteer_match_ai/services/chat_service.dart';

class ChatListScreen extends StatelessWidget {
  const ChatListScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Chats')),
      body: StreamBuilder<QuerySnapshot<Map<String, dynamic>>>(
        stream: ChatService.chatListStream(),
        builder: (context, snapshot) {
          if (!snapshot.hasData) return const Center(child: CircularProgressIndicator());
          final docs = snapshot.data!.docs;
          if (docs.isEmpty) return const Center(child: Text('No chats yet.'));
          return ListView.builder(
            itemCount: docs.length,
            itemBuilder: (_, i) {
              final chatId = docs[i].id;
              return ListTile(
                title: Text('Chat $chatId'),
                trailing: const Icon(Icons.chevron_right),
                onTap: () => Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => ChatScreen(chatId: chatId)),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
