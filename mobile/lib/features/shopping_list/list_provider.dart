import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../shared/models/product.dart';
import '../../shared/models/shopping_list.dart';

class ShoppingListNotifier extends StateNotifier<List<ShoppingListItem>> {
  static const _boxKey = 'items';
  final Box _box;

  ShoppingListNotifier(this._box) : super([]) {
    _load();
  }

  void _load() {
    final raw = _box.get(_boxKey);
    if (raw != null) {
      final list = (jsonDecode(raw) as List)
          .map((e) => ShoppingListItem.fromJson(e as Map<String, dynamic>))
          .toList();
      state = list;
    }
  }

  void _save() {
    _box.put(_boxKey, jsonEncode(state.map((e) => e.toJson()).toList()));
  }

  void addItem(Product product) {
    final existing = state.indexWhere((i) => i.upc == product.upc);
    if (existing >= 0) {
      state = [
        for (int i = 0; i < state.length; i++)
          if (i == existing)
            state[i].copyWith(quantity: state[i].quantity + 1)
          else
            state[i],
      ];
    } else {
      state = [
        ...state,
        ShoppingListItem(
          upc: product.upc,
          name: product.name,
          brand: product.brand,
          imageUrl: product.imageUrl,
        ),
      ];
    }
    _save();
  }

  void removeItem(String upc) {
    state = state.where((i) => i.upc != upc).toList();
    _save();
  }

  void updateQuantity(String upc, int qty) {
    if (qty <= 0) {
      removeItem(upc);
      return;
    }
    state = [
      for (final item in state)
        if (item.upc == upc) item.copyWith(quantity: qty) else item,
    ];
    _save();
  }

  void clearList() {
    state = [];
    _save();
  }
}

final shoppingListProvider =
    StateNotifierProvider<ShoppingListNotifier, List<ShoppingListItem>>(
  (ref) => ShoppingListNotifier(Hive.box('shopping_lists')),
);
