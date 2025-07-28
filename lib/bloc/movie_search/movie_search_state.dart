import 'package:equatable/equatable.dart';
import '../../../models/movie_model.dart';

abstract class MovieSearchState extends Equatable {
  const MovieSearchState();

  @override
  List<Object?> get props => [];
}

class MovieSearchInitial extends MovieSearchState {
  const MovieSearchInitial();
}

class MovieSearchLoading extends MovieSearchState {
  const MovieSearchLoading();
}

class MovieSearchSuccess extends MovieSearchState {
  final List<Movie> movies;
  final String query;

  const MovieSearchSuccess({
    required this.movies,
    required this.query,
  });

  @override
  List<Object?> get props => [movies, query];
}

class MovieSearchError extends MovieSearchState {
  final String message;

  const MovieSearchError(this.message);

  @override
  List<Object?> get props => [message];
}

class MovieSearchEmpty extends MovieSearchState {
  final String query;

  const MovieSearchEmpty(this.query);

  @override
  List<Object?> get props => [query];
}

// Movie Details States
class MovieDetailsLoading extends MovieSearchState {
  final String imdbID;
  const MovieDetailsLoading(this.imdbID);

  @override
  List<Object?> get props => [imdbID];
}

class MovieDetailsSuccess extends MovieSearchState {
  final Movie movieDetails;
  const MovieDetailsSuccess(this.movieDetails);

  @override
  List<Object?> get props => [movieDetails];
}

class MovieDetailsError extends MovieSearchState {
  final String message;
  const MovieDetailsError(this.message);

  @override
  List<Object?> get props => [message];
}
