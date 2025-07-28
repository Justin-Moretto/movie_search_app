import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/movie_search/movie_search_bloc.dart';
import '../bloc/movie_search/movie_search_state.dart';
import '../bloc/movie_search/movie_search_event.dart';
import '../models/movie_model.dart';

class MovieDetailsScreen extends StatelessWidget {
  final String imdbID;
  final String movieTitle;

  const MovieDetailsScreen({
    super.key,
    required this.imdbID,
    required this.movieTitle,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(movieTitle),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: BlocBuilder<MovieSearchBloc, MovieSearchState>(
        builder: (context, state) {
          if (state is MovieDetailsLoading) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          } else if (state is MovieDetailsSuccess) {
            return _buildMovieDetails(context, state.movieDetails);
          } else if (state is MovieDetailsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.error_outline, size: 64, color: Colors.red),
                  const SizedBox(height: 16),
                  Text(
                    state.message,
                    style: const TextStyle(fontSize: 16, color: Colors.red),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 16),
                  ElevatedButton(
                    onPressed: () {
                      context.read<MovieSearchBloc>().add(FetchMovieDetails(imdbID));
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }
          return const Center(
            child: Text('Loading movie details...'),
          );
        },
      ),
    );
  }

  Widget _buildMovieDetails(BuildContext context, Movie movie) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Poster and basic info
          if (movie.poster.isNotEmpty && movie.poster != 'N/A')
            Center(
              child: ClipRRect(
                borderRadius: BorderRadius.circular(12),
                child: Image.network(
                  movie.poster,
                  height: 300,
                  width: 200,
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) {
                    return Container(
                      height: 300,
                      width: 200,
                      decoration: BoxDecoration(
                        color: Colors.grey[300],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: const Icon(Icons.movie, size: 64, color: Colors.grey),
                    );
                  },
                ),
              ),
            ),
          const SizedBox(height: 24),
          
          // Title and year
          Text(
            '${movie.title} (${movie.year})',
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          
          // Plot
          if (movie.plot != null && movie.plot!.isNotEmpty && movie.plot != 'N/A') ...[
            const Text(
              'Plot',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              movie.plot!,
              style: const TextStyle(fontSize: 16),
            ),
            const SizedBox(height: 16),
          ],
          
          // Details grid
          _buildDetailRow('Director', movie.director),
          _buildDetailRow('Cast', movie.actors),
          _buildDetailRow('Genre', movie.genre),
          _buildDetailRow('Runtime', movie.runtime),
          _buildDetailRow('Rating', movie.rating),
          _buildDetailRow('Released', movie.released),
          _buildDetailRow('Language', movie.language),
          _buildDetailRow('Country', movie.country),
          _buildDetailRow('Writer', movie.writer),
          _buildDetailRow('Production', movie.production),
          
          // Ratings
          if (movie.imdbRating != null && movie.imdbRating!.isNotEmpty && movie.imdbRating != 'N/A') ...[
            const SizedBox(height: 16),
            const Text(
              'Ratings',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                _buildRatingChip('IMDb', movie.imdbRating!),
                if (movie.metascore != null && movie.metascore!.isNotEmpty && movie.metascore != 'N/A')
                  _buildRatingChip('Metascore', movie.metascore!),
              ],
            ),
          ],
          
          // Awards
          if (movie.awards != null && movie.awards!.isNotEmpty && movie.awards != 'N/A') ...[
            const SizedBox(height: 16),
            const Text(
              'Awards',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              movie.awards!,
              style: const TextStyle(fontSize: 16),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String? value) {
    if (value == null || value.isEmpty || value == 'N/A') return const SizedBox.shrink();
    
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 16,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(fontSize: 16),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRatingChip(String label, String rating) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: Colors.deepPurple,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Text(
        '$label: $rating',
        style: const TextStyle(
          color: Colors.white,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
} 