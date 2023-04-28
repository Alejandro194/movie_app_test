import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:movie_app_test/controllers/error_controller.dart';
import 'package:movie_app_test/controllers/movie_controller.dart';
import 'package:mocktail/mocktail.dart';

class MockMovieController extends Mock implements MovieController {}

void main() {
  late MovieController sut;
  late ErrorController errorController;

  setUp(() {
    sut = MovieController();
    errorController = Get.put(ErrorController());
  });

  test("intial values are correct", () {
    expect(sut.popularMovies, []);
    expect(sut.isLoading, true);
    expect(sut.currenteMovie.id, -1);
  });



}
