import 'package:freezed_annotation/freezed_annotation.dart';

part 'story_item_model.freezed.dart';

@freezed
abstract class StoryItemModel with _$StoryItemModel {
  const factory StoryItemModel({
    String? id,
    String? name,
    String? image, 
    String? videoUrl, 
    String? caption,
    DateTime? postedAt,
    @Default(false) bool isAddStory,
    @Default(false) bool isViewed,
  }) = _StoryItemModel;
}
