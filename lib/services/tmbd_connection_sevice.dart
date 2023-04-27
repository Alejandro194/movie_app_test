import 'dart:convert';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:movie_app_test/controllers/error_controller.dart';
import 'package:movie_app_test/models/genre.dart';
import 'package:movie_app_test/models/movie.dart';

class TMBDConnectionService {
  static const String apiKey = '11a3b06330dbaa951074d127189ec094';
  static const String baseUrl = "api.themoviedb.org";

  static Future<List<Movie>> getPopularMovies(int page) async {
    final queryParams = {'api_key': apiKey, 'page': page.toString()};
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
    } on Exception catch (e) {
      Get.find<ErrorController>().errorDetected();
      return [];
    }
  }

  static Future<List<Genre>> getMovieGenreList() async {
    final queryParams = {'api_key': apiKey};
    try {
      var url = Uri.https(baseUrl, "/3/genre/movie/list", queryParams);
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        var genres = data['genres'] as List;
        final parseGenreList =
            genres.map<Genre>((json) => Genre.fromJson(json)).toList();
        Get.find<ErrorController>().everythingWentFineFetchingDate();
        print(parseGenreList.map((e) => e.name));
        return parseGenreList;
      } else {
        return [];
      }
    } on Exception catch (e) {
      Get.find<ErrorController>().errorDetected();
      return [];
    }
  }

  static Future<Movie> getMovieDetails(int movieId) async {
    final queryParams = {'api_key': apiKey};
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
    } on Exception catch (e) {
      Get.find<ErrorController>().errorDetected();
      return Movie.emptyMovie();
    }
  }
}
