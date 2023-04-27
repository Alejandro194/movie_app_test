import 'package:get/get.dart';
import 'package:movie_app_test/models/movie.dart';
import 'package:movie_app_test/services/tmbd_connection_sevice.dart';

class MovieController extends GetxController {
  var popularMovies = <Movie>[].obs;
  bool isLoading = true;
  Movie currenteMovie = Movie.emptyMovie();

  @override
  void onInit() {
    fetcPoularMovies(1);
    super.onInit();
  }

  void fetcPoularMovies(int page) async {
    updateIsLoading(true);
    var result = await TMBDConnectionService.getPopularMovies(page);
    updateIsLoading(false);
    if (result != null) {
      addNewPopularMovies(result);
    }
  }

  void getMovieDetails(int movieId) async {
    updateIsLoading(true);
    var result = await TMBDConnectionService.getMovieDetails(movieId);
    updateIsLoading(false);
    if (result.id != -1) {
      currenteMovie = result;
      update();
    }
  }

  void addNewPopularMovies(List<Movie> newMovies) {
    for (var movie in newMovies) {
      if (popularMovies.contains(movie) == false) {
        popularMovies.add(movie);
      }
    }
  }

  void updateIsLoading(bool value) {
    isLoading = value;
    update();
  }

  void updateCurrentMovie(Movie movie) {
    currenteMovie = movie;
    update();
  }
}
