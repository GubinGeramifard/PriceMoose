import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:geolocator/geolocator.dart';

import '../../core/api/api_client.dart';
import '../../core/constants.dart';
import '../../shared/models/shopping_list.dart';
import '../settings/settings_provider.dart';
import 'list_provider.dart';

final _comparisonProvider = FutureProvider<CompareResponse>((ref) async {
  final items = ref.read(shoppingListProvider);
  if (items.isEmpty) throw Exception('Shopping list is empty');

  final settings = ref.read(settingsProvider);
  Position? position;
  try {
    final perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.always || perm == LocationPermission.whileInUse) {
      position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.medium,
      );
    }
  } catch (_) {}

  // Use GPS if available, otherwise fall back to user's postal code setting
  final lat = position?.latitude ?? settings.lat;
  final lng = position?.longitude ?? settings.lng;

  return ref.read(groceryApiProvider).compareBasket({
    'items': items.map((i) => {'upc': i.upc, 'quantity': i.quantity}).toList(),
    'lat': lat,
    'lng': lng,
    'radius_km': ApiConstants.defaultRadiusKm,
  });
});

class ListComparisonScreen extends ConsumerWidget {
  const ListComparisonScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final compAsync = ref.watch(_comparisonProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Store Comparison')),
      body: compAsync.when(
        loading: () => const Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              CircularProgressIndicator(),
              SizedBox(height: 16),
              Text('Finding the best prices near you...'),
            ],
          ),
        ),
        error: (e, _) => Center(child: Text('Error: $e')),
        data: (response) => _ComparisonBody(response: response),
      ),
    );
  }
}

class _ComparisonBody extends StatelessWidget {
  final CompareResponse response;

  const _ComparisonBody({required this.response});

  @override
  Widget build(BuildContext context) {
    if (response.stores.isEmpty) {
      return const Center(child: Text('No stores found with prices for your items'));
    }

    final cheapest = response.stores.first;

    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        // Summary banner
        Container(
          padding: const EdgeInsets.all(16),
          decoration: BoxDecoration(
            color: Colors.green[50],
            borderRadius: BorderRadius.circular(12),
            border: Border.all(color: Colors.green[300]!),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  const Icon(Icons.emoji_events, color: Colors.amber, size: 28),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Best Deal', style: TextStyle(fontWeight: FontWeight.bold)),
                        Text(
                          '${cheapest.banner ?? cheapest.storeName} — ${cheapest.totalDisplay}',
                          style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w700),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              if (response.stores.length > 1) ...[
                const SizedBox(height: 8),
                Text(
                  'Saves you ${_savings(response)} vs. most expensive nearby',
                  style: TextStyle(color: Colors.green[700], fontSize: 13),
                ),
              ],
            ],
          ),
        ),
        const SizedBox(height: 16),
        Text(
          '${response.stores.length} stores compared',
          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
        ),
        const SizedBox(height: 8),
        ...response.stores.asMap().entries.map(
          (e) => _StoreBasketCard(store: e.value, rank: e.key + 1),
        ),
      ],
    );
  }

  String _savings(CompareResponse response) {
    if (response.stores.length < 2) return '';
    final cheapestTotal = response.stores.first.totalCents;
    final mostExpensive = response.stores.last.totalCents;
    final diff = (mostExpensive - cheapestTotal) / 100.0;
    return '\$${diff.toStringAsFixed(2)}';
  }
}

class _StoreBasketCard extends StatefulWidget {
  final BasketStore store;
  final int rank;

  const _StoreBasketCard({required this.store, required this.rank});

  @override
  State<_StoreBasketCard> createState() => _StoreBasketCardState();
}

class _StoreBasketCardState extends State<_StoreBasketCard> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    final store = widget.store;
    final theme = Theme.of(context);
    final chainColor = Color(ChainColors.forChain(store.chain));
    final isCheapest = widget.rank == 1;

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: isCheapest ? BorderSide(color: Colors.green[400]!, width: 2) : BorderSide.none,
      ),
      child: Column(
        children: [
          InkWell(
            onTap: () => setState(() => _expanded = !_expanded),
            borderRadius: BorderRadius.circular(12),
            child: Padding(
              padding: const EdgeInsets.all(16),
              child: Row(
                children: [
                  // Rank
                  Container(
                    width: 36,
                    height: 36,
                    decoration: BoxDecoration(
                      color: isCheapest ? Colors.green : theme.colorScheme.surfaceContainerHighest,
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text(
                        '${widget.rank}',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          color: isCheapest ? Colors.white : theme.colorScheme.onSurfaceVariant,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Container(
                              width: 10,
                              height: 10,
                              decoration: BoxDecoration(color: chainColor, shape: BoxShape.circle),
                            ),
                            const SizedBox(width: 6),
                            Text(
                              store.banner ?? store.storeName,
                              style: const TextStyle(fontWeight: FontWeight.w600),
                            ),
                          ],
                        ),
                        Text(
                          '${store.city ?? ''} · ${store.distanceKm.toStringAsFixed(1)} km',
                          style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontSize: 12),
                        ),
                        if (store.itemsMissing > 0)
                          Text(
                            '${store.itemsMissing} item(s) not available',
                            style: const TextStyle(color: Colors.orange, fontSize: 12),
                          ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        store.totalDisplay,
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: isCheapest ? Colors.green[700] : theme.colorScheme.onSurface,
                        ),
                      ),
                      Text(
                        '${store.itemsFound}/${store.itemsFound + store.itemsMissing} items',
                        style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontSize: 11),
                      ),
                    ],
                  ),
                  Icon(_expanded ? Icons.expand_less : Icons.expand_more),
                ],
              ),
            ),
          ),
          if (_expanded)
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Column(
                children: [
                  const Divider(),
                  ...store.itemPrices.map(
                    (ip) => Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Expanded(
                            child: Text(ip.productName, maxLines: 1, overflow: TextOverflow.ellipsis),
                          ),
                          if (ip.quantity > 1) Text('×${ip.quantity}  '),
                          if (ip.onSale)
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 4, vertical: 1),
                              decoration: BoxDecoration(
                                color: Colors.red[600],
                                borderRadius: BorderRadius.circular(4),
                              ),
                              child: const Text('SALE', style: TextStyle(color: Colors.white, fontSize: 9)),
                            ),
                          const SizedBox(width: 8),
                          Text(
                            ip.subtotalDisplay,
                            style: const TextStyle(fontWeight: FontWeight.w600),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }
}
