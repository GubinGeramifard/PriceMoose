// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'shopping_list.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
    'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models');

ShoppingListItem _$ShoppingListItemFromJson(Map<String, dynamic> json) {
  return _ShoppingListItem.fromJson(json);
}

/// @nodoc
mixin _$ShoppingListItem {
  String get upc => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get brand => throw _privateConstructorUsedError;
  String? get imageUrl => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $ShoppingListItemCopyWith<ShoppingListItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ShoppingListItemCopyWith<$Res> {
  factory $ShoppingListItemCopyWith(
          ShoppingListItem value, $Res Function(ShoppingListItem) then) =
      _$ShoppingListItemCopyWithImpl<$Res, ShoppingListItem>;
  @useResult
  $Res call(
      {String upc, String name, String? brand, String? imageUrl, int quantity});
}

/// @nodoc
class _$ShoppingListItemCopyWithImpl<$Res, $Val extends ShoppingListItem>
    implements $ShoppingListItemCopyWith<$Res> {
  _$ShoppingListItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? upc = null,
    Object? name = null,
    Object? brand = freezed,
    Object? imageUrl = freezed,
    Object? quantity = null,
  }) {
    return _then(_value.copyWith(
      upc: null == upc
          ? _value.upc
          : upc // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      brand: freezed == brand
          ? _value.brand
          : brand // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$ShoppingListItemImplCopyWith<$Res>
    implements $ShoppingListItemCopyWith<$Res> {
  factory _$$ShoppingListItemImplCopyWith(_$ShoppingListItemImpl value,
          $Res Function(_$ShoppingListItemImpl) then) =
      __$$ShoppingListItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String upc, String name, String? brand, String? imageUrl, int quantity});
}

/// @nodoc
class __$$ShoppingListItemImplCopyWithImpl<$Res>
    extends _$ShoppingListItemCopyWithImpl<$Res, _$ShoppingListItemImpl>
    implements _$$ShoppingListItemImplCopyWith<$Res> {
  __$$ShoppingListItemImplCopyWithImpl(_$ShoppingListItemImpl _value,
      $Res Function(_$ShoppingListItemImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? upc = null,
    Object? name = null,
    Object? brand = freezed,
    Object? imageUrl = freezed,
    Object? quantity = null,
  }) {
    return _then(_$ShoppingListItemImpl(
      upc: null == upc
          ? _value.upc
          : upc // ignore: cast_nullable_to_non_nullable
              as String,
      name: null == name
          ? _value.name
          : name // ignore: cast_nullable_to_non_nullable
              as String,
      brand: freezed == brand
          ? _value.brand
          : brand // ignore: cast_nullable_to_non_nullable
              as String?,
      imageUrl: freezed == imageUrl
          ? _value.imageUrl
          : imageUrl // ignore: cast_nullable_to_non_nullable
              as String?,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$ShoppingListItemImpl implements _ShoppingListItem {
  const _$ShoppingListItemImpl(
      {required this.upc,
      required this.name,
      this.brand,
      this.imageUrl,
      this.quantity = 1});

  factory _$ShoppingListItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$ShoppingListItemImplFromJson(json);

  @override
  final String upc;
  @override
  final String name;
  @override
  final String? brand;
  @override
  final String? imageUrl;
  @override
  @JsonKey()
  final int quantity;

  @override
  String toString() {
    return 'ShoppingListItem(upc: $upc, name: $name, brand: $brand, imageUrl: $imageUrl, quantity: $quantity)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ShoppingListItemImpl &&
            (identical(other.upc, upc) || other.upc == upc) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.brand, brand) || other.brand == brand) &&
            (identical(other.imageUrl, imageUrl) ||
                other.imageUrl == imageUrl) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode =>
      Object.hash(runtimeType, upc, name, brand, imageUrl, quantity);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$ShoppingListItemImplCopyWith<_$ShoppingListItemImpl> get copyWith =>
      __$$ShoppingListItemImplCopyWithImpl<_$ShoppingListItemImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ShoppingListItemImplToJson(
      this,
    );
  }
}

abstract class _ShoppingListItem implements ShoppingListItem {
  const factory _ShoppingListItem(
      {required final String upc,
      required final String name,
      final String? brand,
      final String? imageUrl,
      final int quantity}) = _$ShoppingListItemImpl;

  factory _ShoppingListItem.fromJson(Map<String, dynamic> json) =
      _$ShoppingListItemImpl.fromJson;

  @override
  String get upc;
  @override
  String get name;
  @override
  String? get brand;
  @override
  String? get imageUrl;
  @override
  int get quantity;
  @override
  @JsonKey(ignore: true)
  _$$ShoppingListItemImplCopyWith<_$ShoppingListItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BasketStore _$BasketStoreFromJson(Map<String, dynamic> json) {
  return _BasketStore.fromJson(json);
}

/// @nodoc
mixin _$BasketStore {
  @JsonKey(name: 'store_id')
  String get storeId => throw _privateConstructorUsedError;
  String get chain => throw _privateConstructorUsedError;
  String? get banner => throw _privateConstructorUsedError;
  @JsonKey(name: 'store_name')
  String get storeName => throw _privateConstructorUsedError;
  String? get city => throw _privateConstructorUsedError;
  String? get province => throw _privateConstructorUsedError;
  @JsonKey(name: 'distance_km')
  double get distanceKm => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_cents')
  int get totalCents => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_display')
  String get totalDisplay => throw _privateConstructorUsedError;
  @JsonKey(name: 'items_found')
  int get itemsFound => throw _privateConstructorUsedError;
  @JsonKey(name: 'items_missing')
  int get itemsMissing => throw _privateConstructorUsedError;
  @JsonKey(name: 'item_prices')
  List<BasketItemPrice> get itemPrices => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BasketStoreCopyWith<BasketStore> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BasketStoreCopyWith<$Res> {
  factory $BasketStoreCopyWith(
          BasketStore value, $Res Function(BasketStore) then) =
      _$BasketStoreCopyWithImpl<$Res, BasketStore>;
  @useResult
  $Res call(
      {@JsonKey(name: 'store_id') String storeId,
      String chain,
      String? banner,
      @JsonKey(name: 'store_name') String storeName,
      String? city,
      String? province,
      @JsonKey(name: 'distance_km') double distanceKm,
      @JsonKey(name: 'total_cents') int totalCents,
      @JsonKey(name: 'total_display') String totalDisplay,
      @JsonKey(name: 'items_found') int itemsFound,
      @JsonKey(name: 'items_missing') int itemsMissing,
      @JsonKey(name: 'item_prices') List<BasketItemPrice> itemPrices});
}

/// @nodoc
class _$BasketStoreCopyWithImpl<$Res, $Val extends BasketStore>
    implements $BasketStoreCopyWith<$Res> {
  _$BasketStoreCopyWithImpl(this._value, this._then);

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
    Object? distanceKm = null,
    Object? totalCents = null,
    Object? totalDisplay = null,
    Object? itemsFound = null,
    Object? itemsMissing = null,
    Object? itemPrices = null,
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
      distanceKm: null == distanceKm
          ? _value.distanceKm
          : distanceKm // ignore: cast_nullable_to_non_nullable
              as double,
      totalCents: null == totalCents
          ? _value.totalCents
          : totalCents // ignore: cast_nullable_to_non_nullable
              as int,
      totalDisplay: null == totalDisplay
          ? _value.totalDisplay
          : totalDisplay // ignore: cast_nullable_to_non_nullable
              as String,
      itemsFound: null == itemsFound
          ? _value.itemsFound
          : itemsFound // ignore: cast_nullable_to_non_nullable
              as int,
      itemsMissing: null == itemsMissing
          ? _value.itemsMissing
          : itemsMissing // ignore: cast_nullable_to_non_nullable
              as int,
      itemPrices: null == itemPrices
          ? _value.itemPrices
          : itemPrices // ignore: cast_nullable_to_non_nullable
              as List<BasketItemPrice>,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BasketStoreImplCopyWith<$Res>
    implements $BasketStoreCopyWith<$Res> {
  factory _$$BasketStoreImplCopyWith(
          _$BasketStoreImpl value, $Res Function(_$BasketStoreImpl) then) =
      __$$BasketStoreImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {@JsonKey(name: 'store_id') String storeId,
      String chain,
      String? banner,
      @JsonKey(name: 'store_name') String storeName,
      String? city,
      String? province,
      @JsonKey(name: 'distance_km') double distanceKm,
      @JsonKey(name: 'total_cents') int totalCents,
      @JsonKey(name: 'total_display') String totalDisplay,
      @JsonKey(name: 'items_found') int itemsFound,
      @JsonKey(name: 'items_missing') int itemsMissing,
      @JsonKey(name: 'item_prices') List<BasketItemPrice> itemPrices});
}

/// @nodoc
class __$$BasketStoreImplCopyWithImpl<$Res>
    extends _$BasketStoreCopyWithImpl<$Res, _$BasketStoreImpl>
    implements _$$BasketStoreImplCopyWith<$Res> {
  __$$BasketStoreImplCopyWithImpl(
      _$BasketStoreImpl _value, $Res Function(_$BasketStoreImpl) _then)
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
    Object? distanceKm = null,
    Object? totalCents = null,
    Object? totalDisplay = null,
    Object? itemsFound = null,
    Object? itemsMissing = null,
    Object? itemPrices = null,
  }) {
    return _then(_$BasketStoreImpl(
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
      distanceKm: null == distanceKm
          ? _value.distanceKm
          : distanceKm // ignore: cast_nullable_to_non_nullable
              as double,
      totalCents: null == totalCents
          ? _value.totalCents
          : totalCents // ignore: cast_nullable_to_non_nullable
              as int,
      totalDisplay: null == totalDisplay
          ? _value.totalDisplay
          : totalDisplay // ignore: cast_nullable_to_non_nullable
              as String,
      itemsFound: null == itemsFound
          ? _value.itemsFound
          : itemsFound // ignore: cast_nullable_to_non_nullable
              as int,
      itemsMissing: null == itemsMissing
          ? _value.itemsMissing
          : itemsMissing // ignore: cast_nullable_to_non_nullable
              as int,
      itemPrices: null == itemPrices
          ? _value._itemPrices
          : itemPrices // ignore: cast_nullable_to_non_nullable
              as List<BasketItemPrice>,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BasketStoreImpl implements _BasketStore {
  const _$BasketStoreImpl(
      {@JsonKey(name: 'store_id') required this.storeId,
      required this.chain,
      this.banner,
      @JsonKey(name: 'store_name') required this.storeName,
      this.city,
      this.province,
      @JsonKey(name: 'distance_km') required this.distanceKm,
      @JsonKey(name: 'total_cents') required this.totalCents,
      @JsonKey(name: 'total_display') required this.totalDisplay,
      @JsonKey(name: 'items_found') required this.itemsFound,
      @JsonKey(name: 'items_missing') required this.itemsMissing,
      @JsonKey(name: 'item_prices')
      required final List<BasketItemPrice> itemPrices})
      : _itemPrices = itemPrices;

  factory _$BasketStoreImpl.fromJson(Map<String, dynamic> json) =>
      _$$BasketStoreImplFromJson(json);

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
  @JsonKey(name: 'distance_km')
  final double distanceKm;
  @override
  @JsonKey(name: 'total_cents')
  final int totalCents;
  @override
  @JsonKey(name: 'total_display')
  final String totalDisplay;
  @override
  @JsonKey(name: 'items_found')
  final int itemsFound;
  @override
  @JsonKey(name: 'items_missing')
  final int itemsMissing;
  final List<BasketItemPrice> _itemPrices;
  @override
  @JsonKey(name: 'item_prices')
  List<BasketItemPrice> get itemPrices {
    if (_itemPrices is EqualUnmodifiableListView) return _itemPrices;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_itemPrices);
  }

  @override
  String toString() {
    return 'BasketStore(storeId: $storeId, chain: $chain, banner: $banner, storeName: $storeName, city: $city, province: $province, distanceKm: $distanceKm, totalCents: $totalCents, totalDisplay: $totalDisplay, itemsFound: $itemsFound, itemsMissing: $itemsMissing, itemPrices: $itemPrices)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BasketStoreImpl &&
            (identical(other.storeId, storeId) || other.storeId == storeId) &&
            (identical(other.chain, chain) || other.chain == chain) &&
            (identical(other.banner, banner) || other.banner == banner) &&
            (identical(other.storeName, storeName) ||
                other.storeName == storeName) &&
            (identical(other.city, city) || other.city == city) &&
            (identical(other.province, province) ||
                other.province == province) &&
            (identical(other.distanceKm, distanceKm) ||
                other.distanceKm == distanceKm) &&
            (identical(other.totalCents, totalCents) ||
                other.totalCents == totalCents) &&
            (identical(other.totalDisplay, totalDisplay) ||
                other.totalDisplay == totalDisplay) &&
            (identical(other.itemsFound, itemsFound) ||
                other.itemsFound == itemsFound) &&
            (identical(other.itemsMissing, itemsMissing) ||
                other.itemsMissing == itemsMissing) &&
            const DeepCollectionEquality()
                .equals(other._itemPrices, _itemPrices));
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
      distanceKm,
      totalCents,
      totalDisplay,
      itemsFound,
      itemsMissing,
      const DeepCollectionEquality().hash(_itemPrices));

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BasketStoreImplCopyWith<_$BasketStoreImpl> get copyWith =>
      __$$BasketStoreImplCopyWithImpl<_$BasketStoreImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BasketStoreImplToJson(
      this,
    );
  }
}

abstract class _BasketStore implements BasketStore {
  const factory _BasketStore(
      {@JsonKey(name: 'store_id') required final String storeId,
      required final String chain,
      final String? banner,
      @JsonKey(name: 'store_name') required final String storeName,
      final String? city,
      final String? province,
      @JsonKey(name: 'distance_km') required final double distanceKm,
      @JsonKey(name: 'total_cents') required final int totalCents,
      @JsonKey(name: 'total_display') required final String totalDisplay,
      @JsonKey(name: 'items_found') required final int itemsFound,
      @JsonKey(name: 'items_missing') required final int itemsMissing,
      @JsonKey(name: 'item_prices')
      required final List<BasketItemPrice> itemPrices}) = _$BasketStoreImpl;

  factory _BasketStore.fromJson(Map<String, dynamic> json) =
      _$BasketStoreImpl.fromJson;

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
  @JsonKey(name: 'distance_km')
  double get distanceKm;
  @override
  @JsonKey(name: 'total_cents')
  int get totalCents;
  @override
  @JsonKey(name: 'total_display')
  String get totalDisplay;
  @override
  @JsonKey(name: 'items_found')
  int get itemsFound;
  @override
  @JsonKey(name: 'items_missing')
  int get itemsMissing;
  @override
  @JsonKey(name: 'item_prices')
  List<BasketItemPrice> get itemPrices;
  @override
  @JsonKey(ignore: true)
  _$$BasketStoreImplCopyWith<_$BasketStoreImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

BasketItemPrice _$BasketItemPriceFromJson(Map<String, dynamic> json) {
  return _BasketItemPrice.fromJson(json);
}

/// @nodoc
mixin _$BasketItemPrice {
  String get upc => throw _privateConstructorUsedError;
  @JsonKey(name: 'product_name')
  String get productName => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;
  @JsonKey(name: 'unit_price_cents')
  int get unitPriceCents => throw _privateConstructorUsedError;
  @JsonKey(name: 'unit_price_display')
  String get unitPriceDisplay => throw _privateConstructorUsedError;
  @JsonKey(name: 'subtotal_cents')
  int get subtotalCents => throw _privateConstructorUsedError;
  @JsonKey(name: 'subtotal_display')
  String get subtotalDisplay => throw _privateConstructorUsedError;
  @JsonKey(name: 'on_sale')
  bool get onSale => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $BasketItemPriceCopyWith<BasketItemPrice> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $BasketItemPriceCopyWith<$Res> {
  factory $BasketItemPriceCopyWith(
          BasketItemPrice value, $Res Function(BasketItemPrice) then) =
      _$BasketItemPriceCopyWithImpl<$Res, BasketItemPrice>;
  @useResult
  $Res call(
      {String upc,
      @JsonKey(name: 'product_name') String productName,
      int quantity,
      @JsonKey(name: 'unit_price_cents') int unitPriceCents,
      @JsonKey(name: 'unit_price_display') String unitPriceDisplay,
      @JsonKey(name: 'subtotal_cents') int subtotalCents,
      @JsonKey(name: 'subtotal_display') String subtotalDisplay,
      @JsonKey(name: 'on_sale') bool onSale});
}

/// @nodoc
class _$BasketItemPriceCopyWithImpl<$Res, $Val extends BasketItemPrice>
    implements $BasketItemPriceCopyWith<$Res> {
  _$BasketItemPriceCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? upc = null,
    Object? productName = null,
    Object? quantity = null,
    Object? unitPriceCents = null,
    Object? unitPriceDisplay = null,
    Object? subtotalCents = null,
    Object? subtotalDisplay = null,
    Object? onSale = null,
  }) {
    return _then(_value.copyWith(
      upc: null == upc
          ? _value.upc
          : upc // ignore: cast_nullable_to_non_nullable
              as String,
      productName: null == productName
          ? _value.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      unitPriceCents: null == unitPriceCents
          ? _value.unitPriceCents
          : unitPriceCents // ignore: cast_nullable_to_non_nullable
              as int,
      unitPriceDisplay: null == unitPriceDisplay
          ? _value.unitPriceDisplay
          : unitPriceDisplay // ignore: cast_nullable_to_non_nullable
              as String,
      subtotalCents: null == subtotalCents
          ? _value.subtotalCents
          : subtotalCents // ignore: cast_nullable_to_non_nullable
              as int,
      subtotalDisplay: null == subtotalDisplay
          ? _value.subtotalDisplay
          : subtotalDisplay // ignore: cast_nullable_to_non_nullable
              as String,
      onSale: null == onSale
          ? _value.onSale
          : onSale // ignore: cast_nullable_to_non_nullable
              as bool,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$BasketItemPriceImplCopyWith<$Res>
    implements $BasketItemPriceCopyWith<$Res> {
  factory _$$BasketItemPriceImplCopyWith(_$BasketItemPriceImpl value,
          $Res Function(_$BasketItemPriceImpl) then) =
      __$$BasketItemPriceImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {String upc,
      @JsonKey(name: 'product_name') String productName,
      int quantity,
      @JsonKey(name: 'unit_price_cents') int unitPriceCents,
      @JsonKey(name: 'unit_price_display') String unitPriceDisplay,
      @JsonKey(name: 'subtotal_cents') int subtotalCents,
      @JsonKey(name: 'subtotal_display') String subtotalDisplay,
      @JsonKey(name: 'on_sale') bool onSale});
}

/// @nodoc
class __$$BasketItemPriceImplCopyWithImpl<$Res>
    extends _$BasketItemPriceCopyWithImpl<$Res, _$BasketItemPriceImpl>
    implements _$$BasketItemPriceImplCopyWith<$Res> {
  __$$BasketItemPriceImplCopyWithImpl(
      _$BasketItemPriceImpl _value, $Res Function(_$BasketItemPriceImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? upc = null,
    Object? productName = null,
    Object? quantity = null,
    Object? unitPriceCents = null,
    Object? unitPriceDisplay = null,
    Object? subtotalCents = null,
    Object? subtotalDisplay = null,
    Object? onSale = null,
  }) {
    return _then(_$BasketItemPriceImpl(
      upc: null == upc
          ? _value.upc
          : upc // ignore: cast_nullable_to_non_nullable
              as String,
      productName: null == productName
          ? _value.productName
          : productName // ignore: cast_nullable_to_non_nullable
              as String,
      quantity: null == quantity
          ? _value.quantity
          : quantity // ignore: cast_nullable_to_non_nullable
              as int,
      unitPriceCents: null == unitPriceCents
          ? _value.unitPriceCents
          : unitPriceCents // ignore: cast_nullable_to_non_nullable
              as int,
      unitPriceDisplay: null == unitPriceDisplay
          ? _value.unitPriceDisplay
          : unitPriceDisplay // ignore: cast_nullable_to_non_nullable
              as String,
      subtotalCents: null == subtotalCents
          ? _value.subtotalCents
          : subtotalCents // ignore: cast_nullable_to_non_nullable
              as int,
      subtotalDisplay: null == subtotalDisplay
          ? _value.subtotalDisplay
          : subtotalDisplay // ignore: cast_nullable_to_non_nullable
              as String,
      onSale: null == onSale
          ? _value.onSale
          : onSale // ignore: cast_nullable_to_non_nullable
              as bool,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$BasketItemPriceImpl implements _BasketItemPrice {
  const _$BasketItemPriceImpl(
      {required this.upc,
      @JsonKey(name: 'product_name') required this.productName,
      required this.quantity,
      @JsonKey(name: 'unit_price_cents') required this.unitPriceCents,
      @JsonKey(name: 'unit_price_display') required this.unitPriceDisplay,
      @JsonKey(name: 'subtotal_cents') required this.subtotalCents,
      @JsonKey(name: 'subtotal_display') required this.subtotalDisplay,
      @JsonKey(name: 'on_sale') required this.onSale});

  factory _$BasketItemPriceImpl.fromJson(Map<String, dynamic> json) =>
      _$$BasketItemPriceImplFromJson(json);

  @override
  final String upc;
  @override
  @JsonKey(name: 'product_name')
  final String productName;
  @override
  final int quantity;
  @override
  @JsonKey(name: 'unit_price_cents')
  final int unitPriceCents;
  @override
  @JsonKey(name: 'unit_price_display')
  final String unitPriceDisplay;
  @override
  @JsonKey(name: 'subtotal_cents')
  final int subtotalCents;
  @override
  @JsonKey(name: 'subtotal_display')
  final String subtotalDisplay;
  @override
  @JsonKey(name: 'on_sale')
  final bool onSale;

  @override
  String toString() {
    return 'BasketItemPrice(upc: $upc, productName: $productName, quantity: $quantity, unitPriceCents: $unitPriceCents, unitPriceDisplay: $unitPriceDisplay, subtotalCents: $subtotalCents, subtotalDisplay: $subtotalDisplay, onSale: $onSale)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$BasketItemPriceImpl &&
            (identical(other.upc, upc) || other.upc == upc) &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.unitPriceCents, unitPriceCents) ||
                other.unitPriceCents == unitPriceCents) &&
            (identical(other.unitPriceDisplay, unitPriceDisplay) ||
                other.unitPriceDisplay == unitPriceDisplay) &&
            (identical(other.subtotalCents, subtotalCents) ||
                other.subtotalCents == subtotalCents) &&
            (identical(other.subtotalDisplay, subtotalDisplay) ||
                other.subtotalDisplay == subtotalDisplay) &&
            (identical(other.onSale, onSale) || other.onSale == onSale));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(runtimeType, upc, productName, quantity,
      unitPriceCents, unitPriceDisplay, subtotalCents, subtotalDisplay, onSale);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$BasketItemPriceImplCopyWith<_$BasketItemPriceImpl> get copyWith =>
      __$$BasketItemPriceImplCopyWithImpl<_$BasketItemPriceImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$BasketItemPriceImplToJson(
      this,
    );
  }
}

abstract class _BasketItemPrice implements BasketItemPrice {
  const factory _BasketItemPrice(
      {required final String upc,
      @JsonKey(name: 'product_name') required final String productName,
      required final int quantity,
      @JsonKey(name: 'unit_price_cents') required final int unitPriceCents,
      @JsonKey(name: 'unit_price_display')
      required final String unitPriceDisplay,
      @JsonKey(name: 'subtotal_cents') required final int subtotalCents,
      @JsonKey(name: 'subtotal_display') required final String subtotalDisplay,
      @JsonKey(name: 'on_sale')
      required final bool onSale}) = _$BasketItemPriceImpl;

  factory _BasketItemPrice.fromJson(Map<String, dynamic> json) =
      _$BasketItemPriceImpl.fromJson;

  @override
  String get upc;
  @override
  @JsonKey(name: 'product_name')
  String get productName;
  @override
  int get quantity;
  @override
  @JsonKey(name: 'unit_price_cents')
  int get unitPriceCents;
  @override
  @JsonKey(name: 'unit_price_display')
  String get unitPriceDisplay;
  @override
  @JsonKey(name: 'subtotal_cents')
  int get subtotalCents;
  @override
  @JsonKey(name: 'subtotal_display')
  String get subtotalDisplay;
  @override
  @JsonKey(name: 'on_sale')
  bool get onSale;
  @override
  @JsonKey(ignore: true)
  _$$BasketItemPriceImplCopyWith<_$BasketItemPriceImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CompareResponse _$CompareResponseFromJson(Map<String, dynamic> json) {
  return _CompareResponse.fromJson(json);
}

/// @nodoc
mixin _$CompareResponse {
  List<BasketStore> get stores => throw _privateConstructorUsedError;
  @JsonKey(name: 'cheapest_store_id')
  String? get cheapestStoreId => throw _privateConstructorUsedError;
  @JsonKey(name: 'total_items_requested')
  int get totalItemsRequested => throw _privateConstructorUsedError;

  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;
  @JsonKey(ignore: true)
  $CompareResponseCopyWith<CompareResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CompareResponseCopyWith<$Res> {
  factory $CompareResponseCopyWith(
          CompareResponse value, $Res Function(CompareResponse) then) =
      _$CompareResponseCopyWithImpl<$Res, CompareResponse>;
  @useResult
  $Res call(
      {List<BasketStore> stores,
      @JsonKey(name: 'cheapest_store_id') String? cheapestStoreId,
      @JsonKey(name: 'total_items_requested') int totalItemsRequested});
}

/// @nodoc
class _$CompareResponseCopyWithImpl<$Res, $Val extends CompareResponse>
    implements $CompareResponseCopyWith<$Res> {
  _$CompareResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? stores = null,
    Object? cheapestStoreId = freezed,
    Object? totalItemsRequested = null,
  }) {
    return _then(_value.copyWith(
      stores: null == stores
          ? _value.stores
          : stores // ignore: cast_nullable_to_non_nullable
              as List<BasketStore>,
      cheapestStoreId: freezed == cheapestStoreId
          ? _value.cheapestStoreId
          : cheapestStoreId // ignore: cast_nullable_to_non_nullable
              as String?,
      totalItemsRequested: null == totalItemsRequested
          ? _value.totalItemsRequested
          : totalItemsRequested // ignore: cast_nullable_to_non_nullable
              as int,
    ) as $Val);
  }
}

/// @nodoc
abstract class _$$CompareResponseImplCopyWith<$Res>
    implements $CompareResponseCopyWith<$Res> {
  factory _$$CompareResponseImplCopyWith(_$CompareResponseImpl value,
          $Res Function(_$CompareResponseImpl) then) =
      __$$CompareResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call(
      {List<BasketStore> stores,
      @JsonKey(name: 'cheapest_store_id') String? cheapestStoreId,
      @JsonKey(name: 'total_items_requested') int totalItemsRequested});
}

/// @nodoc
class __$$CompareResponseImplCopyWithImpl<$Res>
    extends _$CompareResponseCopyWithImpl<$Res, _$CompareResponseImpl>
    implements _$$CompareResponseImplCopyWith<$Res> {
  __$$CompareResponseImplCopyWithImpl(
      _$CompareResponseImpl _value, $Res Function(_$CompareResponseImpl) _then)
      : super(_value, _then);

  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? stores = null,
    Object? cheapestStoreId = freezed,
    Object? totalItemsRequested = null,
  }) {
    return _then(_$CompareResponseImpl(
      stores: null == stores
          ? _value._stores
          : stores // ignore: cast_nullable_to_non_nullable
              as List<BasketStore>,
      cheapestStoreId: freezed == cheapestStoreId
          ? _value.cheapestStoreId
          : cheapestStoreId // ignore: cast_nullable_to_non_nullable
              as String?,
      totalItemsRequested: null == totalItemsRequested
          ? _value.totalItemsRequested
          : totalItemsRequested // ignore: cast_nullable_to_non_nullable
              as int,
    ));
  }
}

/// @nodoc
@JsonSerializable()
class _$CompareResponseImpl implements _CompareResponse {
  const _$CompareResponseImpl(
      {required final List<BasketStore> stores,
      @JsonKey(name: 'cheapest_store_id') this.cheapestStoreId,
      @JsonKey(name: 'total_items_requested')
      required this.totalItemsRequested})
      : _stores = stores;

  factory _$CompareResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$CompareResponseImplFromJson(json);

  final List<BasketStore> _stores;
  @override
  List<BasketStore> get stores {
    if (_stores is EqualUnmodifiableListView) return _stores;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_stores);
  }

  @override
  @JsonKey(name: 'cheapest_store_id')
  final String? cheapestStoreId;
  @override
  @JsonKey(name: 'total_items_requested')
  final int totalItemsRequested;

  @override
  String toString() {
    return 'CompareResponse(stores: $stores, cheapestStoreId: $cheapestStoreId, totalItemsRequested: $totalItemsRequested)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CompareResponseImpl &&
            const DeepCollectionEquality().equals(other._stores, _stores) &&
            (identical(other.cheapestStoreId, cheapestStoreId) ||
                other.cheapestStoreId == cheapestStoreId) &&
            (identical(other.totalItemsRequested, totalItemsRequested) ||
                other.totalItemsRequested == totalItemsRequested));
  }

  @JsonKey(ignore: true)
  @override
  int get hashCode => Object.hash(
      runtimeType,
      const DeepCollectionEquality().hash(_stores),
      cheapestStoreId,
      totalItemsRequested);

  @JsonKey(ignore: true)
  @override
  @pragma('vm:prefer-inline')
  _$$CompareResponseImplCopyWith<_$CompareResponseImpl> get copyWith =>
      __$$CompareResponseImplCopyWithImpl<_$CompareResponseImpl>(
          this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CompareResponseImplToJson(
      this,
    );
  }
}

abstract class _CompareResponse implements CompareResponse {
  const factory _CompareResponse(
      {required final List<BasketStore> stores,
      @JsonKey(name: 'cheapest_store_id') final String? cheapestStoreId,
      @JsonKey(name: 'total_items_requested')
      required final int totalItemsRequested}) = _$CompareResponseImpl;

  factory _CompareResponse.fromJson(Map<String, dynamic> json) =
      _$CompareResponseImpl.fromJson;

  @override
  List<BasketStore> get stores;
  @override
  @JsonKey(name: 'cheapest_store_id')
  String? get cheapestStoreId;
  @override
  @JsonKey(name: 'total_items_requested')
  int get totalItemsRequested;
  @override
  @JsonKey(ignore: true)
  _$$CompareResponseImplCopyWith<_$CompareResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}
