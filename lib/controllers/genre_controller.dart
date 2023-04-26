import 'package:get/get.dart';
import 'package:movie_app_test/models/genre.dart';
import 'package:movie_app_test/services/tmbd_connection_sevice.dart';

class GenreController extends GetxController {
  List<Genre> movieGenre = [];

  void getAllMovieGenre() async{
    if (movieGenre.isEmpty) {
      movieGenre = await TMBDConnectionService.getMovieGenreList();
    }
    update();
  }
}