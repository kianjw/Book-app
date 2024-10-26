// ignore_for_file: avoid_dynamic_calls

import 'package:auto_route/auto_route.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ebook_app/src/common/common.dart';
import 'package:flutter_ebook_app/src/features/features.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_ebook_app/productivity_page.dart'; 
import 'package:flutter_ebook_app/personal_page.dart'; 
import 'package:cloud_firestore/cloud_firestore.dart';

// Make sure to import UserListPage


class HomeScreenSmall extends ConsumerStatefulWidget {
  const HomeScreenSmall({super.key});

  @override
  ConsumerState<HomeScreenSmall> createState() => _HomeScreenSmallState();
}

class _HomeScreenSmallState extends ConsumerState<HomeScreenSmall> {
  List<QueryDocumentSnapshot<Map<String, dynamic>>> users = [];

  void loadData() {
    ref.read(homeFeedNotifierProvider.notifier).fetch();

    // Fetch users from Firestore collection 'users'
    FirebaseFirestore.instance.collection('users').get().then((querySnapshot) {
      setState(() {
        users = querySnapshot.docs;
      });
    }).catchError((error) {
      print("Error fetching users: $error");
    });
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      ref.read(homeFeedNotifierProvider).maybeWhen(
            orElse: () => loadData(),
            data: (_) => null,
          );
    });
  }

  @override
  Widget build(BuildContext context) {
    final homeDataState = ref.watch(homeFeedNotifierProvider);
    return Scaffold(
      appBar: context.isSmallScreen
          ? AppBar(
              centerTitle: true,
              title: const Text(
                appName,
                style: TextStyle(fontSize: 20.0),
              ),
            )
          : null,
      body: AnimatedSwitcher(
        duration: const Duration(milliseconds: 500),
        child: homeDataState.maybeWhen(
          orElse: () => const SizedBox.shrink(),
          loading: () => const LoadingWidget(),
          data: (feeds) {
            final popular = feeds.popularFeed;
            final recent = feeds.recentFeed;
            return RefreshIndicator(
              onRefresh: () async => loadData(),
              child: ListView(
                children: <Widget>[
                  if (!context.isSmallScreen) const SizedBox(height: 30.0),
                  FeaturedSection(popular: popular),
                  const SizedBox(height: 20.0),
              _SectionTitle(title: 'Categories', users: users), // Pass users here
                  const SizedBox(height: 10.0),
                  _GenreSection(popular: popular),
                  const SizedBox(height: 20.0),
                  _SearchBar(),
                  const SizedBox(height: 20.0),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: Text(
                      'Recently Added',
                      style: TextStyle(
                        fontSize: 20.0,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ),
                  const SizedBox(height: 20.0),
                  _NewSection(recent: recent),
                ],
              ),
            );
          },
          error: (_, __) {
            return MyErrorWidget(
              refreshCallBack: () => loadData(),
            );
          },
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        children: <Widget>[
          Expanded(
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search...',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(20.0),
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 16.0),
              ),
            ),
          ),
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () {
              // Perform search functionality here
            },
          ),
        ],
      ),
    );
  }
}

// Remaining code for _SectionTitle, FeaturedSection, _GenreSection, _NewSection, and ChatBoxScreen remains the same.

class _SectionTitle extends StatelessWidget {
  final String title;
  final List<QueryDocumentSnapshot<Map<String, dynamic>>> users; // Add users list

