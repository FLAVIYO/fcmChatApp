// dart format width=80
// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'story_item_model.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

// dart format off
T _$identity<T>(T value) => value;
/// @nodoc
mixin _$StoryItemModel {

 String? get id; String? get name; String? get image; String? get videoUrl; String? get caption; DateTime? get postedAt; bool get isAddStory; bool get isViewed;
/// Create a copy of StoryItemModel
/// with the given fields replaced by the non-null parameter values.
@JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
$StoryItemModelCopyWith<StoryItemModel> get copyWith => _$StoryItemModelCopyWithImpl<StoryItemModel>(this as StoryItemModel, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is StoryItemModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.image, image) || other.image == image)&&(identical(other.videoUrl, videoUrl) || other.videoUrl == videoUrl)&&(identical(other.caption, caption) || other.caption == caption)&&(identical(other.postedAt, postedAt) || other.postedAt == postedAt)&&(identical(other.isAddStory, isAddStory) || other.isAddStory == isAddStory)&&(identical(other.isViewed, isViewed) || other.isViewed == isViewed));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,image,videoUrl,caption,postedAt,isAddStory,isViewed);

@override
String toString() {
  return 'StoryItemModel(id: $id, name: $name, image: $image, videoUrl: $videoUrl, caption: $caption, postedAt: $postedAt, isAddStory: $isAddStory, isViewed: $isViewed)';
}


}

/// @nodoc
abstract mixin class $StoryItemModelCopyWith<$Res>  {
  factory $StoryItemModelCopyWith(StoryItemModel value, $Res Function(StoryItemModel) _then) = _$StoryItemModelCopyWithImpl;
@useResult
$Res call({
 String? id, String? name, String? image, String? videoUrl, String? caption, DateTime? postedAt, bool isAddStory, bool isViewed
});




}
/// @nodoc
class _$StoryItemModelCopyWithImpl<$Res>
    implements $StoryItemModelCopyWith<$Res> {
  _$StoryItemModelCopyWithImpl(this._self, this._then);

  final StoryItemModel _self;
  final $Res Function(StoryItemModel) _then;

/// Create a copy of StoryItemModel
/// with the given fields replaced by the non-null parameter values.
@pragma('vm:prefer-inline') @override $Res call({Object? id = freezed,Object? name = freezed,Object? image = freezed,Object? videoUrl = freezed,Object? caption = freezed,Object? postedAt = freezed,Object? isAddStory = null,Object? isViewed = null,}) {
  return _then(_self.copyWith(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,image: freezed == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String?,videoUrl: freezed == videoUrl ? _self.videoUrl : videoUrl // ignore: cast_nullable_to_non_nullable
as String?,caption: freezed == caption ? _self.caption : caption // ignore: cast_nullable_to_non_nullable
as String?,postedAt: freezed == postedAt ? _self.postedAt : postedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isAddStory: null == isAddStory ? _self.isAddStory : isAddStory // ignore: cast_nullable_to_non_nullable
as bool,isViewed: null == isViewed ? _self.isViewed : isViewed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}

}


/// @nodoc


class _StoryItemModel implements StoryItemModel {
  const _StoryItemModel({this.id, this.name, this.image, this.videoUrl, this.caption, this.postedAt, this.isAddStory = false, this.isViewed = false});
  

@override final  String? id;
@override final  String? name;
@override final  String? image;
@override final  String? videoUrl;
@override final  String? caption;
@override final  DateTime? postedAt;
@override@JsonKey() final  bool isAddStory;
@override@JsonKey() final  bool isViewed;

/// Create a copy of StoryItemModel
/// with the given fields replaced by the non-null parameter values.
@override @JsonKey(includeFromJson: false, includeToJson: false)
@pragma('vm:prefer-inline')
_$StoryItemModelCopyWith<_StoryItemModel> get copyWith => __$StoryItemModelCopyWithImpl<_StoryItemModel>(this, _$identity);



@override
bool operator ==(Object other) {
  return identical(this, other) || (other.runtimeType == runtimeType&&other is _StoryItemModel&&(identical(other.id, id) || other.id == id)&&(identical(other.name, name) || other.name == name)&&(identical(other.image, image) || other.image == image)&&(identical(other.videoUrl, videoUrl) || other.videoUrl == videoUrl)&&(identical(other.caption, caption) || other.caption == caption)&&(identical(other.postedAt, postedAt) || other.postedAt == postedAt)&&(identical(other.isAddStory, isAddStory) || other.isAddStory == isAddStory)&&(identical(other.isViewed, isViewed) || other.isViewed == isViewed));
}


@override
int get hashCode => Object.hash(runtimeType,id,name,image,videoUrl,caption,postedAt,isAddStory,isViewed);

@override
String toString() {
  return 'StoryItemModel(id: $id, name: $name, image: $image, videoUrl: $videoUrl, caption: $caption, postedAt: $postedAt, isAddStory: $isAddStory, isViewed: $isViewed)';
}


}

/// @nodoc
abstract mixin class _$StoryItemModelCopyWith<$Res> implements $StoryItemModelCopyWith<$Res> {
  factory _$StoryItemModelCopyWith(_StoryItemModel value, $Res Function(_StoryItemModel) _then) = __$StoryItemModelCopyWithImpl;
@override @useResult
$Res call({
 String? id, String? name, String? image, String? videoUrl, String? caption, DateTime? postedAt, bool isAddStory, bool isViewed
});




}
/// @nodoc
class __$StoryItemModelCopyWithImpl<$Res>
    implements _$StoryItemModelCopyWith<$Res> {
  __$StoryItemModelCopyWithImpl(this._self, this._then);

  final _StoryItemModel _self;
  final $Res Function(_StoryItemModel) _then;

/// Create a copy of StoryItemModel
/// with the given fields replaced by the non-null parameter values.
@override @pragma('vm:prefer-inline') $Res call({Object? id = freezed,Object? name = freezed,Object? image = freezed,Object? videoUrl = freezed,Object? caption = freezed,Object? postedAt = freezed,Object? isAddStory = null,Object? isViewed = null,}) {
  return _then(_StoryItemModel(
id: freezed == id ? _self.id : id // ignore: cast_nullable_to_non_nullable
as String?,name: freezed == name ? _self.name : name // ignore: cast_nullable_to_non_nullable
as String?,image: freezed == image ? _self.image : image // ignore: cast_nullable_to_non_nullable
as String?,videoUrl: freezed == videoUrl ? _self.videoUrl : videoUrl // ignore: cast_nullable_to_non_nullable
as String?,caption: freezed == caption ? _self.caption : caption // ignore: cast_nullable_to_non_nullable
as String?,postedAt: freezed == postedAt ? _self.postedAt : postedAt // ignore: cast_nullable_to_non_nullable
as DateTime?,isAddStory: null == isAddStory ? _self.isAddStory : isAddStory // ignore: cast_nullable_to_non_nullable
as bool,isViewed: null == isViewed ? _self.isViewed : isViewed // ignore: cast_nullable_to_non_nullable
as bool,
  ));
}


}

// dart format on
