import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../services/omdb_service.dart';
import 'movie_search_event.dart';
import 'movie_search_state.dart';

class MovieSearchBloc extends Bloc<MovieSearchEvent, MovieSearchState> {
  final OMDbService _omdbService;

  MovieSearchBloc({required OMDbService omdbService})
    : _omdbService = omdbService,
      super(const MovieSearchInitial()) {
    on<MovieSearchSubmitted>(_onMovieSearchSubmitted);
    on<MovieSelected>(_onMovieSelected);
    on<FetchMovieDetails>(_onFetchMovieDetails);
  }

  Future<void> _onMovieSearchSubmitted(
    MovieSearchSubmitted event,
    Emitter<MovieSearchState> emit,
  ) async {
    final query = event.query.trim();

    if (query.isEmpty) {
      emit(const MovieSearchInitial());
      return;
    }

    emit(const MovieSearchLoading());

    try {
      final movies = await _omdbService.searchMovies(query);

      if (movies.isNotEmpty) {
        emit(MovieSearchSuccess(movies: movies, query: query));
      } else {
        emit(MovieSearchEmpty(query));
      }
    } catch (e) {
      emit(MovieSearchError('Failed to search movies: $e'));
    }
  }

  void _onMovieSelected(MovieSelected event, Emitter<MovieSearchState> emit) {
    add(FetchMovieDetails(event.imdbID));
  }

  Future<void> _onFetchMovieDetails(
    FetchMovieDetails event,
    Emitter<MovieSearchState> emit,
  ) async {
    emit(MovieDetailsLoading(event.imdbID));

    try {
      final movieDetails = await _omdbService.getMovieDetails(event.imdbID);
      emit(MovieDetailsSuccess(movieDetails));
    } catch (e) {
      emit(MovieDetailsError('Failed to load movie details: $e'));
    }
  }
}
