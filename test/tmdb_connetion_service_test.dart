import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:movie_app_test/controllers/error_controller.dart';
import 'package:movie_app_test/models/genre.dart';
import 'package:movie_app_test/models/movie.dart';
import 'package:movie_app_test/services/tmbd_connection_sevice.dart';

void main() {
  
  setUp(() => Get.put(ErrorController()));

  test("Conection service correct intial values", () {
    expect(TMBDConnectionService.apiKey, '11a3b06330dbaa951074d127189ec094');
    expect(TMBDConnectionService.baseUrl, "api.themoviedb.org");
  });

  test("get popular movies correct return type", () {
    expect(
        TMBDConnectionService.getPopularMovies(1), isA<Future<List<Movie>>>());
  });

  test("get movie detail correct return type", () {
    expect(TMBDConnectionService.getMovieDetails(1), isA<Future<Movie>>());
  });

  test("get movie genre list correct return type", () {
    expect(
        TMBDConnectionService.getMovieGenreList(), isA<Future<List<Genre>>>());
  });
}
