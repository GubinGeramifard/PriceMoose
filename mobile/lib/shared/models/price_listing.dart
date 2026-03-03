// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'price_listing.freezed.dart';
part 'price_listing.g.dart';

@freezed
class PriceListing with _$PriceListing {
  const factory PriceListing({
    @JsonKey(name: 'store_id') required String storeId,
    required String chain,
    String? banner,
    @JsonKey(name: 'store_name') required String storeName,
    String? city,
    String? province,
    double? lat,
    double? lng,
    @JsonKey(name: 'distance_km') double? distanceKm,
    @JsonKey(name: 'price_cents') required int priceCents,
    @JsonKey(name: 'price_display') required String priceDisplay,
    String? unit,
    @JsonKey(name: 'on_sale') required bool onSale,
    @JsonKey(name: 'sale_price_cents') int? salePriceCents,
    @JsonKey(name: 'sale_price_display') String? salePriceDisplay,
    @JsonKey(name: 'scraped_at') required String scrapedAt,
  }) = _PriceListing;

  factory PriceListing.fromJson(Map<String, dynamic> json) => _$PriceListingFromJson(json);
}