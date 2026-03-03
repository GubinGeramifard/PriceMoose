import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../../core/postal_lookup.dart';

class SettingsState {
  final String postalCode;
  final double lat;
  final double lng;
  final String city;

  const SettingsState({
    this.postalCode = 'M5V',
    this.lat = 43.6532,
    this.lng = -79.3832,
    this.city = 'Toronto, ON',
  });
}

class SettingsNotifier extends StateNotifier<SettingsState> {
  static const _postalKey = 'postal_code';
  final Box _box;

  SettingsNotifier(this._box) : super(const SettingsState()) {
    _load();
  }

  void _load() {
    final saved = _box.get(_postalKey) as String?;
    if (saved == null) return;
    final result = PostalLookup.resolve(saved);
    if (result != null) {
      state = SettingsState(
        postalCode: saved,
        lat: result.lat,
        lng: result.lng,
        city: result.city,
      );
    }
  }

  /// Returns true if the postal code was recognized and saved.
  bool setPostalCode(String code) {
    final clean = code.toUpperCase().replaceAll(RegExp(r'\s+'), '');
    final result = PostalLookup.resolve(clean);
    if (result == null) return false;
    _box.put(_postalKey, clean);
    state = SettingsState(
      postalCode: clean,
      lat: result.lat,
      lng: result.lng,
      city: result.city,
    );
    return true;
  }
}

final settingsProvider = StateNotifierProvider<SettingsNotifier, SettingsState>(
  (ref) => SettingsNotifier(Hive.box('settings')),
);
