import 'package:get/get.dart';
import 'package:movie_app_test/models/movie.dart';
import 'package:movie_app_test/services/tmbd_connection_sevice.dart';

class MovieController extends GetxController {
  List<Movie> currentMovieList = [];
  Movie currentMovie = Movie(
      id: -1,
      backdropPath: "",
      posterPath: "",
      title: "",
      overview: "",
      language: "",
      genres: [],
      productionCountries: [],
      productionCompanies: [],
      belongsTocollection: false,
      releaseDate: DateTime(0),
      budget: -1,
      revenue: -1,
      runtime: -1,
      status: "",
      tagline: "",
      voteAverage: -1,
      voteCount: -1);

  void addMovies(List<Movie> newMovies) async {
    for (var movie in newMovies) { if (currentMovieList.contains(movie) == false) {
      currentMovieList.add(movie);
    } }
    update();
  }

  void setCurrentMovie(Movie movie){
    currentMovie = movie;
    update();
  }
}
