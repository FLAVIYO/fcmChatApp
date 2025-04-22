// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'chat_item_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$ChatItemModel {

 String get image; String get name; String get message; String get time; int get unreadCount; bool get isRead;
/// Create a copy of ChatItemModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$ChatItemModelCopyWith<ChatItemModel> get copyWith => _$ChatItemModelCopyWithImpl<ChatItemModel>(this as ChatItemModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is ChatItemModel&&(identical(other.image, image) || other.image == image)&&(identical(other.name, name) || other.name == name)&&(identical(other.message, message) || other.message == message)&&(identical(other.time, time) || other.time == time)&&(identical(other.unreadCount, unreadCount) || other.unreadCount == unreadCount)&&(identical(other.isRead, isRead) || other.isRead == isRead));
}


@override
int get hashCode => Object.hash(runtimeType,image,name,message,time,unreadCount,isRead);

@override
String toString() {
  return 'ChatItemModel(image: $image, name: $name, message: $message, time: $time, unreadCount: $unreadCount, isRead: $isRead)';
}


}

/// @nodoc
abstract mixin class $ChatItemModelCopyWith<$Res>  {
  factory $ChatItemModelCopyWith(ChatItemModel value, $Res Function(ChatItemModel) _then) = _$ChatItemModelCopyWithImpl;
@useResult
$Res call({
 String image, String name, String message, String time, int unreadCount, bool isRead
});




}
/// @nodoc
class _$ChatItemModelCopyWithImpl<$Res>
    implements $ChatItemModelCopyWith<$Res> {
  _$ChatItemModelCopyWithImpl(this._self, this._then);

  final ChatItemModel _self;
  final $Res Function(ChatItemModel) _then;

/// Create a copy of ChatItemModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? image = null,Object? name = null,Object? message = null,Object? time = null,Object? unreadCount = null,Object? isRead = null,}) {
  return _then(_self.copyWith(
image: null == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String,unreadCount: null == unreadCount ? _self.unreadCount : unreadCount // ignore: cast_nullable_to_non_nullable
as int,isRead: null == isRead ? _self.isRead : isRead // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// @nodoc


class _ChatItemModel implements ChatItemModel {
  const _ChatItemModel({required this.image, required this.name, required this.message, required this.time, required this.unreadCount, required this.isRead});
  

@override final  String image;
@override final  String name;
@override final  String message;
@override final  String time;
@override final  int unreadCount;
@override final  bool isRead;

/// Create a copy of ChatItemModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$ChatItemModelCopyWith<_ChatItemModel> get copyWith => __$ChatItemModelCopyWithImpl<_ChatItemModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _ChatItemModel&&(identical(other.image, image) || other.image == image)&&(identical(other.name, name) || other.name == name)&&(identical(other.message, message) || other.message == message)&&(identical(other.time, time) || other.time == time)&&(identical(other.unreadCount, unreadCount) || other.unreadCount == unreadCount)&&(identical(other.isRead, isRead) || other.isRead == isRead));
}


@override
int get hashCode => Object.hash(runtimeType,image,name,message,time,unreadCount,isRead);

@override
String toString() {
  return 'ChatItemModel(image: $image, name: $name, message: $message, time: $time, unreadCount: $unreadCount, isRead: $isRead)';
}


}

/// @nodoc
abstract mixin class _$ChatItemModelCopyWith<$Res> implements $ChatItemModelCopyWith<$Res> {
  factory _$ChatItemModelCopyWith(_ChatItemModel value, $Res Function(_ChatItemModel) _then) = __$ChatItemModelCopyWithImpl;
@override @useResult
$Res call({
 String image, String name, String message, String time, int unreadCount, bool isRead
});




}
/// @nodoc
class __$ChatItemModelCopyWithImpl<$Res>
    implements _$ChatItemModelCopyWith<$Res> {
  __$ChatItemModelCopyWithImpl(this._self, this._then);

  final _ChatItemModel _self;
  final $Res Function(_ChatItemModel) _then;

/// Create a copy of ChatItemModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? image = null,Object? name = null,Object? message = null,Object? time = null,Object? unreadCount = null,Object? isRead = null,}) {
  return _then(_ChatItemModel(
image: null == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String,name: null == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String,message: null == message ? _self.message : message // ignore: cast_nullable_to_non_nullable
as String,time: null == time ? _self.time : time // ignore: cast_nullable_to_non_nullable
as String,unreadCount: null == unreadCount ? _self.unreadCount : unreadCount // ignore: cast_nullable_to_non_nullable
as int,isRead: null == isRead ? _self.isRead : isRead // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
