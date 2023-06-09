import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:movie_app_test/controllers/error_controller.dart';
import 'package:movie_app_test/models/genre.dart';
import 'package:movie_app_test/models/movie.dart';

class TMBDConnectionService {
  static const String baseUrl = "api.themoviedb.org";

  static Future<List<Movie>> getPopularMovies(int page) async {
    final queryParams = {'api_key': dotenv.get("api_key"), 'page': page.toString()};
    try {
      var url = Uri.https(baseUrl, "/3/movie/popular", queryParams);
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        var movieList = data['results'] as List;
        final parseMovieList = movieList
            .map<Movie>((json) => Movie.fromJsonPopularMovies(json))
            .toList();
        Get.find<ErrorController>().everythingWentFineFetchingDate();
        return parseMovieList;
      } else {
        return [];
      }
    } on Exception {
      Get.find<ErrorController>().errorDetected();
      return [];
    }
  }

  static Future<List<Genre>> getMovieGenreList() async {
    final queryParams = {'api_key': dotenv.get("api_key")};
    try {
      var url = Uri.https(baseUrl, "/3/genre/movie/list", queryParams);
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        var genres = data['genres'] as List;
        final parseGenreList =
            genres.map<Genre>((json) => Genre.fromJson(json)).toList();
        Get.find<ErrorController>().everythingWentFineFetchingDate();
        return parseGenreList;
      } else {
        return [];
      }
    } on Exception {
      Get.find<ErrorController>().errorDetected();
      return [];
    }
  }

  static Future<Movie> getMovieDetails(int movieId) async {
    final queryParams = {'api_key': dotenv.get("api_key")};
    try {
      var url = Uri.https(baseUrl, "/3/movie/$movieId", queryParams);
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        var movie = Movie.fromJson(data);
        Get.find<ErrorController>().everythingWentFineFetchingDate();
        return movie;
      } else {
        return Movie.emptyMovie();
      }
    } on Exception {
      Get.find<ErrorController>().errorDetected();
      return Movie.emptyMovie();
    }
  }
}
