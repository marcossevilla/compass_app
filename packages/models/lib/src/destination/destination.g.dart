// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'destination.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Destination _$DestinationFromJson(Map<String, dynamic> json) => Destination(
  ref: json['ref'] as String,
  name: json['name'] as String,
  country: json['country'] as String,
  continent: json['continent'] as String,
  knownFor: json['knownFor'] as String,
  tags: (json['tags'] as List<dynamic>).map((e) => e as String).toList(),
  imageUrl: json['imageUrl'] as String,
);

Map<String, dynamic> _$DestinationToJson(Destination instance) =>
    <String, dynamic>{
      'ref': instance.ref,
      'name': instance.name,
      'country': instance.country,
      'continent': instance.continent,
      'knownFor': instance.knownFor,
      'tags': instance.tags,
      'imageUrl': instance.imageUrl,
    };
