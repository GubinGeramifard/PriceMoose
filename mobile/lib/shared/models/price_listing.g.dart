// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'price_listing.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$PriceListingImpl _$$PriceListingImplFromJson(Map<String, dynamic> json) =>
    _$PriceListingImpl(
      storeId: json['store_id'] as String,
      chain: json['chain'] as String,
      banner: json['banner'] as String?,
      storeName: json['store_name'] as String,
      city: json['city'] as String?,
      province: json['province'] as String?,
      lat: (json['lat'] as num?)?.toDouble(),
      lng: (json['lng'] as num?)?.toDouble(),
      distanceKm: (json['distance_km'] as num?)?.toDouble(),
      priceCents: (json['price_cents'] as num).toInt(),
      priceDisplay: json['price_display'] as String,
      unit: json['unit'] as String?,
      onSale: json['on_sale'] as bool,
      salePriceCents: (json['sale_price_cents'] as num?)?.toInt(),
      salePriceDisplay: json['sale_price_display'] as String?,
      scrapedAt: json['scraped_at'] as String,
    );

Map<String, dynamic> _$$PriceListingImplToJson(_$PriceListingImpl instance) =>
    <String, dynamic>{
      'store_id': instance.storeId,
      'chain': instance.chain,
      'banner': instance.banner,
      'store_name': instance.storeName,
      'city': instance.city,
      'province': instance.province,
      'lat': instance.lat,
      'lng': instance.lng,
      'distance_km': instance.distanceKm,
      'price_cents': instance.priceCents,
      'price_display': instance.priceDisplay,
      'unit': instance.unit,
      'on_sale': instance.onSale,
      'sale_price_cents': instance.salePriceCents,
      'sale_price_display': instance.salePriceDisplay,
      'scraped_at': instance.scrapedAt,
    };
