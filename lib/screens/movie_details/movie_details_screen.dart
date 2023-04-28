import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:get/get.dart';
import 'package:movie_app_test/controllers/error_controller.dart';
import 'package:movie_app_test/controllers/movie_controller.dart';
import 'package:movie_app_test/models/movie.dart';

class MovieDetailsScreen extends StatefulWidget {
  const MovieDetailsScreen({super.key});

  @override
  State<MovieDetailsScreen> createState() => _MovieDetailsScreenState();
}

class _MovieDetailsScreenState extends State<MovieDetailsScreen> {
  ScrollController scrollController = ScrollController();
  double movieInfoWith = 300;

  @override
  void initState() {
    if (Get.arguments != null) {}
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
                  child: GetBuilder<MovieController>(builder: (controller) {
                if (controller.isLoading) {
                  return progressIndicator();
                } else {
                  return body();
                }
              }));
            }
          },
        ),
      ),
    );
  }

  AppBar appBar() {
    return AppBar(
      leading: GestureDetector(
          onTap: () {
            Get.back();
          },
          child: const Icon(
            Icons.arrow_back_outlined,
            color: Colors.black,
          )),
      backgroundColor: Colors.white,
      elevation: 0,
      centerTitle: true,
      title: SizedBox(
        width: 200,
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
              "CinemaSearch",
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
                if (Get.find<MovieController>().isLoading == false) {
                  Get.find<MovieController>().getMovieDetails(
                      Get.find<MovieController>().currenteMovie.id);
                }
              },
              icon: const Icon(
                Icons.refresh,
                size: 50,
              ),
              label: const Text("")),
          const SizedBox(
            height: 20,
          ),
          const Text("Please make sure that you are connected to the internet.",
              style: TextStyle(fontSize: 14)),
        ],
      ),
    );
  }

  Widget progressIndicator() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        const SizedBox(height: 150),
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
        movieBackdropRenderer(),
        Positioned.fill(
            child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 20, sigmaY: 25),
          child: Container(
            color: Colors.black.withOpacity(0),
          ),
        )),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: movieImageRenderer(),
        )
      ],
    );
  }

  Widget movieBackdropRenderer() {
    return SizedBox(
        height: MediaQuery.of(context).orientation == Orientation.landscape
            ? 300
            : 400,
        width: double.infinity,
        child: GetBuilder<MovieController>(
          builder: (controller) {
            return FadeInImage.assetNetwork(
              placeholder: "assets/images/whiteBackdropPlaceholder.jpg",
              image:
                  'http://image.tmdb.org/t/p/w500${controller.currenteMovie.posterPath}',
              imageErrorBuilder: (context, error, stackTrace) {
                return Image.asset(
                  "assets/images/placeholderForMoviePoster.jpg",
                  fit: BoxFit.fitHeight,
                );
              },
              fit: BoxFit.fill,
            );
          },
        ));
  }

  Widget movieImageRenderer() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(
            child: Container(
          decoration: BoxDecoration(border: Border.all(width: 2)),
          child: SizedBox(
              height:
                  MediaQuery.of(context).orientation == Orientation.landscape
                      ? 300
                      : 410,
              child: GetBuilder<MovieController>(
                builder: (controller) {
                  return FadeInImage.assetNetwork(
                    placeholder: "assets/images/placeholderForMoviePoster.jpg",
                    image:
                        'http://image.tmdb.org/t/p/w500${controller.currenteMovie.posterPath}',
                    imageErrorBuilder: (context, error, stackTrace) {
                      return Image.asset(
                        "assets/images/placeholderForMoviePoster.jpg",
                        fit: BoxFit.fitHeight,
                      );
                    },
                    fit: BoxFit.scaleDown,
                  );
                },
              )),
        ))
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
            movieTitleRow(),
            movieInfoList(
                MediaQuery.of(context).orientation == Orientation.landscape
                    ? 600
                    : 370),
            const SizedBox(
              height: 10,
            ),
            movieOverviewRow(),
            const SizedBox(
              height: 15,
            ),
            ratingStars(),
          ],
        ),
      ),
    );
  }

  Widget movieTitleRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Flexible(child: GetBuilder<MovieController>(
          builder: (controller) {
            return Text(
              controller.currenteMovie.title,
              overflow: TextOverflow.fade,
              textAlign: TextAlign.justify,
              style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            );
          },
        )),
      ],
    );
  }

  Widget movieInfoList(double width) {
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
                child: GetBuilder<MovieController>(
                  builder: (controller) {
                    final info = createMovieInfoList(controller.currenteMovie);
                    return ListView.builder(
                        controller: scrollController,
                        scrollDirection: Axis.horizontal,
                        itemCount: info.length,
                        itemBuilder: (context, index) {
                          return Padding(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 2, vertical: 2),
                            child: Container(
                                decoration: BoxDecoration(
                                    border: Border.all(width: 0.2)),
                                child: Padding(
                                  padding: const EdgeInsets.all(4.0),
                                  child: Text(
                                    info[index],
                                    style: const TextStyle(
                                        fontWeight: FontWeight.w300),
                                  ),
                                )),
                          );
                        });
                  },
                )),
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
          .reduce((value, element) => "$value, $element");
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
          movie.genres.reduce((value, element) => "$value, $element");
      info.add(genres);
    }

    return info;
  }

  Widget movieOverviewRow() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.start,
      children: [
        Flexible(child: GetBuilder<MovieController>(
          builder: (controller) {
            return Text(
              controller.currenteMovie.overview,
              overflow: TextOverflow.fade,
              textAlign: TextAlign.justify,
              style: const TextStyle(fontSize: 14),
            );
          },
        )),
      ],
    );
  }

  Widget movieEconomicInfo() {
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
              GetBuilder<MovieController>(builder: (controller) {
                return FittedBox(
                    child: Text(
                        parseEconomicValues(controller.currenteMovie.budget)));
              })
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
                  child: GetBuilder<MovieController>(builder: (controller) {
                return FittedBox(
                    child: Text(
                        parseEconomicValues(controller.currenteMovie.revenue)));
              })),
            ],
          ),
        )
      ],
    );
  }

  String parseEconomicValues(int value) {
    String valueToShow = "unknown";
    if (value > 0 && value >= 1000000) {
      valueToShow = "${(value / 1000000).toPrecision(1)} Mill USD";
    } else if (value > 0 && value < 1000000) {
      valueToShow = "$value USD";
    }
    return valueToShow;
  }

  Widget ratingStars() {
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
              GetBuilder<MovieController>(builder: (controller) {
                return Text(
                  "${(controller.currenteMovie.voteAverage / 2).toStringAsPrecision(2)}/5",
                  style: const TextStyle(fontWeight: FontWeight.bold),
                );
              })
            ],
          ),
        ),
        GetBuilder<MovieController>(builder: (controller) {
          return RatingBar.builder(
            ignoreGestures: true,
            itemSize: 20,
            initialRating: controller.currenteMovie.voteAverage / 2,
            minRating: 1,
            direction: Axis.horizontal,
            allowHalfRating: true,
            itemCount: 5,
            itemPadding: const EdgeInsets.symmetric(horizontal: 4.0),
            itemBuilder: (context, _) => const Icon(
              Icons.star,
              color: Colors.amber,
            ),
            onRatingUpdate: (rating) {},
          );
        }),
        const SizedBox(
          width: 10,
        ),
        GetBuilder<MovieController>(builder: (controller) {
          return Text(controller.currenteMovie.voteCount.toString());
        })
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
        child: Column(
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
            GetBuilder<MovieController>(builder: (controller) {
              if (controller.currenteMovie.productionCompanies.isEmpty) {
                return const Text(
                  "Unkown",
                  style: TextStyle(fontWeight: FontWeight.bold),
                );
              } else {
                return SizedBox(
                    height: 100,
                    child: GetBuilder<MovieController>(builder: (controller) {
                      return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          itemCount: controller
                              .currenteMovie.productionCompanies.length,
                          itemBuilder: (context, index) {
                            return Padding(
                              padding: const EdgeInsets.all(8.0),
                              child: SizedBox(
                                  width: 200,
                                  height: 200,
                                  child: GetBuilder<MovieController>(
                                      builder: (controller) {
                                    return FadeInImage.assetNetwork(
                                      placeholder:
                                          "assets/images/whiteBackdropPlaceholder.jpg",
                                      image:
                                          'http://image.tmdb.org/t/p/original/${controller.currenteMovie.productionCompanies[index].logoPath}',
                                      imageErrorBuilder:
                                          (context, error, stackTrace) {
                                        return Center(
                                            child: GetBuilder<MovieController>(
                                          builder: (controller) {
                                            return Text(
                                              controller
                                                  .currenteMovie
                                                  .productionCompanies[index]
                                                  .name,
                                              style: const TextStyle(
                                                  fontWeight: FontWeight.bold),
                                            );
                                          },
                                        ));
                                      },
                                      fit: BoxFit.scaleDown,
                                    );
                                  })),
                            );
                          });
                    }));
              }
            }),
            const SizedBox(
              height: 14,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 2),
              child: movieEconomicInfo(),
            ),
          ],
        ),
      ),
    );
  }
}
