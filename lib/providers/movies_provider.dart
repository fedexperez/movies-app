import 'dart:async';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:movies/helpers/debouncer.dart';

import 'package:movies/models/models.dart';

class MoviesProvider extends ChangeNotifier {
  //Here you must use your own api key
  final String _apiKey = 'YOUR_API_KEY';
  final String _baseUrl = 'api.themoviedb.org';
  final String _language = 'en-US';

  List<Movie> onDisplayMovies = [];
  List<Movie> nowPopularMovies = [];

  Map<int, List<Cast>> moviesCast = {};

  int _popularPage = 0;

  final StreamController<List<Movie>> _suggestionsStreamController =
      StreamController.broadcast();

  Stream<List<Movie>> get suggestionStream =>
      _suggestionsStreamController.stream;

  final debouncer = Debouncer(duration: const Duration(milliseconds: 200));

  MoviesProvider() {
    // print('Movies Provider Started');
    getNowPlayingMovies();
    getPopularMovies();
  }

  Future<String> _getJsonData(String endPoint, {int page = 1}) async {
    final url = Uri.https(_baseUrl, endPoint, {
      'api_key': _apiKey,
      'language': _language,
      'page': '$page',
    });

    final response = await http.get(url);
    return response.body;
  }

  getNowPlayingMovies() async {
    final jsonData = await _getJsonData('3/movie/now_playing');
    final nowPlayingMoviesResponse = NowPlayingMovies.fromJson(jsonData);

    onDisplayMovies = nowPlayingMoviesResponse.results;
    notifyListeners();
  }

  getPopularMovies() async {
    _popularPage++;

    final jsonData = await _getJsonData('3/movie/popular', page: _popularPage);
    final popularMoviesResponse = PopularMovies.fromJson(jsonData);

    nowPopularMovies = [...nowPopularMovies, ...popularMoviesResponse.results];
    notifyListeners();
  }

  Future<List<Cast>> getCreditsResponse(int movieId) async {
    if (moviesCast.containsKey(movieId)) return moviesCast[movieId]!;
    // print('Asking for actors of movie $movieId');
    final jsonData = await _getJsonData('3/movie/$movieId/credits');
    final creditsResponse = CreditsResponse.fromJson(jsonData);
    moviesCast[movieId] = creditsResponse.cast;
    return creditsResponse.cast;
  }

  Future<List<Movie>> searchMovies(String query) async {
    final url = Uri.https(_baseUrl, '3/search/movie', {
      'api_key': _apiKey,
      'language': _language,
      'page': '1',
      'query': query,
    });

    final response = await http.get(url);
    final searchResponse = SearchResponse.fromJson(response.body);

    return searchResponse.results;
  }

  void getSuggestionsByQuery(String searchTerm) {
    debouncer.value = '';
    debouncer.onValue = (value) async {
      final results = await searchMovies(value);
      _suggestionsStreamController.add(results);
    };

    final timer = Timer.periodic(const Duration(milliseconds: 300), (_) {
      debouncer.value = searchTerm;
    });

    Future.delayed(const Duration(milliseconds: 301))
        .then((_) => timer.cancel());
  }
}
