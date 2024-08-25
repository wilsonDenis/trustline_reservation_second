import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:trust_reservation_second/constants/colors_app.dart';
import 'package:trust_reservation_second/services/message_service.dart';

class IndividualChatPage extends StatefulWidget {
  final String user1Id;
  final String user2Id;
  final String user2Name;
  final String user2PhotoUrl;

  const IndividualChatPage({
    super.key,
    required this.user1Id,
    required this.user2Id,
    required this.user2Name,
    required this.user2PhotoUrl,
  });

  @override
  _IndividualChatPageState createState() => _IndividualChatPageState();
}

class _IndividualChatPageState extends State<IndividualChatPage> {
  final MessageService _messageService = MessageService();
  final TextEditingController _messageController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  String? chatId;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _initializeChatId();
  }

  Future<void> _initializeChatId() async {
    try {
      String userId = widget.user1Id;
      String receiverId = widget.user2Id;

      // Log pour déboguer les IDs
      if (kDebugMode) {
        print('Initialisation du chat — Sender ID: $userId, Receiver ID: $receiverId');
      }

      chatId = _messageService.getChatId(userId, receiverId);

      if (chatId == null || chatId!.isEmpty) {
        throw Exception('Failed to generate chat ID');
      }

      setState(() {
        isLoading = false; // Fin de l'initialisation, l'interface peut être mise à jour
      });
    } catch (e) {
      if (kDebugMode) {
        print('Erreur lors de l\'initialisation du chatId: $e');
      }
      setState(() {
        isLoading = false; // Fin de l'initialisation, même en cas d'erreur
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return CupertinoPageScaffold(
      navigationBar: CupertinoNavigationBar(
        middle: Row(
          children: [
            CircleAvatar(
              backgroundImage: widget.user2PhotoUrl.isNotEmpty
                  ? NetworkImage(widget.user2PhotoUrl)
                  : const AssetImage('assets/default_profile.png') as ImageProvider,
            ),
            const SizedBox(width: 10),
            Text(widget.user2Name),
          ],
        ),
      ),
      child: SafeArea(
        child: isLoading
            ? const Center(child: CupertinoActivityIndicator())
            : chatId == null || chatId!.isEmpty
                ? const Center(child: Text('Erreur: ID du chat non trouvé'))
                : Column(
                    children: [
                      Expanded(
                        child: StreamBuilder<List<Map<String, dynamic>>>(
                          stream: _messageService.streamMessages(int.tryParse(chatId!) ?? 0),
                          builder: (context, snapshot) {
                            if (snapshot.connectionState == ConnectionState.waiting) {
                              return const Center(child: CupertinoActivityIndicator());
                            } else if (snapshot.hasError) {
                              return const Center(child: Text('Erreur de chargement des messages.'));
                            } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                              return Center(
                                child: Image.asset(
                                  'assets/Hello.gif',
                                  key: UniqueKey(),
                                  width: 200,
                                  height: 200,
                                ),
                              );
                            }

                            var messages = snapshot.data!;
                            return ListView.builder(
                              controller: _scrollController,
                              reverse: true,
                              itemCount: messages.length,
                              itemBuilder: (context, index) {
                                var message = messages[index];
                                bool isCurrentUser = message['senderId'] == widget.user1Id;
                                return Align(
                                  alignment: isCurrentUser ? Alignment.centerRight : Alignment.centerLeft,
                                  child: Container(
                                    padding: const EdgeInsets.all(10),
                                    margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                                    decoration: BoxDecoration(
                                      color: isCurrentUser ? ColorsApp.primaryColor : Colors.white,
                                      borderRadius: BorderRadius.circular(15),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.grey.withOpacity(0.5),
                                          spreadRadius: 2,
                                          blurRadius: 5,
                                          offset: const Offset(0, 3),
                                        ),
                                      ],
                                    ),
                                    child: Text(
                                      message['content'] ?? '',
                                      style: TextStyle(
                                        color: isCurrentUser ? Colors.white : Colors.black,
                                      ),
                                    ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(11.0),
                        child: Row(
                          children: [
                            Expanded(
                              child: CupertinoTextField(
                                controller: _messageController,
                                placeholder: "Tapez votre message...",
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(25),
                                ),
                              ),
                            ),
                           CupertinoButton(
  child: const Icon(
    CupertinoIcons.paperplane_fill,
    color: ColorsApp.primaryColor,
    size: 30,
  ),
  onPressed: () async {
    if (_messageController.text.isNotEmpty && chatId != null && chatId!.isNotEmpty) {
      await _messageService.sendMessage(
        _messageController.text,
        widget.user1Id, // Passer explicitement user1Id comme senderId
        widget.user2Id,
      );
      _messageController.clear();

      // Scroller vers le bas après l'envoi d'un message
      _scrollController.animateTo(
        _scrollController.position.minScrollExtent,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  },
),

                          ],
                        ),
                      ),
                    ],
                  ),
      ),
    );
  }
}
