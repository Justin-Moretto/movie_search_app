import 'package:flutter_dotenv/flutter_dotenv.dart';

final String OMDbAPIKey = dotenv.env['OMDB_API_KEY']!;
const String OMDbBaseUrl = 'http://www.omdbapi.com/';
