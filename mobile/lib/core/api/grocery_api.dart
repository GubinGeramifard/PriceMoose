import 'package:dio/dio.dart';

import '../../shared/models/product.dart';
import '../../shared/models/price_listing.dart';
import '../../shared/models/store.dart';
import '../../shared/models/shopping_list.dart';

class GroceryApi {
  final Dio _dio;

  GroceryApi(this._dio);

  Future<List<Map<String, dynamic>>> getDeals({int limit = 20}) async {
    final resp = await _dio.get('/products/deals', queryParameters: {'limit': limit});
    return (resp.data as List).cast<Map<String, dynamic>>();
  }

  Future<List<Product>> searchProducts(String query, {int limit = 20}) async {
    final resp = await _dio.get('/products/search', queryParameters: {'q': query, 'limit': limit});
    return (resp.data as List).map((e) => Product.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<Product> getProductByUpc(String upc) async {
    final resp = await _dio.get('/products/upc/$upc');
    return Product.fromJson(resp.data as Map<String, dynamic>);
  }

  Future<List<PriceListing>> getPricesForProduct(
    String upc, {
    double? lat,
    double? lng,
    double? radiusKm,
  }) async {
    final resp = await _dio.get(
      '/prices/$upc',
      queryParameters: {
        if (lat != null) 'lat': lat,
        if (lng != null) 'lng': lng,
        if (radiusKm != null) 'radius_km': radiusKm,
      },
    );
    return (resp.data as List).map((e) => PriceListing.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<List<Store>> getNearbyStores(
    double lat,
    double lng, {
    double? radiusKm,
    String? chain,
  }) async {
    final resp = await _dio.get(
      '/stores/nearby',
      queryParameters: {
        'lat': lat,
        'lng': lng,
        if (radiusKm != null) 'radius_km': radiusKm,
        if (chain != null) 'chain': chain,
      },
    );
    return (resp.data as List).map((e) => Store.fromJson(e as Map<String, dynamic>)).toList();
  }

  Future<CompareResponse> compareBasket(Map<String, dynamic> body) async {
    final resp = await _dio.post('/lists/compare', data: body);
    return CompareResponse.fromJson(resp.data as Map<String, dynamic>);
  }
}
