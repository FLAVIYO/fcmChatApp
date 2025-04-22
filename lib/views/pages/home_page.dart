import 'package:fcmchatapp/models/chat_item_model.dart';
import 'package:fcmchatapp/models/story_item_model.dart';
import 'package:fcmchatapp/services/auth_service.dart';
import 'package:fcmchatapp/services/navigation_service.dart';
import 'package:fcmchatapp/utils/app_routes.dart';
import 'package:fcmchatapp/utils/service_locator.dart';
import 'package:fcmchatapp/views/widgets/bottom_nav_bar.dart';
import 'package:fcmchatapp/views/widgets/chat_item.dart';
import 'package:fcmchatapp/views/widgets/story_item.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: buildUi(),
      bottomNavigationBar: const BottomNavBar(),
    );
  }

  Widget buildUi() {
    return SafeArea(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildHeader(),
          _buildStory(),
          const Padding(
            padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 8),
            child: Text(
              'Chats',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
          ),
          _buildChats(),
        ],
      ),
    );
  }

  Widget _buildHeader() {

    final authService = GetIt.instance<AuthService<User>>();
    final NavigationService _navigationService = getIt<NavigationService>();
    
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          StreamBuilder<User?>(
            stream: authService.authStateChanges,
            builder: (context, snapshot) {
              final user = snapshot.data;
              return GestureDetector(
                onTap: () => _navigationService.navigateTo(Routes.profile),
                child: CircleAvatar(
                  radius: 18,
                  backgroundImage: user?.photoURL != null
                      ? NetworkImage(user!.photoURL!)
                      : null,
                  child: user?.photoURL == null
                      ? const Icon(Icons.person, size: 18)
                      : null,
                ),
              );
            },
          ),
          const Text(
            "Chats",
            style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
          ),
          Icon(Icons.search, size: 28),
        ],
      ),
    );
  }

  Widget _buildStory() {
    final stories = [
      const StoryItemModel(isAddStory: true),
      StoryItemModel(image: 'https://i.pravatar.cc/150?img=1', name: 'Terry'),
      StoryItemModel(image: 'https://i.pravatar.cc/150?img=2', name: 'Craig'),
      StoryItemModel(image: 'https://i.pravatar.cc/150?img=3', name: 'Roger'),
      StoryItemModel(image: 'https://i.pravatar.cc/150?img=4', name: 'Nolan'),
      // Add more stories as needed
    ];

    return SizedBox(
      height: 90,
      child: ListView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.only(left: 16),
        children: stories.map((story) => StoryItem(story: story)).toList(),
      ),
    );
  }

  Widget _buildChats() {
    final chats = [
      ChatItemModel(
        image: 'https://i.pravatar.cc/150?img=5',
        name: 'Angel Curtis',
        message: 'Please help me find a good monitor for t...',
        time: '02:11',
        unreadCount: 2,
        isRead: false,
      ),
      // Add other chat items
    ];

    return Expanded(
      child: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        children: chats.map((chat) => ChatItem(chat: chat)).toList(),
      ),
    );
  }
}