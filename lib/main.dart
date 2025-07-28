import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

import 'bloc/movie_search/movie_search_bloc.dart';
import 'bloc/movie_search/movie_search_event.dart';
import 'bloc/movie_search/movie_search_state.dart';
import 'screens/movie_details_screen.dart';
import 'services/omdb_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");
  print(
    "App starting... API key loaded: ${dotenv.env['OMDB_API_KEY']?.isNotEmpty ?? false}",
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => MovieSearchBloc(omdbService: OMDbService()),
      child: MaterialApp(
        title: 'Movie Search App',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          scaffoldBackgroundColor: const Color(0xFFF5F6FA),
          appBarTheme: const AppBarTheme(
            backgroundColor: Colors.transparent,
            elevation: 0,
            centerTitle: true,
            titleTextStyle: TextStyle(
              color: Colors.deepPurple,
              fontWeight: FontWeight.bold,
              fontSize: 24,
            ),
            iconTheme: IconThemeData(color: Colors.deepPurple),
          ),
          inputDecorationTheme: InputDecorationTheme(
            filled: true,
            fillColor: Colors.white,
            contentPadding: EdgeInsets.symmetric(vertical: 18, horizontal: 20),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              borderSide: BorderSide(color: Colors.deepPurple, width: 1.2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(30)),
              borderSide: BorderSide(color: Colors.deepPurple, width: 2),
            ),
          ),
        ),
        home: const MyHomePage(title: 'Movie Search App'),
      ),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        title: Text(widget.title, textAlign: TextAlign.center),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            const _SearchWidget(),
            const SizedBox(height: 16),
            const Expanded(child: _ResultsWidget()),
          ],
        ),
      ),
    );
  }
}

class _SearchWidget extends StatefulWidget {
  const _SearchWidget();

  @override
  State<_SearchWidget> createState() => _SearchWidgetState();
}

class _SearchWidgetState extends State<_SearchWidget> {
  final TextEditingController _searchController = TextEditingController();
  final FocusNode _searchFocusNode = FocusNode();

  @override
  void dispose() {
    _searchController.dispose();
    _searchFocusNode.dispose();
    super.dispose();
  }

  void _performSearch() {
    final searchQuery = _searchController.text.trim();
    if (searchQuery.isNotEmpty) {
      _searchFocusNode.unfocus();
      context.read<MovieSearchBloc>().add(MovieSearchSubmitted(searchQuery));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: TextField(
            controller: _searchController,
            focusNode: _searchFocusNode,
            decoration: const InputDecoration(
              labelText: 'Search for a movie',
              prefixIcon: Icon(Icons.search),
            ),
            onSubmitted: (_) => _performSearch(),
          ),
        ),
        const SizedBox(width: 12),
        ElevatedButton(
          onPressed: _performSearch,
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.deepPurple,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(30),
            ),
          ),
          child: const Text('Search'),
        ),
      ],
    );
  }
}

class _ResultsWidget extends StatelessWidget {
  const _ResultsWidget();

  @override
  Widget build(BuildContext context) {
    return BlocListener<MovieSearchBloc, MovieSearchState>(
      listener: (context, state) {
        if (state is MovieDetailsSuccess) {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder:
                  (context) => MovieDetailsScreen(
                    imdbID: state.movieDetails.imdbID,
                    movieTitle: state.movieDetails.title,
                  ),
            ),
          );
        }
      },
      child: BlocSelector<MovieSearchBloc, MovieSearchState, MovieSearchState>(
        selector: (state) {
          // If showing movie details, show last search results instead
          if (state is MovieDetailsSuccess || state is MovieDetailsLoading || state is MovieDetailsError) {
            return context.read<MovieSearchBloc>().lastSearchState ?? state;
          }
          return state;
        },
        builder: (context, state) {
          if (state is MovieSearchInitial) {
            return const Center(
              child: Text(
                'Enter a movie title and tap Search',
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          } else if (state is MovieSearchLoading) {
            return const Center(child: CircularProgressIndicator());
          } else if (state is MovieSearchSuccess) {
            return ListView.separated(
              itemCount: state.movies.length,
              separatorBuilder: (context, index) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final movie = state.movies[index];
                return Card(
                  elevation: 3,
                  margin: EdgeInsets.zero,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 12,
                      horizontal: 16,
                    ),
                    child: ListTile(
                      title: Text(
                        movie.title,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(movie.year),
                      leading: CircleAvatar(
                        backgroundColor: Colors.deepPurple.shade100,
                        child: const Icon(
                          Icons.movie,
                          color: Colors.deepPurple,
                        ),
                      ),
                      trailing: const Icon(
                        Icons.arrow_forward_ios,
                        size: 16,
                        color: Colors.deepPurple,
                      ),
                      onTap: () {
                        context.read<MovieSearchBloc>().add(
                          MovieSelected(movie.imdbID),
                        );
                      },
                    ),
                  ),
                );
              },
            );
          } else if (state is MovieSearchError) {
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
                ],
              ),
            );
          } else if (state is MovieSearchEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.search_off, size: 64, color: Colors.grey),
                  const SizedBox(height: 16),
                  Text(
                    'No movies found for "${state.query}"',
                    style: const TextStyle(fontSize: 16, color: Colors.grey),
                    textAlign: TextAlign.center,
                  ),
                ],
              ),
            );
          }
          return const SizedBox.shrink();
        },
      ),
    );
  }
}
