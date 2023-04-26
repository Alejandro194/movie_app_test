import 'dart:convert';
import 'dart:io';

import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:movie_app_test/controllers/error_controller.dart';
import 'package:movie_app_test/controllers/movie_controller.dart';
import 'package:movie_app_test/models/movie.dart';

class TMBDConnectionService {
  static const String apiKey = '11a3b06330dbaa951074d127189ec094';
  static String baseURL = "https://api.themoviedb.org/3/movie/550";
  

  static Future<List<Movie>> getMoviesPopularMovies(int page) async {
     final queryParams = {'api_key': apiKey, 'page': page.toString()};
    try {
      var url =
          Uri.https("api.themoviedb.org", "/3/movie/popular", queryParams);
      var response = await http.get(url);
      if (response.statusCode == 200) {
        var data = json.decode(response.body);
        var movieList = data['results'] as List;
        final parseMovieList = movieList
            .map<Movie>((json) => Movie.fromJsonPopularMovies(json))
            .toList();
        Get.find<ErrorController>().resetErrorOcurredWhileFetchingData();
        return parseMovieList;
      } else {
        return [];
      }
    } on Exception catch (e) {
      Get.find<ErrorController>().errorDetected();
      return [];
    }
  }
}
