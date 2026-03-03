// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'price_listing.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

PriceListing _$PriceListingFromJson(Map<String, dynamic> json) {
  return _PriceListing.fromJson(json);
}

/// @nodoc
mixin _$PriceListing {
  @JsonKey(name: 'store_id')
  String get storeId => throw _privateConstructorUsedError;
  String get chain => throw _privateConstructorUsedError;
  String? get banner => throw _privateConstructorUsedError;
  @JsonKey(name: 'store_name')
  String get storeName => throw _privateConstructorUsedError;
  String? get city => throw _privateConstructorUsedError;
  String? get province => throw _privateConstructorUsedError;
  double? get lat => throw _privateConstructorUsedError;
  double? get lng => throw _privateConstructorUsedError;
  @JsonKey(name: 'distance_km')
  double? get distanceKm => throw _privateConstructorUsedError;
  @JsonKey(name: 'price_cents')
  int get priceCents => throw _privateConstructorUsedError;
  @JsonKey(name: 'price_display')
  String get priceDisplay => throw _privateConstructorUsedError;
  String? get unit => throw _privateConstructorUsedError;
  @JsonKey(name: 'on_sale')
  bool get onSale => throw _privateConstructorUsedError;
  @JsonKey(name: 'sale_price_cents')
  int? get salePriceCents => throw _privateConstructorUsedError;
  @JsonKey(name: 'sale_price_display')
  String? get salePriceDisplay => throw _privateConstructorUsedError;
  @JsonKey(name: 'scraped_at')
  String get scrapedAt => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $PriceListingCopyWith<PriceListing> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $PriceListingCopyWith<$Res> {
  factory $PriceListingCopyWith(
          PriceListing value, $Res Function(PriceListing) then) =
      _$PriceListingCopyWithImpl<$Res, PriceListing>;
  @useResult
  $Res call(
      {@JsonKey(name: 'store_id') String storeId,
      String chain,
      String? banner,
      @JsonKey(name: 'store_name') String storeName,
      String? city,
      String? province,
      double? lat,
      double? lng,
      @JsonKey(name: 'distance_km') double? distanceKm,
      @JsonKey(name: 'price_cents') int priceCents,
      @JsonKey(name: 'price_display') String priceDisplay,
      String? unit,
      @JsonKey(name: 'on_sale') bool onSale,
      @JsonKey(name: 'sale_price_cents') int? salePriceCents,
      @JsonKey(name: 'sale_price_display') String? salePriceDisplay,
      @JsonKey(name: 'scraped_at') String scrapedAt});
}

/// @nodoc
class _$PriceListingCopyWithImpl<$Res, $Val extends PriceListing>
    implements $PriceListingCopyWith<$Res> {
  _$PriceListingCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? storeId = null,
    Object? chain = null,
    Object? banner = freezed,
    Object? storeName = null,
    Object? city = freezed,
    Object? province = freezed,
    Object? lat = freezed,
    Object? lng = freezed,
    Object? distanceKm = freezed,
    Object? priceCents = null,
    Object? priceDisplay = null,
    Object? unit = freezed,
    Object? onSale = null,
    Object? salePriceCents = freezed,
    Object? salePriceDisplay = freezed,
    Object? scrapedAt = null,
  }) {
    return _then(_value.copyWith(
      storeId: null == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String,
      chain: null == chain
          ? _value.chain
          : chain // ignore: cast_nullable_to_non_nullable
              as String,
      banner: freezed == banner
          ? _value.banner
          : banner // ignore: cast_nullable_to_non_nullable
              as String?,
      storeName: null == storeName
          ? _value.storeName
          : storeName // ignore: cast_nullable_to_non_nullable
              as String,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      province: freezed == province
          ? _value.province
          : province // ignore: cast_nullable_to_non_nullable
              as String?,
      lat: freezed == lat
          ? _value.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as double?,
      lng: freezed == lng
          ? _value.lng
          : lng // ignore: cast_nullable_to_non_nullable
              as double?,
      distanceKm: freezed == distanceKm
          ? _value.distanceKm
          : distanceKm // ignore: cast_nullable_to_non_nullable
              as double?,
      priceCents: null == priceCents
          ? _value.priceCents
          : priceCents // ignore: cast_nullable_to_non_nullable
              as int,
      priceDisplay: null == priceDisplay
          ? _value.priceDisplay
          : priceDisplay // ignore: cast_nullable_to_non_nullable
              as String,
      unit: freezed == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String?,
      onSale: null == onSale
          ? _value.onSale
          : onSale // ignore: cast_nullable_to_non_nullable
              as bool,
      salePriceCents: freezed == salePriceCents
          ? _value.salePriceCents
          : salePriceCents // ignore: cast_nullable_to_non_nullable
              as int?,
      salePriceDisplay: freezed == salePriceDisplay
          ? _value.salePriceDisplay
          : salePriceDisplay // ignore: cast_nullable_to_non_nullable
              as String?,
      scrapedAt: null == scrapedAt
          ? _value.scrapedAt
          : scrapedAt // ignore: cast_nullable_to_non_nullable
              as String,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$PriceListingImplCopyWith<$Res>
    implements $PriceListingCopyWith<$Res> {
  factory _$$PriceListingImplCopyWith(
          _$PriceListingImpl value, $Res Function(_$PriceListingImpl) then) =
      __$$PriceListingImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'store_id') String storeId,
      String chain,
      String? banner,
      @JsonKey(name: 'store_name') String storeName,
      String? city,
      String? province,
      double? lat,
      double? lng,
      @JsonKey(name: 'distance_km') double? distanceKm,
      @JsonKey(name: 'price_cents') int priceCents,
      @JsonKey(name: 'price_display') String priceDisplay,
      String? unit,
      @JsonKey(name: 'on_sale') bool onSale,
      @JsonKey(name: 'sale_price_cents') int? salePriceCents,
      @JsonKey(name: 'sale_price_display') String? salePriceDisplay,
      @JsonKey(name: 'scraped_at') String scrapedAt});
}

