import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/api/api_client.dart';
import '../../shared/models/product.dart';

// Debounced search state
class SearchState {
  final String query;
  final List<Product> results;
  final bool loading;
  final String? error;

  const SearchState({
    this.query = '',
    this.results = const [],
    this.loading = false,
    this.error,
  });

  SearchState copyWith({
    String? query,
    List<Product>? results,
    bool? loading,
    String? error,
  }) =>
      SearchState(
        query: query ?? this.query,
        results: results ?? this.results,
        loading: loading ?? this.loading,
        error: error,
      );
}

class SearchNotifier extends StateNotifier<SearchState> {
  final Ref _ref;

  SearchNotifier(this._ref) : super(const SearchState());

  Future<void> search(String query) async {
    if (query.trim().length < 2) {
      state = state.copyWith(query: query, results: [], loading: false);
      return;
    }

    state = state.copyWith(query: query, loading: true, error: null);
    try {
      final api = _ref.read(groceryApiProvider);
      final results = await api.searchProducts(query.trim());
      state = state.copyWith(results: results, loading: false);
    } catch (e) {
      state = state.copyWith(loading: false, error: 'Search failed. Please try again.');
    }
  }

  void clear() {
    state = const SearchState();
  }
}

final searchProvider = StateNotifierProvider<SearchNotifier, SearchState>(
  (ref) => SearchNotifier(ref),
);
