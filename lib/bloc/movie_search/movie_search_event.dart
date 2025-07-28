import 'package:equatable/equatable.dart';

abstract class MovieSearchEvent extends Equatable {
  const MovieSearchEvent();

  @override
  List<Object?> get props => [];
}

class MovieSearchSubmitted extends MovieSearchEvent {
  final String query;
  const MovieSearchSubmitted(this.query);

  @override
  List<Object?> get props => [query];
}

class MovieSelected extends MovieSearchEvent {
  final String imdbID;
  const MovieSelected(this.imdbID);

  @override
  List<Object?> get props => [imdbID];
}

class FetchMovieDetails extends MovieSearchEvent {
  final String imdbID;
  const FetchMovieDetails(this.imdbID);

  @override
  List<Object?> get props => [imdbID];
}