/// @nodoc
class __$$PriceListingImplCopyWithImpl<$Res>
    extends _$PriceListingCopyWithImpl<$Res, _$PriceListingImpl>
    implements _$$PriceListingImplCopyWith<$Res> {
  __$$PriceListingImplCopyWithImpl(
      _$PriceListingImpl _value, $Res Function(_$PriceListingImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? storeId = null,
    Object? chain = null,
    Object? banner = freezed,
    Object? storeName = null,
    Object? city = freezed,
    Object? province = freezed,
    Object? lat = freezed,
    Object? lng = freezed,
    Object? distanceKm = freezed,
    Object? priceCents = null,
    Object? priceDisplay = null,
    Object? unit = freezed,
    Object? onSale = null,
    Object? salePriceCents = freezed,
    Object? salePriceDisplay = freezed,
    Object? scrapedAt = null,
  }) {
    return _then(_$PriceListingImpl(
      storeId: null == storeId
          ? _value.storeId
          : storeId // ignore: cast_nullable_to_non_nullable
              as String,
      chain: null == chain
          ? _value.chain
          : chain // ignore: cast_nullable_to_non_nullable
              as String,
      banner: freezed == banner
          ? _value.banner
          : banner // ignore: cast_nullable_to_non_nullable
              as String?,
      storeName: null == storeName
          ? _value.storeName
          : storeName // ignore: cast_nullable_to_non_nullable
              as String,
      city: freezed == city
          ? _value.city
          : city // ignore: cast_nullable_to_non_nullable
              as String?,
      province: freezed == province
          ? _value.province
          : province // ignore: cast_nullable_to_non_nullable
              as String?,
      lat: freezed == lat
          ? _value.lat
          : lat // ignore: cast_nullable_to_non_nullable
              as double?,
      lng: freezed == lng
          ? _value.lng
          : lng // ignore: cast_nullable_to_non_nullable
              as double?,
      distanceKm: freezed == distanceKm
          ? _value.distanceKm
          : distanceKm // ignore: cast_nullable_to_non_nullable
              as double?,
      priceCents: null == priceCents
          ? _value.priceCents
          : priceCents // ignore: cast_nullable_to_non_nullable
              as int,
      priceDisplay: null == priceDisplay
          ? _value.priceDisplay
          : priceDisplay // ignore: cast_nullable_to_non_nullable
              as String,
      unit: freezed == unit
          ? _value.unit
          : unit // ignore: cast_nullable_to_non_nullable
              as String?,
      onSale: null == onSale
          ? _value.onSale
          : onSale // ignore: cast_nullable_to_non_nullable
              as bool,
      salePriceCents: freezed == salePriceCents
          ? _value.salePriceCents
          : salePriceCents // ignore: cast_nullable_to_non_nullable
              as int?,
      salePriceDisplay: freezed == salePriceDisplay
          ? _value.salePriceDisplay
          : salePriceDisplay // ignore: cast_nullable_to_non_nullable
              as String?,
      scrapedAt: null == scrapedAt
          ? _value.scrapedAt
          : scrapedAt // ignore: cast_nullable_to_non_nullable
              as String,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$PriceListingImpl implements _PriceListing {
  const _$PriceListingImpl(
      {@JsonKey(name: 'store_id') required this.storeId,
      required this.chain,
      this.banner,
      @JsonKey(name: 'store_name') required this.storeName,
      this.city,
      this.province,
      this.lat,
      this.lng,
      @JsonKey(name: 'distance_km') this.distanceKm,
      @JsonKey(name: 'price_cents') required this.priceCents,
      @JsonKey(name: 'price_display') required this.priceDisplay,
      this.unit,
      @JsonKey(name: 'on_sale') required this.onSale,
      @JsonKey(name: 'sale_price_cents') this.salePriceCents,
      @JsonKey(name: 'sale_price_display') this.salePriceDisplay,
      @JsonKey(name: 'scraped_at') required this.scrapedAt});

  factory _$PriceListingImpl.fromJson(Map<String, dynamic> json) =>
      _$$PriceListingImplFromJson(json);

  @override
  @JsonKey(name: 'store_id')
  final String storeId;
  @override
  final String chain;
  @override
  final String? banner;
  @override
  @JsonKey(name: 'store_name')
  final String storeName;
  @override
  final String? city;
  @override
  final String? province;
  @override
  final double? lat;
  @override
  final double? lng;
  @override
  @JsonKey(name: 'distance_km')
  final double? distanceKm;
  @override
  @JsonKey(name: 'price_cents')
  final int priceCents;
  @override
  @JsonKey(name: 'price_display')
  final String priceDisplay;
  @override
  final String? unit;
  @override
  @JsonKey(name: 'on_sale')
  final bool onSale;
  @override
  @JsonKey(name: 'sale_price_cents')
  final int? salePriceCents;
  @override
  @JsonKey(name: 'sale_price_display')
  final String? salePriceDisplay;
  @override
  @JsonKey(name: 'scraped_at')
  final String scrapedAt;

  @override
  String toString() {
    return 'PriceListing(storeId: $storeId, chain: $chain, banner: $banner, storeName: $storeName, city: $city, province: $province, lat: $lat, lng: $lng, distanceKm: $distanceKm, priceCents: $priceCents, priceDisplay: $priceDisplay, unit: $unit, onSale: $onSale, salePriceCents: $salePriceCents, salePriceDisplay: $salePriceDisplay, scrapedAt: $scrapedAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$PriceListingImpl &&
            (identical(other.storeId, storeId) || other.storeId == storeId) &&
            (identical(other.chain, chain) || other.chain == chain) &&
            (identical(other.banner, banner) || other.banner == banner) &&
            (identical(other.storeName, storeName) ||
                other.storeName == storeName) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.province, province) ||
                other.province == province) &&
            (identical(other.lat, lat) || other.lat == lat) &&
            (identical(other.lng, lng) || other.lng == lng) &&
            (identical(other.distanceKm, distanceKm) ||
                other.distanceKm == distanceKm) &&
            (identical(other.priceCents, priceCents) ||
                other.priceCents == priceCents) &&
            (identical(other.priceDisplay, priceDisplay) ||
                other.priceDisplay == priceDisplay) &&
            (identical(other.unit, unit) || other.unit == unit) &&
            (identical(other.onSale, onSale) || other.onSale == onSale) &&
            (identical(other.salePriceCents, salePriceCents) ||
                other.salePriceCents == salePriceCents) &&
            (identical(other.salePriceDisplay, salePriceDisplay) ||
                other.salePriceDisplay == salePriceDisplay) &&
            (identical(other.scrapedAt, scrapedAt) ||
                other.scrapedAt == scrapedAt));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      storeId,
      chain,
      banner,
      storeName,
      city,
      province,
      lat,
      lng,
      distanceKm,
      priceCents,
      priceDisplay,
      unit,
      onSale,
      salePriceCents,
      salePriceDisplay,
      scrapedAt);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$PriceListingImplCopyWith<_$PriceListingImpl> get copyWith =>
      __$$PriceListingImplCopyWithImpl<_$PriceListingImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$PriceListingImplToJson(
      this,
    );
  }
}