  const _SectionTitle({required this.title, required this.users});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Row(
            children: [
              Icon(Icons.person), // Add your personal icon here
              SizedBox(width: 8.0), // Add some spacing between icons
              Text(
                title,
                style: const TextStyle(
                  fontSize: 20.0,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.manage_accounts), // Icon for Personal Page
                onPressed: () {
                  if (users.isNotEmpty) {
                    // Example: accessing the first user's data
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PersonalPage(
                          userInfo: UserInfo(
                            name: users.last.get('name') as String? ?? '',
                            email: users[0].get('email') as String? ?? '',
                            genres: (users[0].get('genres') as List<dynamic>?)?.map((e) => e.toString()).toList() ?? [],
                            booksPerYear: users[0].get('booksPerYear') as int? ?? 0,
                            freeTime: users[0].get('freeTime') as String? ?? '',
                          ),
                        ),
                      ),
                    );
                  }
                },
              ),
              IconButton(
                icon: const Icon(Icons.whatshot),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ProductivityPage(booksPerYear: 20),
                    ),
                  );
                },
              ),
              IconButton(
                icon: const Icon(Icons.chat_bubble),
                onPressed: () {
                  if (users.isNotEmpty) {
                    // Navigate to ChatBoxScreen with userId
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => ChatBoxScreen(userId: users[0].id), // Pass userId from users list
                      ),
                    );
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}








class FeaturedSection extends StatelessWidget {
  final CategoryFeed popular;

  const FeaturedSection({super.key, required this.popular});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200.0,
      child: Center(
        child: ListView.builder(
          primary: false,
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          scrollDirection: Axis.horizontal,
          itemCount: popular.feed?.entry?.length ?? 0,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            final Entry entry = popular.feed!.entry![index];
            return Padding(
              padding:
                  const EdgeInsets.symmetric(horizontal: 5.0, vertical: 10.0),
              child: BookCard(
                img: entry.link![1].href!,
                entry: entry,
              ),
            );
          },
        ),
      ),
    );
  }
}

class _GenreSection extends StatelessWidget {
  final CategoryFeed popular;

  const _GenreSection({required this.popular});

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50.0,
      child: Center(
        child: ListView.builder(
          primary: false,
          padding: const EdgeInsets.symmetric(horizontal: 15.0),
          scrollDirection: Axis.horizontal,
          itemCount: popular.feed?.link?.length ?? 0,
          shrinkWrap: true,
          itemBuilder: (BuildContext context, int index) {
            final Link link = popular.feed!.link![index];

            // We don't need the tags from 0-9 because
            // they are not categories
            if (index < 10) {
              return const SizedBox.shrink();
            }

            return Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: 5.0,
                vertical: 10.0,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: context.theme.colorScheme.secondary,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(20.0),
                  ),
                ),
                child: InkWell(
                  borderRadius: const BorderRadius.all(
                    Radius.circular(20.0),
                  ),
                  onTap: () {
                    final route = GenreRoute(
                      title: '${link.title}',
                      url: link.href!,
                    );
                    if (context.isLargeScreen) {
                      context.router.replace(route);
                    } else {
                      context.router.push(route);
                    }
                  },
                  child: Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 10.0),
                      child: Text(
                        '${link.title}',
                        style: const TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}

class _NewSection extends StatelessWidget {
  final CategoryFeed recent;

  const _NewSection({required this.recent});

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      primary: false,
      padding: const EdgeInsets.symmetric(horizontal: 15.0),
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: recent.feed?.entry?.length ?? 0,
      itemBuilder: (BuildContext context, int index) {
        final Entry entry = recent.feed!.entry![index];

        return Padding(
          padding: const EdgeInsets.symmetric(horizontal: 5.0, vertical: 5.0),
          child: BookListItem(entry: entry),
        );
      },
    );
  }
}

class TextGenerationService {
  static const String _apiKey =
      'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJ1c2VyX2lkIjoiMDlmZThkMTQtZmM0NC00ZGM1LTk5NjYtMDgwNzkyZWEyYjU0IiwidHlwZSI6ImFwaV90b2tlbiJ9.evVx7dj2SpqZyP0VrMRW7-ug-3DjeibSWl1wpQXNANY';
  static const String _url = 'https://api.edenai.run/v2/text/chat';

