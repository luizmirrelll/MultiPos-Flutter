import 'dart:ui';

import 'api_end_points.dart';
//import 'package:google_maps_flutter/google_maps_flutter.dart';

class Config {
  static final String baseUrl = ApiEndPoints.baseUrl;
  static int? userId;
  String clientId = '3',
      clientSecret = '1gEdDDj3uguYRHfkdjiHZ57OC00GNgBCSSr6LAUf',
      copyright = '\u00a9',
      appName = 'app',
      version = 'V 1.7',
      splashScreen = '${Config.baseUrl}/uploads/mobile/welcome.jpg',
      loginScreen = '${Config.baseUrl}/uploads/mobile/login.jpg',
      noDataImage = '${Config.baseUrl}/uploads/mobile/no_data.jpg',
      defaultBusinessImage = '${Config.baseUrl}/uploads/business_default.jpg';
  final bool syncCallLog =true, showRegister = true, showFieldForce = false;

  //quantity precision       //currency precision   //call_log sync duration
  static int quantityPrecision = 2, currencyPrecision = 2, callLogSyncDuration = 30;

  //List of locale language code
  List locale = ['en', 'ar', 'de', 'fr', 'es','tr','id','my','be','ch','it'];
  String defaultLanguage = 'en';

  //List of locales included
  List<Locale> supportedLocales = [
    Locale('en', 'US'),
    Locale('ar', ''),
    Locale('de', ''),
    Locale('fr', ''),
    Locale('es', ''),
    Locale('tr', ''),
    Locale('id', 'ID'),
    Locale('my', '')
  ];

  //dropdown items for changing language
  List<Map<String, dynamic>> lang = [
    {'languageCode': 'en', 'countryCode': 'US', 'name': 'English'},
    {'languageCode': 'ar', 'countryCode': '', 'name': 'العربي'},
    {'languageCode': 'de', 'countryCode': '', 'name': 'Deutsche'},
    {'languageCode': 'fr', 'countryCode': '', 'name': 'Français'},
    {'languageCode': 'es', 'countryCode': '', 'name': 'Española'},
    {'languageCode': 'tr', 'countryCode': '', 'name': 'Türkçe'},
    {'languageCode': 'id', 'countryCode': 'ID', 'name': 'Indonesian'},
	{'languageCode': 'be', 'countryCode': '', 'name': 'Bengali'},
    {'languageCode': 'ch', 'countryCode': '', 'name': 'chinese'},
    {'languageCode': 'it', 'countryCode': '', 'name': 'italian'},
    {'languageCode': 'my', 'countryCode': '', 'name': 'မြန်မာ'}
  ];

  //final initialPosition = LatLng(20.46752985010792, 82.92005813910752);
  final String googleAPIKey = '';
}
