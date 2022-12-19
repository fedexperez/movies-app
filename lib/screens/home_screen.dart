import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'package:movies/providers/movies_provider.dart';
import 'package:movies/search/search_delegate.dart';
import 'package:movies/widgets/widgets.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final moviesProvider = Provider.of<MoviesProvider>(context);

    return Scaffold(
        appBar: AppBar(
          title: const Text('Movie Box-Office'),
          actions: [
            IconButton(
                onPressed: (() => showSearch(
                    context: context, delegate: MovieSearchDelegate())),
                icon: const Icon(Icons.search)),
          ],
        ),
        body: SingleChildScrollView(
          child: Column(
            children: [
              CardSwipper(movies: moviesProvider.onDisplayMovies),

              //Row of movies
              MovieSliderScreen(
                title: 'Popular',
                movies: moviesProvider.nowPopularMovies,
                onNextPage: () {
                  return moviesProvider.getPopularMovies();
                },
              ),
            ],
          ),
        ));
  }
}
