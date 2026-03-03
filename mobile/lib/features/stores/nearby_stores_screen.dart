import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong2/latlong.dart';
import 'package:geolocator/geolocator.dart';

import '../../core/api/api_client.dart';
import '../../core/constants.dart';
import '../../shared/models/store.dart';
import '../../shared/widgets/store_chip.dart';
import '../settings/settings_provider.dart';

final _locationProvider = FutureProvider<Position?>((ref) async {
  try {
    var perm = await Geolocator.checkPermission();
    if (perm == LocationPermission.denied) {
      perm = await Geolocator.requestPermission();
    }
    if (perm == LocationPermission.always || perm == LocationPermission.whileInUse) {
      return Geolocator.getCurrentPosition(desiredAccuracy: LocationAccuracy.medium);
    }
  } catch (_) {}
  return null;
});

final _selectedChainProvider = StateProvider<String?>((ref) => null);

final _nearbyStoresProvider = FutureProvider<List<Store>>((ref) async {
  final position = await ref.watch(_locationProvider.future);
  final chain = ref.watch(_selectedChainProvider);
  final settings = ref.read(settingsProvider);

  // Use GPS if available, otherwise fall back to user's postal code setting
  final lat = position?.latitude ?? settings.lat;
  final lng = position?.longitude ?? settings.lng;

  return ref.read(groceryApiProvider).getNearbyStores(
        lat,
        lng,
        radiusKm: ApiConstants.defaultRadiusKm,
        chain: chain,
      );
});

class NearbyStoresScreen extends ConsumerStatefulWidget {
  const NearbyStoresScreen({super.key});

  @override
  ConsumerState<NearbyStoresScreen> createState() => _NearbyStoresScreenState();
}

class _NearbyStoresScreenState extends ConsumerState<NearbyStoresScreen> {
  final _mapController = MapController();
  Store? _selectedStore;

  @override
  Widget build(BuildContext context) {
    final locationAsync = ref.watch(_locationProvider);
    final storesAsync = ref.watch(_nearbyStoresProvider);
    final selectedChain = ref.watch(_selectedChainProvider);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Nearby Stores'),
        bottom: PreferredSize(
          preferredSize: const Size.fromHeight(52),
          child: SizedBox(
            height: 52,
            child: ListView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              children: [
                StoreChip(
                  chain: 'all',
                  banner: 'All',
                  selected: selectedChain == null,
                  onTap: () => ref.read(_selectedChainProvider.notifier).state = null,
                ),
                const SizedBox(width: 8),
                for (final chain in ['loblaws', 'walmart', 'sobeys', 'metro'])
                  Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: StoreChip(
                      chain: chain,
                      selected: selectedChain == chain,
                      onTap: () => ref.read(_selectedChainProvider.notifier).state =
                          selectedChain == chain ? null : chain,
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
      body: locationAsync.when(
        loading: () => const Center(child: CircularProgressIndicator()),
        error: (_, __) => _buildMap(storesAsync, null),
        data: (position) => _buildMap(storesAsync, position),
      ),
    );
  }

  Widget _buildMap(AsyncValue<List<Store>> storesAsync, Position? position) {
    final settings = ref.read(settingsProvider);
    final center = position != null
        ? LatLng(position.latitude, position.longitude)
        : LatLng(settings.lat, settings.lng);

    return Stack(
      children: [
        FlutterMap(
          mapController: _mapController,
          options: MapOptions(
            initialCenter: center,
            initialZoom: 12,
            onTap: (_, __) => setState(() => _selectedStore = null),
          ),
          children: [
            TileLayer(
              urlTemplate: 'https://tile.openstreetmap.org/{z}/{x}/{y}.png',
              userAgentPackageName: 'ca.grocerycompare.app',
            ),
            if (position != null)
              CircleLayer(circles: [
                CircleMarker(
                  point: center,
                  radius: 10,
                  color: Colors.blue.withValues(alpha: 0.3),
                  borderColor: Colors.blue,
                  borderStrokeWidth: 2,
                  useRadiusInMeter: false,
                ),
              ]),
            storesAsync.maybeWhen(
              data: (stores) => MarkerLayer(
                markers: stores.map((store) {
                  if (store.lat == null || store.lng == null) {
                    return Marker(point: center, child: const SizedBox.shrink());
                  }
                  final isSelected = _selectedStore?.id == store.id;
                  final color = Color(ChainColors.forChain(store.chain));
                  return Marker(
                    point: LatLng(store.lat!, store.lng!),
                    width: 36,
                    height: 36,
                    child: GestureDetector(
                      onTap: () => setState(() => _selectedStore = store),
                      child: AnimatedContainer(
                        duration: const Duration(milliseconds: 150),
                        decoration: BoxDecoration(
                          color: isSelected ? color : color.withValues(alpha: 0.85),
                          shape: BoxShape.circle,
                          border: Border.all(color: Colors.white, width: 2),
                          boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: isSelected ? 8 : 4)],
                        ),
                        child: Icon(Icons.store, color: Colors.white, size: isSelected ? 22 : 18),
                      ),
                    ),
                  );
                }).toList(),
              ),
              orElse: () => const MarkerLayer(markers: []),
            ),
          ],
        ),

        // Store info bottom sheet
        if (_selectedStore != null)
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: _StoreInfoCard(store: _selectedStore!, onClose: () => setState(() => _selectedStore = null)),
          ),

        // Loading indicator
        if (storesAsync.isLoading)
          const Positioned(
            top: 16,
            left: 0,
            right: 0,
            child: Center(child: CircularProgressIndicator()),
          ),
      ],
    );
  }
}

class _StoreInfoCard extends StatelessWidget {
  final Store store;
  final VoidCallback onClose;

  const _StoreInfoCard({required this.store, required this.onClose});

  @override
  Widget build(BuildContext context) {
    final color = Color(ChainColors.forChain(store.chain));

    return Container(
      margin: const EdgeInsets.all(12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surface,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.15), blurRadius: 12, offset: const Offset(0, -2))],
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(color: color, borderRadius: BorderRadius.circular(10)),
            child: const Icon(Icons.store, color: Colors.white),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  store.banner ?? store.name,
                  style: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16),
                ),
                if (store.address != null)
                  Text(store.address!, style: TextStyle(color: Colors.grey[600], fontSize: 13)),
                if (store.distanceKm != null)
                  Text(
                    '${store.distanceKm!.toStringAsFixed(1)} km away',
                    style: const TextStyle(fontSize: 12, color: Colors.grey),
                  ),
              ],
            ),
          ),
          IconButton(icon: const Icon(Icons.close), onPressed: onClose),
        ],
      ),
    );
  }
}
