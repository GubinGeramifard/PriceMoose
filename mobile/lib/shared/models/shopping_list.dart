// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'shopping_list.freezed.dart';
part 'shopping_list.g.dart';

@freezed
class ShoppingListItem with _$ShoppingListItem {
  const factory ShoppingListItem({
    required String upc,
    required String name,
    String? brand,
    String? imageUrl,
    @Default(1) int quantity,
  }) = _ShoppingListItem;

  factory ShoppingListItem.fromJson(Map<String, dynamic> json) =>
      _$ShoppingListItemFromJson(json);
}

@freezed
class BasketStore with _$BasketStore {
  const factory BasketStore({
    @JsonKey(name: 'store_id') required String storeId,
    required String chain,
    String? banner,
    @JsonKey(name: 'store_name') required String storeName,
    String? city,
    String? province,
    @JsonKey(name: 'distance_km') required double distanceKm,
    @JsonKey(name: 'total_cents') required int totalCents,
    @JsonKey(name: 'total_display') required String totalDisplay,
    @JsonKey(name: 'items_found') required int itemsFound,
    @JsonKey(name: 'items_missing') required int itemsMissing,
    @JsonKey(name: 'item_prices') required List<BasketItemPrice> itemPrices,
  }) = _BasketStore;

  factory BasketStore.fromJson(Map<String, dynamic> json) => _$BasketStoreFromJson(json);
}

@freezed
class BasketItemPrice with _$BasketItemPrice {
  const factory BasketItemPrice({
    required String upc,
    @JsonKey(name: 'product_name') required String productName,
    required int quantity,
    @JsonKey(name: 'unit_price_cents') required int unitPriceCents,
    @JsonKey(name: 'unit_price_display') required String unitPriceDisplay,
    @JsonKey(name: 'subtotal_cents') required int subtotalCents,
    @JsonKey(name: 'subtotal_display') required String subtotalDisplay,
    @JsonKey(name: 'on_sale') required bool onSale,
  }) = _BasketItemPrice;

  factory BasketItemPrice.fromJson(Map<String, dynamic> json) =>
      _$BasketItemPriceFromJson(json);
}

@freezed
class CompareResponse with _$CompareResponse {
  const factory CompareResponse({
    required List<BasketStore> stores,
    @JsonKey(name: 'cheapest_store_id') String? cheapestStoreId,
    @JsonKey(name: 'total_items_requested') required int totalItemsRequested,
  }) = _CompareResponse;

  factory CompareResponse.fromJson(Map<String, dynamic> json) =>
      _$CompareResponseFromJson(json);
}