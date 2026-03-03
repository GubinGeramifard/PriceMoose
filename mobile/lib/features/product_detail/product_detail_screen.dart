import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';

import '../../core/api/api_client.dart';
import '../../shared/models/product.dart';
import '../../shared/models/price_listing.dart';
import '../../shared/widgets/price_card.dart';
import '../shopping_list/list_provider.dart';

final _productProvider = FutureProvider.family<Product, String>((ref, upc) async {
  return ref.read(groceryApiProvider).getProductByUpc(upc);
});

final _pricesProvider = FutureProvider.family<List<PriceListing>, String>((ref, upc) async {
  Position? position;
  try {
    final permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.always || permission == LocationPermission.whileInUse) {
      position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
      );
    }
  } catch (_) {}

  return ref.read(groceryApiProvider).getPricesForProduct(
        upc,
        lat: position?.latitude,
        lng: position?.longitude,
      );
});

class ProductDetailScreen extends ConsumerWidget {
  final String upc;

  const ProductDetailScreen({super.key, required this.upc});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final productAsync = ref.watch(_productProvider(upc));
    final pricesAsync = ref.watch(_pricesProvider(upc));

    return Scaffold(
      appBar: AppBar(
        title: productAsync.maybeWhen(
          data: (p) => Text(p.brand ?? p.name, overflow: TextOverflow.ellipsis),
          orElse: () => const Text('Product'),
        ),
        leading: const BackButton(),
      ),
      body: productAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (product) => _ProductBody(product: product, pricesAsync: pricesAsync),
      ),
      bottomNavigationBar: productAsync.maybeWhen(
        data: (product) => SafeArea(
          child: Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 12),
            child: ElevatedButton.icon(
              icon: const Icon(Icons.add_shopping_cart),
              label: const Text('Add to My List'),
              style: ElevatedButton.styleFrom(
                minimumSize: const Size.fromHeight(48),
              ),
              onPressed: () {
                ref.read(shoppingListProvider.notifier).addItem(product);
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text('Added "${product.name}" to your list'),
                    duration: const Duration(seconds: 2),
                    action: SnackBarAction(
                      label: 'View List',
                      onPressed: () => context.go('/list'),
                    ),
                  ),
                );
              },
            ),
          ),
        ),
        orElse: () => const SizedBox.shrink(),
      ),
    );
  }
}

class _ProductBody extends StatelessWidget {
  final Product product;
  final AsyncValue<List<PriceListing>> pricesAsync;

  const _ProductBody({required this.product, required this.pricesAsync});

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(
      slivers: [
        SliverToBoxAdapter(child: _ProductHeader(product: product)),
        const SliverToBoxAdapter(
          child: Padding(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 8),
            child: Text(
              'Prices at nearby stores',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
            ),
          ),
        ),
        pricesAsync.when(
          loading: () => const SliverFillRemaining(
            child: Center(child: CircularProgressIndicator()),
          ),
          error: (e, _) => SliverFillRemaining(
            child: Center(child: Text('Could not load prices: $e')),
          ),
          data: (prices) => prices.isEmpty
              ? const SliverFillRemaining(
                  child: Center(child: Text('No prices available nearby')),
                )
              : SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (_, i) => PriceCard(listing: prices[i], rank: i + 1),
                    childCount: prices.length,
                  ),
                ),
        ),
      ],
    );
  }
}

class _ProductHeader extends StatelessWidget {
  final Product product;

  const _ProductHeader({required this.product});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          ClipRRect(
            borderRadius: BorderRadius.circular(12),
            child: product.imageUrl != null
                ? CachedNetworkImage(
                    imageUrl: product.imageUrl!,
                    width: 90,
                    height: 90,
                    fit: BoxFit.cover,
                  )
                : Container(
                    width: 90,
                    height: 90,
                    color: Colors.grey[200],
                    child: const Icon(Icons.image_not_supported, size: 36),
                  ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  product.name,
                  style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                ),
                if (product.brand != null) ...[
                  const SizedBox(height: 4),
                  Text(product.brand!,
                      style: TextStyle(color: theme.colorScheme.primary, fontWeight: FontWeight.w500)),
                ],
                if (product.category != null) ...[
                  const SizedBox(height: 4),
                  Text(product.category!,
                      style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontSize: 13)),
                ],
                const SizedBox(height: 4),
                Text('UPC: ${product.upc}',
                    style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontSize: 12)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
