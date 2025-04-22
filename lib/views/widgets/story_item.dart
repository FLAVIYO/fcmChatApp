import 'package:fcmchatapp/models/story_item_model.dart';
import 'package:flutter/material.dart';

class StoryItem extends StatelessWidget {
  final StoryItemModel story;

  const StoryItem({super.key, required this.story});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12.0),
      child: Column(
        children: [
          CircleAvatar(
            radius: 28,
            backgroundColor: Colors.grey.shade200,
            backgroundImage: story.image != null ? NetworkImage(story.image!) : null,
            child: story.isAddStory
                ? const Icon(Icons.add, size: 30, color: Colors.black)
                : null,
          ),
          const SizedBox(height: 6),
          Text(story.name ?? 'Add story', style: const TextStyle(fontSize: 12)),
        ],
      ),
    );
  }
}