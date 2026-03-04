import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:shimmer/shimmer.dart';

import 'search_provider.dart';
import '../../shared/models/product.dart';
import '../shopping_list/list_provider.dart';
import '../../core/api/api_client.dart';
import '../../core/constants.dart';
import '../../shared/models/store.dart';

final _dealsProvider = FutureProvider<List<Map<String, dynamic>>>((ref) async {
  return ref.read(groceryApiProvider).getDeals(limit: 20);
});

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final _controller = TextEditingController();
  Timer? _debounce;

  @override
  void dispose() {
    _controller.dispose();
    _debounce?.cancel();
    super.dispose();
  }

  void _onQueryChanged(String query) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      ref.read(searchProvider.notifier).search(query);
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(searchProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('PriceMoose'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(64),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 0, 16, 12),
            child: TextField(
              controller: _controller,
              onChanged: _onQueryChanged,
              decoration: InputDecoration(
                hintText: 'Search groceries...',
                prefixIcon: const Icon(Icons.search),
                suffixIcon: _controller.text.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.clear),
                        onPressed: () {
                          _controller.clear();
                          ref.read(searchProvider.notifier).clear();
                        },
                      )
                    : null,
                fillColor: Colors.white,
                filled: true,
              ),
            ),
          ),
        ),
      ),
      body: _buildBody(state),
    );
  }

  Widget _buildBody(SearchState state) {
    if (state.loading) {
      return Shimmer.fromColors(
        baseColor: Colors.grey[300]!,
        highlightColor: Colors.grey[100]!,
        child: ListView.builder(
          padding: const EdgeInsets.symmetric(vertical: 8),
          itemCount: 8,
          itemBuilder: (_, __) => ListTile(
            contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
            leading: Container(width: 52, height: 52, decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(8))),
            title: Container(height: 14, margin: const EdgeInsets.only(right: 60, bottom: 6), color: Colors.white),
            subtitle: Container(height: 12, margin: const EdgeInsets.only(right: 100), color: Colors.white),
          ),
        ),
      );
    }

    if (state.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Colors.red),
            const SizedBox(height: 12),
            Text(state.error!),
            const SizedBox(height: 12),
            ElevatedButton(
              onPressed: () => ref.read(searchProvider.notifier).search(state.query),
              child: const Text('Retry'),
            ),
          ],
        ),
      );
    }

    if (state.query.isEmpty) {
      return _buildEmptyState();
    }

    if (state.results.isEmpty && state.query.length >= 2) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.search_off, size: 64, color: Colors.grey[400]),
            const SizedBox(height: 16),
            Text(
              'No products found for\n"${state.query}"',
              textAlign: TextAlign.center,
              style: TextStyle(color: Colors.grey[600]),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      padding: const EdgeInsets.symmetric(vertical: 8),
      itemCount: state.results.length,
      itemBuilder: (context, index) => _ProductTile(
        product: state.results[index],
        onTap: () => context.go('/search/product/${state.results[index].upc}'),
        onAddToList: () {
          ref.read(shoppingListProvider.notifier).addItem(state.results[index]);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Added "${state.results[index].name}" to your list'),
              duration: const Duration(seconds: 2),
              action: SnackBarAction(
                label: 'View List',
                onPressed: () => context.go('/list'),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState() {
    final dealsAsync = ref.watch(_dealsProvider);

    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 20, 16, 8),
            child: Row(
              children: [
                const Text('🔥', style: TextStyle(fontSize: 22)),
                const SizedBox(width: 8),
                const Text(
                  'Hot Deals This Week',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),
              ],
            ),
          ),
        ),
        dealsAsync.when(
          loading: () => SliverList(
            delegate: SliverChildBuilderDelegate(
              (_, __) => Shimmer.fromColors(
                baseColor: Colors.grey[300]!,
                highlightColor: Colors.grey[100]!,
                child: Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                  height: 96,
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                ),
              ),
              childCount: 6,
            ),
          ),
          error: (_, __) => const SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(32),
              child: Center(child: Text('Could not load deals', style: TextStyle(color: Colors.grey))),
            ),
          ),
          data: (deals) => deals.isEmpty
              ? const SliverToBoxAdapter(
                  child: Padding(
                    padding: EdgeInsets.all(32),
                    child: Center(child: Text('No deals right now — check back later!', style: TextStyle(color: Colors.grey))),
                  ),
                )
              : SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) => _DealCard(
                      deal: deals[index],
                      onTap: () => context.go('/search/product/${deals[index]['upc']}'),
                    ),
                    childCount: deals.length,
                  ),
                ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: 24)),
      ],
    );
  }
}


