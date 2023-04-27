import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:get/get.dart';
import 'package:movie_app_test/controllers/error_controller.dart';
import 'package:movie_app_test/controllers/genre_controller.dart';
import 'package:movie_app_test/controllers/movie_controller.dart';
import 'package:movie_app_test/models/movie.dart';
import 'package:movie_app_test/screens/movie_details/movie_details_screen.dart';
import 'package:movie_app_test/services/tmbd_connection_sevice.dart';

class PopularMoviesScreen extends StatefulWidget {
  const PopularMoviesScreen({super.key});

  @override
  State<PopularMoviesScreen> createState() => _PopularMoviesScreenState();
}

class _PopularMoviesScreenState extends State<PopularMoviesScreen> {
  late Future<List<Movie>> futureMovies;
  List<Movie> popularMovies = [];
  bool errorFetching = false;
  int crossAxisCount = 1;
  double popularityIndexSize = 7;
  double popularityIndexFontSize = 14;
  double bodySize = 730;
  UniqueKey movieImageKey = UniqueKey();
  int page = 2;
  ScrollController gridViewScrollControlller = ScrollController();
  int errorScreenSpacing = 100;

  @override
  void initState() {
    super.initState();
    Get.find<GenreController>().getAllMovieGenre();
    futureMovies = TMBDConnectionService.getPopularMovies(1);
    gridViewScrollControlller.addListener(() {
      if (gridViewScrollControlller.position.maxScrollExtent ==
          gridViewScrollControlller.offset) {
        addMoreMoviesToList();
      }
    });
  }

