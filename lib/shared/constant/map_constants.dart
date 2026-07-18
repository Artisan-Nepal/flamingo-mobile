class MapConstants {
  // Google Places API key for the search box (autocomplete). Passed at launch
  // via --dart-define-from-file (config/*.json), same pattern as API_BASE_URL,
  // so the key never lives in source control. The Maps SDK key (for the map
  // tiles themselves) is configured natively in AndroidManifest.xml / AppDelegate.
  static const googlePlacesApiKey = String.fromEnvironment('GOOGLE_PLACES_API_KEY');

  // Default map center when we have no existing address or device location yet:
  // central Kathmandu.
  static const double defaultLatitude = 27.7172;
  static const double defaultLongitude = 85.3240;
  static const double defaultZoom = 16.0;

  // Bias place-autocomplete results to Nepal.
  static const String countryCode = 'np';
}