abstract class _PriceListing implements PriceListing {
  const factory _PriceListing(
          {@JsonKey(name: 'store_id') required final String storeId,
          required final String chain,
          final String? banner,
          @JsonKey(name: 'store_name') required final String storeName,
          final String? city,
          final String? province,
          final double? lat,
          final double? lng,
          @JsonKey(name: 'distance_km') final double? distanceKm,
          @JsonKey(name: 'price_cents') required final int priceCents,
          @JsonKey(name: 'price_display') required final String priceDisplay,
          final String? unit,
          @JsonKey(name: 'on_sale') required final bool onSale,
          @JsonKey(name: 'sale_price_cents') final int? salePriceCents,
          @JsonKey(name: 'sale_price_display') final String? salePriceDisplay,
          @JsonKey(name: 'scraped_at') required final String scrapedAt}) =
      _$PriceListingImpl;

  factory _PriceListing.fromJson(Map<String, dynamic> json) =
      _$PriceListingImpl.fromJson;

  @override
  @JsonKey(name: 'store_id')
  String get storeId;
  @override
  String get chain;
  @override
  String? get banner;
  @override
  @JsonKey(name: 'store_name')
  String get storeName;
  @override
  String? get city;
  @override
  String? get province;
  @override
  double? get lat;
  @override
  double? get lng;
  @override
  @JsonKey(name: 'distance_km')
  double? get distanceKm;
  @override
  @JsonKey(name: 'price_cents')
  int get priceCents;
  @override
  @JsonKey(name: 'price_display')
  String get priceDisplay;
  @override
  String? get unit;
  @override
  @JsonKey(name: 'on_sale')
  bool get onSale;
  @override
  @JsonKey(name: 'sale_price_cents')
  int? get salePriceCents;
  @override
  @JsonKey(name: 'sale_price_display')
  String? get salePriceDisplay;
  @override
  @JsonKey(name: 'scraped_at')
  String get scrapedAt;
  @override
  @JsonKey(ignore: true)
  _$$PriceListingImplCopyWith<_$PriceListingImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
