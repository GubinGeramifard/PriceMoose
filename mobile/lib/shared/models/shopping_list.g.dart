// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'shopping_list.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ShoppingListItemImpl _$$ShoppingListItemImplFromJson(
        Map<String, dynamic> json) =>
    _$ShoppingListItemImpl(
      upc: json['upc'] as String,
      name: json['name'] as String,
      brand: json['brand'] as String?,
      imageUrl: json['imageUrl'] as String?,
      quantity: (json['quantity'] as num?)?.toInt() ?? 1,
    );

Map<String, dynamic> _$$ShoppingListItemImplToJson(
        _$ShoppingListItemImpl instance) =>
    <String, dynamic>{
      'upc': instance.upc,
      'name': instance.name,
      'brand': instance.brand,
      'imageUrl': instance.imageUrl,
      'quantity': instance.quantity,
    };

_$BasketStoreImpl _$$BasketStoreImplFromJson(Map<String, dynamic> json) =>
    _$BasketStoreImpl(
      storeId: json['store_id'] as String,
      chain: json['chain'] as String,
      banner: json['banner'] as String?,
      storeName: json['store_name'] as String,
      city: json['city'] as String?,
      province: json['province'] as String?,
      distanceKm: (json['distance_km'] as num).toDouble(),
      totalCents: (json['total_cents'] as num).toInt(),
      totalDisplay: json['total_display'] as String,
      itemsFound: (json['items_found'] as num).toInt(),
      itemsMissing: (json['items_missing'] as num).toInt(),
      itemPrices: (json['item_prices'] as List<dynamic>)
          .map((e) => BasketItemPrice.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$$BasketStoreImplToJson(_$BasketStoreImpl instance) =>
    <String, dynamic>{
      'store_id': instance.storeId,
      'chain': instance.chain,
      'banner': instance.banner,
      'store_name': instance.storeName,
      'city': instance.city,
      'province': instance.province,
      'distance_km': instance.distanceKm,
      'total_cents': instance.totalCents,
      'total_display': instance.totalDisplay,
      'items_found': instance.itemsFound,
      'items_missing': instance.itemsMissing,
      'item_prices': instance.itemPrices,
    };

_$BasketItemPriceImpl _$$BasketItemPriceImplFromJson(
        Map<String, dynamic> json) =>
    _$BasketItemPriceImpl(
      upc: json['upc'] as String,
      productName: json['product_name'] as String,
      quantity: (json['quantity'] as num).toInt(),
      unitPriceCents: (json['unit_price_cents'] as num).toInt(),
      unitPriceDisplay: json['unit_price_display'] as String,
      subtotalCents: (json['subtotal_cents'] as num).toInt(),
      subtotalDisplay: json['subtotal_display'] as String,
      onSale: json['on_sale'] as bool,
    );

Map<String, dynamic> _$$BasketItemPriceImplToJson(
        _$BasketItemPriceImpl instance) =>
    <String, dynamic>{
      'upc': instance.upc,
      'product_name': instance.productName,
      'quantity': instance.quantity,
      'unit_price_cents': instance.unitPriceCents,
      'unit_price_display': instance.unitPriceDisplay,
      'subtotal_cents': instance.subtotalCents,
      'subtotal_display': instance.subtotalDisplay,
      'on_sale': instance.onSale,
    };

_$CompareResponseImpl _$$CompareResponseImplFromJson(
        Map<String, dynamic> json) =>
    _$CompareResponseImpl(
      stores: (json['stores'] as List<dynamic>)
          .map((e) => BasketStore.fromJson(e as Map<String, dynamic>))
          .toList(),
      cheapestStoreId: json['cheapest_store_id'] as String?,
      totalItemsRequested: (json['total_items_requested'] as num).toInt(),
    );

Map<String, dynamic> _$$CompareResponseImplToJson(
        _$CompareResponseImpl instance) =>
    <String, dynamic>{
      'stores': instance.stores,
      'cheapest_store_id': instance.cheapestStoreId,
      'total_items_requested': instance.totalItemsRequested,
    };