  Future<String> generateText(String prompt) async {
    try {
      final response = await http.post(
        Uri.parse(_url),
        headers: {
          'Authorization': 'Bearer $_apiKey',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'providers': 'openai',
          'text': prompt,
          'chatbot_global_action': 'Act as an assistant',
          'previous_history': [],
          'temperature': 0.0,
          'max_tokens': 150,
          'fallback_providers': '',
        }),
      );

      if (response.statusCode == 200) {
        final dynamic jsonDecode2 = jsonDecode(response.body);
        final Map<String, dynamic> responseData = jsonDecode2 as Map<String, dynamic>;

        if (responseData.containsKey('openai') &&
            responseData['openai']['status'] == 'success') {
          // Extract generated text
          final dynamic openaiData = responseData['openai'];
          if (openaiData != null && openaiData is Map<String, dynamic>) {
            final String? generatedText = openaiData['generated_text'] as String?;
            if (generatedText != null) {
              return generatedText;
            } else {
              throw Exception('Generated text is null or not of type String');
            }
          } else {
            throw Exception('Invalid format for openai data');
          }
        } else {
          throw Exception('Failed to generate text. Response: $responseData');
        }
      } else {
        throw Exception('Failed to generate text: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error: $e');
    }
  }
}

class ChatBoxScreen extends StatefulWidget {
  final String userId;

  ChatBoxScreen({required this.userId});

  @override
  _ChatBoxScreenState createState() => _ChatBoxScreenState();
}

class _ChatBoxScreenState extends State<ChatBoxScreen> {
  final TextGenerationService _textGenerationService = TextGenerationService();
  final TextEditingController _textController = TextEditingController();
  List<String> _chatMessages = [];

  void _handleSendMessage(String message) {
    if (message.isNotEmpty) {
      setState(() {
        _chatMessages.add('User: $message');
      });

      // Save message to Firestore
      _saveMessageToFirestore('User', message);

      // Call your chatbot service here to process the message and get a response
      _getChatbotResponse(message);
      _textController.clear();
    }
  }

  void _getChatbotResponse(String message) async {
    try {
      final String response = await _textGenerationService.generateText(message);
      setState(() {
        _chatMessages.add('Chatbot: $response');
      });

      // Save chatbot response to Firestore
      _saveMessageToFirestore('Chatbot', response);
    } catch (e) {
      print('Error generating text: $e');
      setState(() {
        _chatMessages.add('Chatbot: Sorry, an error occurred.');
      });

      // Save error message to Firestore
      _saveMessageToFirestore('Chatbot', 'Sorry, an error occurred.');
    }
  }

  void _saveMessageToFirestore(String sender, String message) {
    try {
      FirebaseFirestore.instance
          .collection('userMessages')
          .doc(widget.userId)
          .collection('messages')
          .add({
        'sender': sender,
        'message': message,
        'timestamp': Timestamp.now(),
      });
    } catch (e) {
      print('Error saving message to Firestore: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('AI Library Assistant'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            child: StreamBuilder(
              stream: FirebaseFirestore.instance
                  .collection('userMessages')
                  .doc(widget.userId)
                  .collection('messages')
                  .orderBy('timestamp', descending: true)
                  .snapshots(),
              builder: (BuildContext context, AsyncSnapshot<QuerySnapshot> snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                }

                final List<QueryDocumentSnapshot> messages = snapshot.data!.docs;

                return ListView.builder(
                  reverse: true,
                  itemCount: messages.length,
                  itemBuilder: (BuildContext context, int index) {
                    final message = messages[index].data() as Map<String, dynamic>;
                    final isUser = message['sender'] == 'User';
                    return Align(
                      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
                      child: Container(
                        decoration: BoxDecoration(
                          color: isUser ? Colors.blue : Colors.grey,
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
                        margin: const EdgeInsets.symmetric(vertical: 4.0, horizontal: 8.0),
                        child: Text(
                          '${message['sender']}: ${message['message']}',
                          style: TextStyle(color: Colors.white),
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          const Divider(),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: <Widget>[
                Expanded(
                  child: TextField(
                    controller: _textController,
                    decoration: const InputDecoration(hintText: 'Type a message...'),
                    onSubmitted: _handleSendMessage,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.send),
                  onPressed: () => _handleSendMessage(_textController.text),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}