import 'dart:convert';

import 'package:http/http.dart' as http;

import '../constants.dart';
import '../models/movie_model.dart';

class OMDbService {
  Future<List<Movie>> searchMovies(String query) async {
    final apiKey = OMDbAPIKey;
    if (apiKey.isEmpty) {
      throw Exception('API key not configured');
    }

    final url = Uri.parse('$OMDbBaseUrl?apikey=$apiKey&s=$query');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['Response'] == 'True') {
          final List moviesJson = data['Search'];
          return moviesJson.map((json) => Movie.fromSearchJson(json)).toList();
        } else {
          throw Exception(data['Error'] ?? 'No movies found');
        }
      } else {
        throw Exception('API Error: ${response.statusCode}');
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Network error: $e');
    }
  }

  Future<Movie> getMovieDetails(String imdbID) async {
    final apiKey = OMDbAPIKey;
    if (apiKey.isEmpty) {
      throw Exception('API key not configured');
    }

    final url = Uri.parse('$OMDbBaseUrl?apikey=$apiKey&i=$imdbID');

    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);

        if (data['Response'] == 'True') {
          return Movie.fromDetailsJson(data);
        } else {
          throw Exception(data['Error'] ?? 'Movie details not found');
        }
      } else {
        throw Exception('API Error: ${response.statusCode}');
      }
    } catch (e) {
      if (e is Exception) {
        rethrow;
      }
      throw Exception('Network error: $e');
    }
  }
}
