import 'package:flutter/material.dart';
import '../../core/constants/colors.dart';
import '../../services/api_service.dart';

class ChatListScreen extends StatefulWidget {
  const ChatListScreen({super.key});

  @override
  State<ChatListScreen> createState() => _ChatListScreenState();
}

class _ChatListScreenState extends State<ChatListScreen> {
  final ApiService _apiService = ApiService();
  List<dynamic> _messages = [];
  bool _isLoading = true;

  @override
  void initState() {
    super.initState();
    _loadMessages();
  }

  Future<void> _loadMessages() async {
    final data = await _apiService.fetchMessages();
    if (mounted) {
      setState(() {
        _messages = data;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Messages', style: TextStyle(fontWeight: FontWeight.bold)),
        backgroundColor: Colors.white,
        foregroundColor: AppColors.primary,
        elevation: 0.5,
      ),
      body: _isLoading 
        ? const Center(child: CircularProgressIndicator(color: AppColors.primary))
        : RefreshIndicator(
            onRefresh: _loadMessages,
            color: AppColors.accent,
            child: _messages.isEmpty
              ? _buildEmptyState()
              : ListView.separated(
                  itemCount: _messages.length,
                  separatorBuilder: (context, index) => const Divider(height: 1, indent: 80),
                  itemBuilder: (context, index) {
                    final msg = _messages[index];
                    return ListTile(
                      contentPadding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
                      leading: Stack(
                        children: [
                          CircleAvatar(
                            radius: 28,
                            backgroundColor: AppColors.accent.withOpacity(0.2),
                            child: const Icon(Icons.person, color: AppColors.primary),
                          ),
                          Positioned(
                            right: 0, bottom: 0,
                            child: Container(
                              width: 14, height: 14,
                              decoration: BoxDecoration(
                                color: Colors.green, shape: BoxShape.circle,
                                border: Border.all(color: Colors.white, width: 2),
                              ),
                            ),
                          )
                        ],
                      ),
                      title: Text('User ID: ${msg['senderId'].toString().substring(0, 5)}...', style: const TextStyle(fontWeight: FontWeight.bold)),
                      subtitle: Text(msg['content'] ?? 'No content', maxLines: 1, overflow: TextOverflow.ellipsis),
                      trailing: const Text('Now', style: TextStyle(fontSize: 12, color: Colors.grey)),
                      onTap: () {
                        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("Opening secure chat room...")));
                      },
                    );
                  },
                ),
          ),
      floatingActionButton: FloatingActionButton(
        backgroundColor: AppColors.primary,
        onPressed: () {
          ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("New message modal coming soon!")));
        },
        child: const Icon(Icons.message, color: Colors.white),
      ),
    );
  }

  Widget _buildEmptyState() {
    return ListView(
      children: [
        SizedBox(height: MediaQuery.of(context).size.height * 0.2),
        const Icon(Icons.chat_bubble_outline, size: 80, color: Colors.grey),
        const SizedBox(height: 16),
        const Center(child: Text('No messages yet.', style: TextStyle(fontSize: 18, color: Colors.grey))),
        const Center(child: Text('Start a conversation with a seller!', style: TextStyle(color: Colors.grey))),
      ],
    );
  }
}
