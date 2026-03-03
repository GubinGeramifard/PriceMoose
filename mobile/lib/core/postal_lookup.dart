class PostalResult {
  final double lat;
  final double lng;
  final String city;
  const PostalResult(this.lat, this.lng, this.city);
}

/// Resolves Canadian postal codes to approximate lat/lng.
/// Keyed by the first 2 characters of the FSA (e.g. "M5" covers all M5x codes).
class PostalLookup {
  static const _map = <String, PostalResult>{
    // Ontario — Toronto proper
    'M1': PostalResult(43.7654, -79.1950, 'Scarborough, ON'),
    'M2': PostalResult(43.7534, -79.3830, 'North York, ON'),
    'M3': PostalResult(43.7584, -79.4432, 'North York, ON'),
    'M4': PostalResult(43.7000, -79.3800, 'East Toronto, ON'),
    'M5': PostalResult(43.6532, -79.3832, 'Toronto, ON'),
    'M6': PostalResult(43.6700, -79.4500, 'West Toronto, ON'),
    'M7': PostalResult(43.6426, -79.3871, 'Toronto, ON'),
    'M8': PostalResult(43.6200, -79.5000, 'Etobicoke, ON'),
    'M9': PostalResult(43.6900, -79.5300, 'Etobicoke, ON'),
    // Ontario — GTA
    'L1': PostalResult(43.9000, -78.8500, 'Oshawa, ON'),
    'L2': PostalResult(43.0896, -79.0849, 'Niagara Falls, ON'),
    'L3': PostalResult(43.8600, -79.3300, 'Markham, ON'),
    'L4': PostalResult(43.8700, -79.4600, 'Richmond Hill, ON'),
    'L5': PostalResult(43.6000, -79.6500, 'Mississauga, ON'),
    'L6': PostalResult(43.7315, -79.7624, 'Brampton, ON'),
    'L7': PostalResult(43.4675, -79.6877, 'Oakville, ON'),
    'L8': PostalResult(43.2557, -79.8711, 'Hamilton, ON'),
    'L9': PostalResult(44.3894, -79.6903, 'Barrie, ON'),
    // Ontario — SW
    'N1': PostalResult(43.5448, -80.2482, 'Guelph, ON'),
    'N2': PostalResult(43.4516, -80.4925, 'Kitchener-Waterloo, ON'),
    'N3': PostalResult(43.3616, -80.3144, 'Cambridge, ON'),
    'N5': PostalResult(42.9846, -81.2453, 'London, ON'),
    'N6': PostalResult(42.9849, -81.2453, 'London, ON'),
    // Ontario — Eastern
    'K1': PostalResult(45.4215, -75.6972, 'Ottawa, ON'),
    'K2': PostalResult(45.3490, -75.7559, 'Nepean/Kanata, ON'),
    'K7': PostalResult(44.2312, -76.4860, 'Kingston, ON'),
    'K8': PostalResult(44.1000, -77.5700, 'Trenton, ON'),
    // Quebec — Montreal
    'H1': PostalResult(45.5850, -73.5400, 'Montréal, QC'),
    'H2': PostalResult(45.5284, -73.5818, 'Montréal, QC'),
    'H3': PostalResult(45.4981, -73.5673, 'Montréal, QC'),
    'H4': PostalResult(45.4650, -73.6300, 'Montréal-Ouest, QC'),
    'H7': PostalResult(45.6800, -73.7000, 'Laval, QC'),
    'H8': PostalResult(45.4700, -73.7800, 'Dorval, QC'),
    'H9': PostalResult(45.5000, -73.8800, 'Pierrefonds, QC'),
    // Quebec — Quebec City
    'G1': PostalResult(46.8139, -71.2082, 'Québec City, QC'),
    'G2': PostalResult(46.8500, -71.3500, 'Québec City, QC'),
    'G3': PostalResult(46.9000, -71.4000, 'Québec City, QC'),
    // BC — Vancouver
    'V3': PostalResult(49.1044, -122.8011, 'Surrey, BC'),
    'V4': PostalResult(49.1666, -123.1336, 'Richmond, BC'),
    'V5': PostalResult(49.2500, -123.0900, 'Vancouver, BC'),
    'V6': PostalResult(49.2827, -123.1207, 'Vancouver, BC'),
    'V7': PostalResult(49.3200, -123.0700, 'North Vancouver, BC'),
    'V8': PostalResult(48.4284, -123.3656, 'Victoria, BC'),
    'V9': PostalResult(49.1659, -123.9401, 'Nanaimo, BC'),
    'V1': PostalResult(49.8880, -119.4960, 'Kelowna, BC'),
    'V2': PostalResult(49.1577, -121.9514, 'Chilliwack, BC'),
    // Alberta
    'T1': PostalResult(52.2690, -113.8116, 'Red Deer, AB'),
    'T2': PostalResult(51.0447, -114.0719, 'Calgary, AB'),
    'T3': PostalResult(51.0800, -114.1800, 'Calgary NW, AB'),
    'T5': PostalResult(53.5461, -113.4938, 'Edmonton, AB'),
    'T6': PostalResult(53.5200, -113.5700, 'Edmonton South, AB'),
    // Saskatchewan
    'S4': PostalResult(50.4452, -104.6189, 'Regina, SK'),
    'S7': PostalResult(52.1579, -106.6702, 'Saskatoon, SK'),
    // Manitoba
    'R2': PostalResult(49.9000, -97.1500, 'Winnipeg East, MB'),
    'R3': PostalResult(49.8951, -97.1384, 'Winnipeg, MB'),
    // Nova Scotia
    'B2': PostalResult(45.3700, -63.2700, 'Truro, NS'),
    'B3': PostalResult(44.6488, -63.5752, 'Halifax, NS'),
    // New Brunswick
    'E1': PostalResult(46.0878, -64.7782, 'Moncton, NB'),
    'E2': PostalResult(45.2733, -66.0633, 'Saint John, NB'),
    'E3': PostalResult(45.9636, -66.6431, 'Fredericton, NB'),
    // Newfoundland
    'A1': PostalResult(47.5615, -52.7126, "St. John's, NL"),
    // PEI
    'C1': PostalResult(46.2382, -63.1311, 'Charlottetown, PE'),
  };

  /// Resolves a postal code string (any format) to coordinates.
  /// Returns null if the FSA prefix is not recognized.
  static PostalResult? resolve(String postalCode) {
    final clean = postalCode.toUpperCase().replaceAll(RegExp(r'\s+'), '');
    if (clean.length < 2) return null;
    return _map[clean.substring(0, 2)];
  }
}
