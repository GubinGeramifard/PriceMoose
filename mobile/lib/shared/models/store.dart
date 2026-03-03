// ignore_for_file: invalid_annotation_target
import 'package:freezed_annotation/freezed_annotation.dart';

part 'store.freezed.dart';
part 'store.g.dart';

@freezed
class Store with _$Store {
  const factory Store({
    required String id,
    required String chain,
    String? banner,
    required String name,
    String? address,
    String? city,
    String? province,
    @JsonKey(name: 'postal_code') String? postalCode,
    double? lat,
    double? lng,
    @JsonKey(name: 'distance_km') double? distanceKm,
  }) = _Store;

  factory Store.fromJson(Map<String, dynamic> json) => _$StoreFromJson(json);
}