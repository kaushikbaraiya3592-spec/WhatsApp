import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

/// Simple WhatsApp-like home page in Flutter.
/// - DefaultTabController with 3 tabs: Chats, Status, Calls
/// - Chats tab shows a list of sample conversations
/// - FloatingActionButton for new chat
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'WhatsApp UI Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primaryColor: const Color(0xFF075E54),
        colorScheme: ColorScheme.fromSwatch().copyWith(secondary: const Color(0xFF25D366)),
      ),
      home: WhatsAppHome(),
    );
  }
}

class WhatsAppHome extends StatelessWidget {
  // Sample chat data
  final List<ChatItem> chats = List.generate(
    12,
    (i) => ChatItem(
      name: i == 0 ? 'Rahul Sharma' : 'Contact ${i + 1}',
      message: i == 0 ? 'Hey! Kya chal raha hai?' : 'Last message from contact ${i + 1}',
      time: i % 3 == 0 ? '12:45' : i % 3 == 1 ? 'Yesterday' : 'Mon',
      unreadCount: i == 0 ? 3 : (i % 4 == 0 ? 1 : 0),
      online: i % 5 == 0,
      initials: i == 0 ? 'R' : 'C${i + 1}',
    ),
  );

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('WhatsApp'),
          backgroundColor: const Color(0xFF075E54),
          elevation: 0.5,
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () {
                // Search action - placeholder
              },
            ),
            PopupMenuButton<String>(
              onSelected: (val) {
                // handle menu selection
              },
              itemBuilder: (context) => [
                const PopupMenuItem(value: 'new_group', child: Text('New group')),
                const PopupMenuItem(value: 'settings', child: Text('Settings')),
              ],
            ),
          ],
          bottom: TabBar(
            indicatorColor: Colors.white,
            tabs: const [
              Tab(text: 'CHATS'),
              Tab(text: 'STATUS'),
              Tab(text: 'CALLS'),
            ],
          ),
        ),
        body: TabBarView(
          children: [
            // --- CHATS TAB ---
            ListView.separated(
              itemCount: chats.length,
              separatorBuilder: (context, index) => const Divider(height: 0.5),
              itemBuilder: (context, index) {
                final chat = chats[index];
                return ChatListTile(chat: chat);
              },
            ),

            // --- STATUS TAB (simple placeholder) ---
            SingleChildScrollView(
              child: Column(
                children: [
                  ListTile(
                    leading: Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        CircleAvatar(radius: 26, child: Text('Me')),
                        Container(
                          height: 18,
                          width: 18,
                          decoration: BoxDecoration(
                            color: Theme.of(context).colorScheme.secondary,
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.add, size: 14, color: Colors.white),
                        ),
                      ],
                    ),
                    title: const Text('My status'),
                    subtitle: const Text('Tap to add status update'),
                  ),
                  const Divider(),
                  ListTile(
                    title: const Text('Recent updates'),
                    dense: true,
                  ),
                  // sample statuses
                  for (int i = 1; i <= 6; i++)
                    ListTile(
                      leading: CircleAvatar(child: Text('S$i')),
                      title: Text('Contact $i'),
                     subtitle: Text('Today, 09:0$i'),
                    ),
                ],
              ),
            ),

            // --- CALLS TAB (simple placeholder) ---
            ListView.builder(
              itemCount: 8,
              itemBuilder: (context, i) {
                final name = 'Contact ${i + 1}';
                final incoming = i % 2 == 0;
                return ListTile(
                  leading: CircleAvatar(child: Text(name[0])),
                  title: Text(name),
                  subtitle: Row(
                    children: [
                      Icon(incoming ? Icons.call_received : Icons.call_made, size: 14, color: incoming ? Colors.red : Colors.green),
                      const SizedBox(width: 6),
                      Text(i % 3 == 0 ? 'Today, 10:${10 + i}' : 'Yesterday'),
                    ],
                  ),
                  trailing: IconButton(
                    icon: const Icon(Icons.call, color: Color(0xFF075E54)),
                    onPressed: () {},
                  ),
                );
              },
            ),
          ],
        ),

        // Floating action button like WhatsApp (chat)
        floatingActionButton: FloatingActionButton(
          backgroundColor: const Color(0xFF25D366),
          child: const Icon(Icons.message, color: Colors.white),
          onPressed: () {
            // New chat action
          },
        ),
      ),
    );
  }
}

/// Data model for chat item
class ChatItem {
  final String name;
  final String message;
  final String time;
  final int unreadCount;
  final bool online;
  final String initials;

  ChatItem({
    required this.name,
    required this.message,
    required this.time,
    this.unreadCount = 0,
    this.online = false,
    required this.initials,
  });
}

/// Widget for each chat list tile
class ChatListTile extends StatelessWidget {
  final ChatItem chat;
  const ChatListTile({Key? key, required this.chat}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      leading: Stack(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: Colors.grey.shade300,
            child: Text(chat.initials, style: const TextStyle(color: Colors.black87)),
          ),
          if (chat.online)
            Positioned(
              bottom: 2,
              right: 0,
              child: Container(
                height: 14,
                width: 14,
                decoration: BoxDecoration(
                  color: Colors.green,
                  shape: BoxShape.circle,
                  border: Border.all(color: Colors.white, width: 2),
                ),
              ),
            ),
        ],
      ),
      title: Text(chat.name, style: const TextStyle(fontWeight: FontWeight.w600)),
      subtitle: Text(
        chat.message,
        maxLines: 1,
        overflow: TextOverflow.ellipsis,
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(chat.time, style: TextStyle(fontSize: 12, color: Colors.grey.shade600)),
          const SizedBox(height: 6),
          if (chat.unreadCount > 0)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: const Color(0xFF25D366),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                chat.unreadCount.toString(),
                style: const TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ),
        ],
      ),
      onTap: () {
        // open chat
      },
    );
  }
}
