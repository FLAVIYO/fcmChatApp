import 'package:freezed_annotation/freezed_annotation.dart';

part 'chat_item_model.freezed.dart';

@freezed
abstract class ChatItemModel with _$ChatItemModel {
  const factory ChatItemModel({
    required String image,
    required String name,
    required String message,
    required String time,
    required int unreadCount,
    required bool isRead,
  }) = _ChatItemModel;
}
