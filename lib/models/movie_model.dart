class Movie {
  final String title;
  final String year;
  final String imdbID;
  final String poster;
  
  // Additional fields for detailed view
  final String? plot;
  final String? director;
  final String? actors;
  final String? genre;
  final String? runtime;
  final String? rating;
  final String? metascore;
  final String? imdbRating;
  final String? imdbVotes;
  final String? language;
  final String? country;
  final String? awards;
  final String? released;
  final String? writer;
  final String? production;

  Movie({
    required this.title,
    required this.year,
    required this.imdbID,
    required this.poster,
    this.plot,
    this.director,
    this.actors,
    this.genre,
    this.runtime,
    this.rating,
    this.metascore,
    this.imdbRating,
    this.imdbVotes,
    this.language,
    this.country,
    this.awards,
    this.released,
    this.writer,
    this.production,
  });

  // For search results (basic info)
  factory Movie.fromSearchJson(Map<String, dynamic> json) {
    return Movie(
      title: json['Title'] ?? '',
      year: json['Year'] ?? '',
      imdbID: json['imdbID'] ?? '',
      poster: json['Poster'] ?? '',
    );
  }

  // For detailed movie info
  factory Movie.fromDetailsJson(Map<String, dynamic> json) {
    return Movie(
      title: json['Title'] ?? '',
      year: json['Year'] ?? '',
      imdbID: json['imdbID'] ?? '',
      poster: json['Poster'] ?? '',
      plot: json['Plot'],
      director: json['Director'],
      actors: json['Actors'],
      genre: json['Genre'],
      runtime: json['Runtime'],
      rating: json['Rated'],
      metascore: json['Metascore'],
      imdbRating: json['imdbRating'],
      imdbVotes: json['imdbVotes'],
      language: json['Language'],
      country: json['Country'],
      awards: json['Awards'],
      released: json['Released'],
      writer: json['Writer'],
      production: json['Production'],
    );
  }

  // Keep the original fromJson for backward compatibility
  factory Movie.fromJson(Map<String, dynamic> json) {
    return Movie.fromSearchJson(json);
  }
}