class _DealCard extends StatelessWidget {
  final Map<String, dynamic> deal;
  final VoidCallback onTap;

  const _DealCard({required this.deal, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final chain = deal['chain'] as String? ?? '';
    final savingsPct = deal['savings_pct'] as int? ?? 0;
    final color = Color(ChainColors.forChain(chain));

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: Colors.grey[200]!),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              // Product image or placeholder
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: deal['image_url'] != null
                    ? Image.network(
                        deal['image_url'] as String,
                        width: 64,
                        height: 64,
                        fit: BoxFit.cover,
                        errorBuilder: (_, __, ___) => _imgPlaceholder(),
                      )
                    : _imgPlaceholder(),
              ),
              const SizedBox(width: 12),
              // Name + brand + store
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      deal['name'] as String? ?? '',
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 14),
                    ),
                    if (deal['brand'] != null)
                      Text(deal['brand'] as String, style: TextStyle(fontSize: 12, color: Colors.grey[600])),
                    const SizedBox(height: 4),
                    Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: color.withValues(alpha: 0.12),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            deal['banner'] as String? ?? chain,
                            style: TextStyle(fontSize: 11, color: color, fontWeight: FontWeight.w600),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
              const SizedBox(width: 8),
              // Price column
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                    decoration: BoxDecoration(
                      color: Colors.red[600],
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: Text(
                      '-$savingsPct%',
                      style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w700, fontSize: 12),
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    deal['sale_price_display'] as String? ?? '',
                    style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16, color: Color(0xFF2E7D32)),
                  ),
                  Text(
                    deal['regular_price_display'] as String? ?? '',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey[500],
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _imgPlaceholder() => Container(
    width: 64,
    height: 64,
    color: Colors.grey[100],
    child: Icon(Icons.fastfood, color: Colors.grey[300], size: 28),
  );
}

class _ProductTile extends StatelessWidget {
  final Product product;
  final VoidCallback onTap;
  final VoidCallback onAddToList;

  const _ProductTile({required this.product, required this.onTap, required this.onAddToList});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.only(left: 16, right: 4, top: 4, bottom: 4),
      leading: ClipRRect(
        borderRadius: BorderRadius.circular(8),
        child: product.imageUrl != null
            ? CachedNetworkImage(
                imageUrl: product.imageUrl!,
                width: 52,
                height: 52,
                fit: BoxFit.cover,
                placeholder: (_, __) => Container(
                  width: 52,
                  height: 52,
                  color: Colors.grey[200],
                ),
                errorWidget: (_, __, ___) => _placeholder(),
              )
            : _placeholder(),
      ),
      title: Text(product.name, maxLines: 2, overflow: TextOverflow.ellipsis),
      subtitle: product.brand != null ? Text(product.brand!) : null,
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          IconButton(
            icon: const Icon(Icons.add_shopping_cart),
            tooltip: 'Add to list',
            onPressed: onAddToList,
          ),
          const Icon(Icons.chevron_right),
        ],
      ),
      onTap: onTap,
    );
  }

  Widget _placeholder() => Container(
        width: 52,
        height: 52,
        color: Colors.grey[200],
        child: const Icon(Icons.image_not_supported, color: Colors.grey),
      );
}
