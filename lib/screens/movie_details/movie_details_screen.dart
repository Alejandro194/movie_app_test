import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/src/widgets/placeholder.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:movie_app_test/controllers/error_controller.dart';
import 'package:movie_app_test/models/genre.dart';
import 'package:movie_app_test/models/movie.dart';
import 'package:movie_app_test/services/tmbd_connection_sevice.dart';

class MovieDetailsScreen extends StatefulWidget {
  const MovieDetailsScreen({super.key});

  @override
  State<MovieDetailsScreen> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  late Future<Movie> futureCurrentMovie;
  late Movie currentMovie;
  int movieId = 0;
  ScrollController scrollController = ScrollController();
  double movieInfoWith = 300;

  @override
  void initState() {
    if (Get.arguments != null) {
      movieId = Get.arguments[0];
      futureCurrentMovie =
          TMBDConnectionService.getMovieDetails(Get.arguments[0]);
    }
    currentMovie = Movie.emptyMovie();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBar(),
      body: Padding(
        padding: const EdgeInsets.all(4.0),
        child: GetBuilder<ErrorController>(
          builder: (_) {
            if (_.errorOcurredWhileFetchingData) {
              return errorFetchingScreen();
            } else {
              return SingleChildScrollView(
                child: FutureBuilder(
                    future: futureCurrentMovie,
                    builder: (context, snapshot) {
                      if (snapshot.hasData) {
                        currentMovie = snapshot.data!;
                        return body();
                      } else {
                        return progressIndicator(40);
                      }
                    }),
              );
            }
          },
        ),
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      backgroundColor: Colors.white,
      foregroundColor: Colors.black,
      elevation: 0,
      centerTitle: true,
      title: SizedBox(
        width: 185,
        child: Row(
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
      ),
    );
  }

  Widget errorFetchingScreen() {
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
                  futureCurrentMovie =
                      TMBDConnectionService.getMovieDetails(movieId);
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


  Widget progressIndicator(double distanceFromTheTopPrecenetage) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(
            height: 150),
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: const [
            CircularProgressIndicator(color: Colors.black),
          ],
        ),
      ],
    );
  }

  Widget body() {
    return Column(children: [
      movieImageDisplay(),
      const SizedBox(
        height: 4,
      ),
      movieInfoCard(),
      moreInfoExpansionTile()
    ]);
  }

  Widget movieImageDisplay() {
    return Stack(
      children: [
        movieBackdropRenderer(currentMovie.posterPath),
        Positioned.fill(
            child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 25),
          child: Container(
            color: Colors.black.withOpacity(0),
          ),
        )),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: movieImageRenderer(currentMovie.posterPath),
        )
      ],
    );
  }

  Widget movieBackdropRenderer(String backdroPath) {
    return SizedBox(
        height: MediaQuery.of(context).orientation == Orientation.landscape ? 300 : 400,
        width: double.infinity,
        child: backdroPath != ""
            ? FadeInImage.assetNetwork(
                placeholder: "assets/images/whiteBackdropPlaceholder.jpg",
                image: 'http://image.tmdb.org/t/p/w500$backdroPath',
                imageErrorBuilder: (context, error, stackTrace) {
                  return Image.asset(
                    "assets/images/placeholderForMoviePoster.jpg",
                    fit: BoxFit.fitHeight,
                  );
                },
                fit: BoxFit.fill,
              )
            : Image.asset(
                "assets/images/whiteBackdropPlaceholder.jpg",
                fit: BoxFit.fill,
              ));
  }

  Widget movieImageRenderer(String posterPath) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: Container(
            decoration: BoxDecoration(border: Border.all(width: 2)),
            child: SizedBox(
                height: MediaQuery.of(context).orientation == Orientation.landscape ? 300 : 410,
                child: posterPath != ""
                    ? FadeInImage.assetNetwork(
                        placeholder:
                            "assets/images/placeholderForMoviePoster.jpg",
                        image: 'http://image.tmdb.org/t/p/w500$posterPath',
                        imageErrorBuilder: (context, error, stackTrace) {
                          return Image.asset(
                            "assets/images/placeholderForMoviePoster.jpg",
                            fit: BoxFit.fitHeight,
                          );
                        },
                        fit: BoxFit.scaleDown,
                      )
                    : Image.asset(
                        "assets/images/placeholderForMoviePoster.jpg",
                        fit: BoxFit.fitHeight,
                      )),
          ),
        )
      ],
    );
  }

  Widget movieInfoCard() {
    return Card(
      color: Colors.grey[200],
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            movieTitleRow(currentMovie.title),
            movieInfoList(currentMovie, MediaQuery.of(context).orientation == Orientation.landscape ? 600 : 370),
            
            const SizedBox(
              height: 10,
            ),
            movieOverviewRow(currentMovie.overview),
            const SizedBox(
              height: 15,
            ),
            ratingStars(
                currentMovie.voteAverage / 2, 5, currentMovie.voteCount),
          ],
        ),
      ),
    );
  }

  Widget movieTitleRow(String title) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
          child: Text(
            title,
            overflow: TextOverflow.fade,
            textAlign: TextAlign.justify,
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
        ),
      ],
    );
  }

  Widget movieInfoList(Movie movie, double width) {
    final info = createMovieInfoList(movie);
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          height: 38,
          width: width,
          child: Scrollbar(
            controller: scrollController,
            thickness: 5,
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 4),
              child: ListView.builder(
                  controller: scrollController,
                  scrollDirection: Axis.horizontal,
                  itemCount: info.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 2, vertical: 2),
                      child: Container(
                          decoration:
                              BoxDecoration(border: Border.all(width: 0.2)),
                          child: Padding(
                            padding: const EdgeInsets.all(4.0),
                            child: Text(
                              info[index],
                              style:
                                  const TextStyle(fontWeight: FontWeight.w300),
                            ),
                          )),
                    );
                  }),
            ),
          ),
        ),
      ],
    );
  }

  List<String> createMovieInfoList(Movie movie) {
    List<String> info = [];
    final lan = movie.language;
    if (lan.isNotEmpty) {
      info.add(lan);
    }
    if (movie.productionCountries.isNotEmpty) {
      final countries = movie.productionCountries
          .reduce((value, element) => value + ", " + element);
      info.add(countries);
    }
    final year = movie.releaseDate.year.toString();
    if (year.isNotEmpty) {
      info.add(year);
    }
    if (movie.runtime > 0) {
      final runtime = "${movie.runtime} min";
      info.add(runtime);
    }
    if (movie.genres.isNotEmpty) {
      final genres =
          movie.genres.reduce((value, element) => value + ", " + element);
      info.add(genres);
    }

    return info;
  }

  Widget movieOverviewRow(String overview) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Flexible(
          child: Text(
            overview,
            overflow: TextOverflow.fade,
            textAlign: TextAlign.justify,
            style: const TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }

  Widget movieEconomicInfo(int budget, int revenue) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        Flexible(
          child: Row(
            children: [
              const Text(
                "Budget: ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              FittedBox(child: Text(parseEconomicValues(budget))),
            ],
          ),
        ),
        Flexible(
          child: Row(
            children: [
              const Text(
                "Revenue: ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Flexible(
                  child: Text(
                parseEconomicValues(revenue),
                overflow: TextOverflow.fade,
              )),
            ],
          ),
        )
      ],
    );
  }

  String parseEconomicValues(int value) {
    String valueToShow = "unknown";
    if (value > 0 && value >= 1000000) {
      valueToShow = "${(value / 100000).toPrecision(1)} Mill USD";
    } else if (value > 0 && value < 1000000) {
      valueToShow = "$value USD";
    }
    return valueToShow;
  }

  Widget ratingStars(double initialRating, int maxRating, int votes) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        SizedBox(
          width: 100,
          child: Row(
            children: [
              const Text(
                "Rating: ",
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                "${initialRating.toStringAsPrecision(2)}/$maxRating",
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ),
        RatingBar.builder(
          ignoreGestures: true,
          itemSize: 20,
          initialRating: initialRating,
          minRating: 1,
          direction: Axis.horizontal,
          allowHalfRating: true,
          itemCount: maxRating,
          itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
          itemBuilder: (context, _) => const Icon(
            Icons.star,
            color: Colors.amber,
          ),
          onRatingUpdate: (rating) {
            print(rating);
          },
        ),
        const SizedBox(
          width: 10,
        ),
        Text("($votes)")
      ],
    );
  }

  Widget movieRatingRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: const [
        Flexible(
          child: Text(
            "Rating: ",
            overflow: TextOverflow.fade,
            textAlign: TextAlign.justify,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ),
        Flexible(
          child: Text(
            "7/10 ",
            overflow: TextOverflow.fade,
            textAlign: TextAlign.justify,
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
        ),
        Flexible(
          child: Text(
            "(3408 votes)",
            overflow: TextOverflow.fade,
            textAlign: TextAlign.justify,
            style: TextStyle(fontSize: 14),
          ),
        ),
      ],
    );
  }

  Widget moreInfoExpansionTile() {
    return Card(
      color: Colors.grey[200],
      child: ExpansionTile(
        initiallyExpanded: false,
        tilePadding: const EdgeInsets.symmetric(horizontal: 6),
        title: const Text(
          "More info",
          style: TextStyle(color: Colors.black, fontWeight: FontWeight.bold),
        ),
        children: [moreInfoBody()],
      ),
    );
  }

  Widget moreInfoBody() {
    return SizedBox(
      height: 170,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 6),
        child:  Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: const [
                Text(
                  'Produced by:',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
              ],
            ),
            currentMovie.productionCompanies.isNotEmpty ? SizedBox(
              height: 100,
              child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: currentMovie.productionCompanies.length,
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: SizedBox(
                        width: 200,
                        height: 200,
                        child: FadeInImage.assetNetwork(
                          placeholder:
                              "assets/images/whiteBackdropPlaceholder.jpg",
                          image:
                              'http://image.tmdb.org/t/p/original/${currentMovie.productionCompanies[index].logoPath}',
                          imageErrorBuilder: (context, error, stackTrace) {
                            return Center(
                                child: Text(
                              currentMovie.productionCompanies[index].name,
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ));
                          },
                          fit: BoxFit.scaleDown,
                        ),
                      ),
                    );
                  }),
            ) : const Text("Unkown"),
            const SizedBox(
              height: 14,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child:
                  movieEconomicInfo(currentMovie.budget, currentMovie.revenue),
            ),
          ],
        ),
      ),
    );
  }


}
