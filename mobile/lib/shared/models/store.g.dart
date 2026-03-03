// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'store.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$StoreImpl _$$StoreImplFromJson(Map<String, dynamic> json) => _$StoreImpl(
      id: json['id'] as String,
      chain: json['chain'] as String,
      banner: json['banner'] as String?,
      name: json['name'] as String,
      address: json['address'] as String?,
      city: json['city'] as String?,
      province: json['province'] as String?,
      postalCode: json['postal_code'] as String?,
      lat: (json['lat'] as num?)?.toDouble(),
      lng: (json['lng'] as num?)?.toDouble(),
      distanceKm: (json['distance_km'] as num?)?.toDouble(),
    );

Map<String, dynamic> _$$StoreImplToJson(_$StoreImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'chain': instance.chain,
      'banner': instance.banner,
      'name': instance.name,
      'address': instance.address,
      'city': instance.city,
      'province': instance.province,
      'postal_code': instance.postalCode,
      'lat': instance.lat,
      'lng': instance.lng,
      'distance_km': instance.distanceKm,
    };
