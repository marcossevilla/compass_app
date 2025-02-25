// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

User _$UserFromJson(Map<String, dynamic> json) =>
    User(name: json['name'] as String, picture: json['picture'] as String);

Map<String, dynamic> _$UserToJson(User instance) => <String, dynamic>{
  'name': instance.name,
  'picture': instance.picture,
};

UserApiModel _$UserApiModelFromJson(Map<String, dynamic> json) => UserApiModel(
  id: json['id'] as String,
  email: json['email'] as String,
  name: json['name'] as String,
  picture: json['picture'] as String,
);

Map<String, dynamic> _$UserApiModelToJson(UserApiModel instance) =>
    <String, dynamic>{
      'name': instance.name,
      'picture': instance.picture,
      'id': instance.id,
      'email': instance.email,
    };