  void addMoreMoviesToList() async {
    futureMovies = TMBDConnectionService.getPopularMovies(page);
    setState(() {
      page++;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: GetBuilder<ErrorController>(
        builder: (_) {
          if (_.errorOcurredWhileFetchingData) {
            return errorFetchingScreen();
          } else {
            return SingleChildScrollView(
              child: FutureBuilder<List<Movie>>(
                future: futureMovies,
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    for (var i = 0; i < snapshot.data!.length; i++) {
                      if (popularMovies.contains(snapshot.data![i]) == false) {
                        popularMovies.add(snapshot.data![i]);
                      }
                    }
                    return body();
                  } else {
                    return progressIndicator(40);
                  }
                },
              ),
            );
          }
        },
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      title: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(
            width: 50,
            height: 50,
            child: Image.asset(
              "assets/images/moviePlaceholderImage2.jpg",
              fit: BoxFit.fill,
            ),
          ),
          const Text(
            "CinemaSerch",
            style: TextStyle(color: Colors.black),
          ),
        ],
      ),
    );
  }

  Widget progressIndicator(double distanceFromTheTopPrecenetage) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 100),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            CircularProgressIndicator(color: Colors.black),
          ],
        ),
      ],
    );
  }

  Widget errorFetchingScreen(){
    return Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  height: 2,
                ),
                errorFetchingMovies(),
                Container(
                  height: 2,
                ),
              ],
            );
  }

  Widget errorFetchingMovies() {
    return SizedBox(
      height: 200,
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: const [
              Text(
                "Ups!!! something when wrong.",
                style: TextStyle(fontSize: 20),
              ),
            ],
          ),
          const SizedBox(
            height: 4,
          ),
          const Text("We are working hard to fix it.",
              style: TextStyle(fontSize: 20)),
          const SizedBox(
            height: 10,
          ),
          TextButton.icon(
              onPressed: () {
                setState(() {
                  futureMovies = TMBDConnectionService.getPopularMovies(page);
                });
              },
              icon: const Icon(
                Icons.refresh,
                size: 50,
              ),
              label: const Text("")),
          SizedBox(
            height: 20,
          ),
          const Text("Please make sure that you are connected to the internet.",
              style: TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  Widget body() {
    return Column(
      children: [
        Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: sectionHeading()),
        SizedBox(height: bodySize, child: gridViewOrientationWrapper())
      ],
    );
  }

  Widget sectionHeading() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: const [
        Padding(
          padding: EdgeInsets.all(4.0),
          child: Text(
            "Top popular movies",
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
          ),
        ),
        // Icon(
        //   Icons.filter_alt_sharp,
        //   color: Colors.black,
        // )
      ],
    );
  }

  Future refresh() async {
    List<Movie> result = await TMBDConnectionService.getPopularMovies(page);
    setState(() {
      popularMovies.addAll(result);
      movieImageKey = UniqueKey();
    });
  }

  Widget gridViewOrientationWrapper() {
    return OrientationBuilder(builder: (context, orientation) {
      if (orientation == Orientation.landscape) {
        crossAxisCount = 4;
        popularityIndexSize = 8;
        popularityIndexFontSize = 15;
      }
      if (orientation == Orientation.portrait) {
        crossAxisCount = 2;
        popularityIndexSize = 4;
        popularityIndexFontSize = 12;
      }
      return Padding(
          padding: const EdgeInsets.all(8.0), child: refreshIndicator());
    });
  }

  Widget refreshIndicator() {
    return RefreshIndicator(
      color: Colors.black,
      onRefresh: refresh,
      child: gridViewMovies(crossAxisCount, popularMovies),
    );
  }

  Widget gridViewMovies(int crossAxisCount, List<Movie> popularMovies) {
    return GridView.builder(
        controller: gridViewScrollControlller,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: crossAxisCount, childAspectRatio: 0.61),
        itemCount: popularMovies.length,
        itemBuilder: (context, index) {
          return movieStack(index, popularMovies[index]);
        });
  }

  Widget movieStack(int index, Movie movie) {
    return GestureDetector(
      onTap: () {
        goToDetails(movie.id);
      },
      child: Stack(
        children: [movieCard(index, movie), moviePopularityRankingIndex(index)],
      ),
    );
  }

  void goToDetails(int movieId) {
    Get.find<MovieController>().addMovies(popularMovies);
    Get.to(() => const MovieDetailsScreen(), arguments: [movieId]);
  }

  Widget moviePopularityRankingIndex(int index) {
    return Container(
      width: 35,
      height: 35,
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(50), color: Colors.amber),
      child: Center(
          child: FittedBox(
        fit: BoxFit.scaleDown,
        child: Text(
          (index + 1).toString(),
          style: TextStyle(fontSize: popularityIndexFontSize),
        ),
      )),
    );
  }

  Widget movieCard(int index, Movie movie) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        color: Colors.grey[200],
        elevation: 2,
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Container(
                  decoration: BoxDecoration(border: Border.all(width: 2)),
                  child: movieImageRenderer(index, movie.posterPath)),
            ),
            const SizedBox(
              height: 4,
            ),
            movieCardTitleRow(movie.title),
            // Column(
            //   children: [
            //     TextButton(onPressed: () {}, child: Text("View details")),
            //   ],
            // )
          ],
        ),
      ),
    );
  }

  Widget movieImageRenderer(int index, String posterPath) {
    return Row(
      children: [
        Flexible(
          child: SizedBox(
              child: posterPath != ""
                  ? FadeInImage.assetNetwork(
                      key: movieImageKey,
                      placeholder:
                          "assets/images/placeholderForMoviePoster.jpg",
                      image: 'http://image.tmdb.org/t/p/w500$posterPath',
                      imageErrorBuilder: (context, error, stackTrace) {
                        return Image.asset(
                          "assets/images/placeholderForMoviePoster.jpg",
                          fit: BoxFit.fitHeight,
                        );
                      },
                      fit: BoxFit.fitHeight,
                    )
                  : Image.asset(
                      "assets/images/placeholderForMoviePoster.jpg",
                      fit: BoxFit.fitHeight,
                    )),
        )
      ],
    );
  }

  Widget movieCardTitleRow(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 1),
            child: Text(
              title,
              overflow: TextOverflow.fade,
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}
