import 'package:get/get.dart';
import 'package:movie_app_test/models/movie.dart';
import 'package:movie_app_test/services/tmbd_connection_sevice.dart';

class MovieController extends GetxController {
  List<Movie> popularMovies = [];

  void addMovies(List<Movie> newMovies) async { 
     popularMovies.addAll(newMovies);
    update();
  }
  
  MovieController(){
    
  }

}
