import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../services/omdb_service.dart';
import 'movie_search_event.dart';
import 'movie_search_state.dart';

class MovieSearchBloc extends Bloc<MovieSearchEvent, MovieSearchState> {
  final OMDbService _omdbService;
  MovieSearchState? _lastSearchState;

  MovieSearchBloc({required OMDbService omdbService})
    : _omdbService = omdbService,
      super(const MovieSearchInitial()) {
    on<MovieSearchSubmitted>(_onMovieSearchSubmitted);
    on<MovieSelected>(_onMovieSelected);
    on<FetchMovieDetails>(_onFetchMovieDetails);
  }

  MovieSearchState? get lastSearchState => _lastSearchState;

  Future<void> _onMovieSearchSubmitted(
    MovieSearchSubmitted event,
    Emitter<MovieSearchState> emit,
  ) async {
    final query = event.query.trim();

    if (query.isEmpty) {
      emit(const MovieSearchInitial());
      _lastSearchState = null;
      return;
    }

    emit(const MovieSearchLoading());

    try {
      final movies = await _omdbService.searchMovies(query);

      if (movies.isNotEmpty) {
        final successState = MovieSearchSuccess(movies: movies, query: query);
        emit(successState);
        _lastSearchState = successState; 
      } else {
        final emptyState = MovieSearchEmpty(query);
        emit(emptyState);
        _lastSearchState = emptyState;
      }
    } catch (e) {
      final errorState = MovieSearchError('Failed to search movies: $e');
      emit(errorState);
      _lastSearchState = errorState;
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
