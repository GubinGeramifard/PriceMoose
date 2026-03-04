class ApiConstants {
  // Android emulator reaches host machine via 10.0.2.2
  // iOS simulator and web use localhost
  // Physical device: replace with your machine's LAN IP (e.g. http://192.168.1.x:8000)
  static const String _prodUrl = 'https://pricemoose-production.up.railway.app';

  static String get baseUrl {
    // Use production API for all platforms
    return _prodUrl;
  }

  static const double defaultRadiusKm = 25.0;
}

class ChainColors {
  static const loblaws = 0xFF1A3C6E;    // Loblaws dark blue
  static const walmart = 0xFF0071CE;    // Walmart blue
  static const sobeys = 0xFF00843D;     // Sobeys green
  static const metro = 0xFFE31837;      // Metro red

  static int forChain(String chain) {
    switch (chain) {
      case 'loblaws': return loblaws;
      case 'walmart': return walmart;
      case 'sobeys': return sobeys;
      case 'metro': return metro;
      default: return 0xFF666666;
    }
  }
}
