import 'package:flutter/material.dart';
import '../models/price_listing.dart';
import '../../core/constants.dart';

class PriceCard extends StatelessWidget {
  final PriceListing listing;
  final int rank;

  const PriceCard({super.key, required this.listing, required this.rank});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final chainColor = Color(ChainColors.forChain(listing.chain));
    final effectivePrice = listing.onSale && listing.salePriceDisplay != null
        ? listing.salePriceDisplay!
        : listing.priceDisplay;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            // Rank badge
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: rank == 1 ? Colors.amber : theme.colorScheme.surfaceContainerHighest,
                shape: BoxShape.circle,
              ),
              child: Center(
                child: Text(
                  '$rank',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    color: rank == 1 ? Colors.white : theme.colorScheme.onSurfaceVariant,
                    fontSize: 13,
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),

            // Store info
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 10,
                        height: 10,
                        decoration: BoxDecoration(
                          color: chainColor,
                          shape: BoxShape.circle,
                        ),
                      ),
                      const SizedBox(width: 6),
                      Flexible(
                        child: Text(
                          listing.banner ?? listing.storeName,
                          style: const TextStyle(fontWeight: FontWeight.w600, fontSize: 15),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      if (listing.onSale) ...[
                        const SizedBox(width: 6),
                        Container(
                          padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.red[600],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            'SALE',
                            style: TextStyle(color: Colors.white, fontSize: 10, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    listing.storeName,
                    style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontSize: 12),
                    overflow: TextOverflow.ellipsis,
                  ),
                  if (listing.distanceKm != null)
                    Text(
                      '${listing.distanceKm!.toStringAsFixed(1)} km away',
                      style: TextStyle(color: theme.colorScheme.onSurfaceVariant, fontSize: 11),
                    ),
                ],
              ),
            ),

            // Price
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  effectivePrice,
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: listing.onSale ? Colors.red[600] : theme.colorScheme.onSurface,
                  ),
                ),
                if (listing.onSale && listing.salePriceDisplay != null)
                  Text(
                    listing.priceDisplay,
                    style: TextStyle(
                      fontSize: 12,
                      color: theme.colorScheme.onSurfaceVariant,
                      decoration: TextDecoration.lineThrough,
                    ),
                  ),
                if (listing.unit != null)
                  Text(
                    listing.unit!,
                    style: TextStyle(fontSize: 11, color: theme.colorScheme.onSurfaceVariant),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
