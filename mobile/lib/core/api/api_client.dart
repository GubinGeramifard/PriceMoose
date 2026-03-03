import 'package:dio/dio.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../constants.dart';
import 'grocery_api.dart';

final dioProvider = Provider<Dio>((ref) {
  final dio = Dio(BaseOptions(
    baseUrl: ApiConstants.baseUrl,
    connectTimeout: const Duration(seconds: 10),
    receiveTimeout: const Duration(seconds: 20),
    headers: {'Accept': 'application/json'},
  ));

  dio.interceptors.add(LogInterceptor(
    requestBody: false,
    responseBody: false,
    error: true,
  ));

  return dio;
});

final groceryApiProvider = Provider<GroceryApi>((ref) {
  final dio = ref.watch(dioProvider);
  return GroceryApi(dio);
});
